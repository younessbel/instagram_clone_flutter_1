import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagrem/models/user.dart' as mdel;
import 'package:instagrem/providers/user_provider.dart';
import 'package:instagrem/resourses/firestore_methods.dart';
import 'package:instagrem/screens/comments.dart';
import 'package:instagrem/utils/colors.dart';
import 'package:instagrem/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post_data;
  const PostCard({
    Key? key,
    required this.post_data,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentlength = 0;
  List commrnts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentnumber();
  }

  void commentnumber() async {
    final snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post_data['postId'])
        .collection('comments')
        .get();
    commrnts = snap.docs;
    commentlength = snap.docs.length;
  }

  bool isLikeanimating = false;
  @override
  Widget build(BuildContext context) {
    final mdel.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.post_data['profim']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post_data['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding: EdgeInsets.symmetric(vertical: 16.3),
                                  shrinkWrap: true,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: Text('Delete')),
                                  ]
                                      .map((e) => InkWell(
                                          onTap: () {
                                            FirestoreMethods().deletePost(
                                                widget.post_data['postId']);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text('delete'),
                                          )))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: Icon(Icons.threed_rotation))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              FirestoreMethods().likePost(
                widget.post_data['postId'].toString(),
                user!.uid,
                widget.post_data['likes'],
              );
              setState(() {
                isLikeanimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  child: Image.network(
                      fit: BoxFit.fill, widget.post_data['photoUrl']),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity: isLikeanimating ? 1 : 0,
                  child: LikeAniamationn(
                    child: const Icon(
                      Icons.favorite,
                      size: 70,
                      color: Colors.white,
                    ),
                    isanimateing: isLikeanimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeanimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeAniamationn(
                    isanimateing: widget.post_data['likes'].contains(user?.uid),
                    child: IconButton(
                        onPressed: () {
                          FirestoreMethods().likePost(
                            widget.post_data['postId'].toString(),
                            user!.uid,
                            widget.post_data['likes'],
                          );
                        },
                        icon: widget.post_data['likes'].contains(user?.uid)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                              )),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                  postIdd:
                                      widget.post_data['postId'].toString(),
                                )));
                      },
                      icon: Icon(Icons.comment)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${(widget.post_data['likes'] as List).length} Likes",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    widget.post_data['desc'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 0),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: primaryColor),
                          children: [
                        TextSpan(
                          text: commrnts.length == 0 ? '' : commrnts[0]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: commrnts.length == 0
                              ? 'make first comment'
                              : "  ${commrnts[0]['text']}",
                        )
                      ])),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              postIdd: widget.post_data['postId'].toString(),
                            )));
                  },
                  child: Text(
                    "${commentlength} Comments",
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
                Container(
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.post_data['datePublished'].toDate()),
                    style: TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

extension on TextTheme {
  get bodyText2 => null;
}
