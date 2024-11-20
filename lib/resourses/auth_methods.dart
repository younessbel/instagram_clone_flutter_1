import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagrem/models/user.dart' as model;
import 'package:instagrem/resourses/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fire = FirebaseFirestore.instance;
  Future<model.User> getUserDetails() async {
    DocumentSnapshot snap =
        await _fire.collection('users').doc(_auth.currentUser!.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String bio,
      required String username,
      required Uint8List file}) async {
    String res = 'Some Error ocurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print('user id ${userCredential.user!.uid}');
        String Photourl = await StorageMethods()
            .uploadImageTostorage('profilePics', file, false);
        model.User user = model.User(
            username: username,
            uid: userCredential.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: Photourl);
        await _fire
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        res = 'succes';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = ' the email is badly formated';
      } else if (err.code == 'weak-password') {
        res = 'your password is weak';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> Login_user(String email, String password) async {
    String res = 'Error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'succes';
      } else {
        res = 'please enter your email and password';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
