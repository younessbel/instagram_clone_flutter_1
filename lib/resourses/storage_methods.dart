import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageTostorage(
      String childName, Uint8List file, bool is_post) async {
    Reference ref =
        firebaseStorage.ref().child(childName).child(_auth.currentUser!.uid);
    if (is_post) {
      print('object===');
      String idpos = Uuid().v1();
      ref = ref.child(idpos);
      print('object===');
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
