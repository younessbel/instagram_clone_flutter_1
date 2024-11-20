import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagrem/resourses/auth_methods.dart';
import 'package:instagrem/resourses/firestore_methods.dart';
import 'package:instagrem/screens/login_screen.dart';
import 'package:instagrem/utils/utils.dart';
import 'package:instagrem/widgets/follow_button.dart';

class Profile extends StatefulWidget {
  final String uid;

  const Profile({super.key, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool is_loading = false;

  bool isFollowing = false;
  int postlen = 0;
  var userData = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    is_loading = true;
    try {
      print('object ${widget.uid}');
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postlen = postSnap.docs.length;
      userData = userSnap.data()! as Map<dynamic, dynamic>;
      isFollowing = (userData['followers'] as List)
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    is_loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(is_loading ? 'waiting' : " ${userData['username']}"),
      ),
      body: is_loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Column(
                  children: [
                    Row(children: [
                      SizedBox(
                          width: 70,
                          height: 70,
                          child: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage:
                                  NetworkImage("${userData['photoUrl']}"))),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$postlen',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'posts',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(userData['followers']).length}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Folowers',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(userData['following']).length}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Following',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                        userData['uid']
                                    ? FollowButton(
                                        label: 'sign out',
                                        onPressed: () async {
                                          await AuthMethods().signOut();
                                          if (context.mounted) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            label: 'Follow out',
                                            onPressed: () async {
                                              await FirestoreMethods()
                                                  .followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid'],
                                              );

                                              setState(() {
                                                isFollowing = false;
                                              });
                                            },
                                          )
                                        : FollowButton(
                                            label: 'Follow',
                                            onPressed: () async {
                                              await FirestoreMethods()
                                                  .followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid'],
                                              );

                                              setState(() {
                                                isFollowing = true;
                                              });
                                            },
                                          )
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${(userData['username'])}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, left: 8),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${(userData['bio'])}',
                        ),
                      ),
                    ),
                    Divider(),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text('Has no data'),
                            );
                          }
                          return SizedBox(
                            width: double.infinity,
                            child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 1.5),
                                itemCount: postlen,
                                itemBuilder: (c, i) {
                                  DocumentSnapshot snpa =
                                      (snapshot.data!).docs[i];
                                  return Container(
                                    child: Image(
                                      image: NetworkImage((snpa.data()!
                                          as dynamic)['photoUrl']),
                                    ),
                                  );
                                }),
                          );
                        })
                  ],
                )
              ],
            ),
    );
  }
}
