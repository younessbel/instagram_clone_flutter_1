import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagrem/models/user.dart';
import 'package:instagrem/providers/user_provider.dart';
import 'package:instagrem/resourses/firestore_methods.dart';
import 'package:instagrem/utils/colors.dart';
import 'package:instagrem/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postIdd;
  const CommentsScreen({super.key, required this.postIdd});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          'Comments',
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postIdd)
              .collection('comments')
              .snapshots(),
          builder: (context, snpashot) {
            if (snpashot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: blueColor,
                ),
              );
            }
            return ListView.builder(
                itemCount: (snpashot.data! as dynamic).docs.length,
                itemBuilder: (c, i) => InkWell(
                      onDoubleTap: () async {
                        await FirestoreMethods().likeComment(
                            widget.postIdd,
                            (snpashot.data! as dynamic).docs[i]['commentId'],
                            user.uid,
                            ((snpashot.data! as dynamic).docs[i]['likes']
                                as List));
                      },
                      child: CommentCard(
                          im: (snpashot.data! as dynamic).docs[i]['profilePis'],
                          username: (snpashot.data! as dynamic).docs[i]['name'],
                          comment: (snpashot.data! as dynamic).docs[i]['text'],
                          is_like: ((snpashot.data! as dynamic).docs[i]['likes']
                                  as List)
                              .contains(user!.uid)),
                    ));
          }),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Comment as username'),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethods().PostComment(
                  widget.postIdd,
                  user.uid,
                  textEditingController.text,
                  user.username,
                  user.photoUrl,
                );
                setState(() {
                  textEditingController.text = '';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  'Comment',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
