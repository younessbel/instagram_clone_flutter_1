import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String im;
  final String username;
  final String comment;
  final bool is_like;
  const CommentCard(
      {super.key,
      required this.im,
      required this.username,
      required this.comment,
      required this.is_like});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(im),
      title: Text(username),
      subtitle: Text(comment),
      trailing: IconButton(
          onPressed: () {},
          icon: is_like ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
    );
  }
}
