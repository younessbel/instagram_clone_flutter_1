import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String desc;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String photoUrl;
  final String profim;
  final  likes;

  Posts(
      {required this.datePublished,
      required this.username,
      required this.uid,
      required this.desc,
      required this.postId,
      required this.profim,
      required this.photoUrl,
      required this.likes});
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'desc': desc,
        'likes': likes,
        'profim': profim,
        'datePublished': datePublished,
        'postId': postId,
        'photoUrl': photoUrl
      };
  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Posts(
        username: snapshot['username'],
        uid: snapshot['uid'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        desc: snapshot['desc'],
        photoUrl: snapshot['photoUrl'],
        profim: snapshot['profim'],
        likes: snapshot['likes']);
  }
}
