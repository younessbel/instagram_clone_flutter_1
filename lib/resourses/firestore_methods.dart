import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagrem/models/posts.dart';
import 'package:instagrem/resourses/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String> upploadPost(String desc, Uint8List file, String uid,
      String username, String profIm) async {
    String res = 'Some error happened';
    try {
      String photoUrl =
          await StorageMethods().uploadImageTostorage('posts', file, true);
      String postId = Uuid().v1();
      Posts post = Posts(
          datePublished: DateTime.now(),
          username: username,
          uid: uid,
          desc: desc,
          postId: postId,
          profim: profIm,
          photoUrl: photoUrl,
          likes: []);
      _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());
      res = 'succes';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeComment(
      String postId, String commentID, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentID)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> PostComment(String postID, String uid, String text,
      String name, String profilePics) async {
    String res = 'Some error Ocured';
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePis': profilePics,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datepub': DateTime.now(),
          'likes': []
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

// Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // if (kDebugMode) print(e.toString());
    }
  }
}
