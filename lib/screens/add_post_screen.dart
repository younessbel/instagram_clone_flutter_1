import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagrem/models/user.dart';
import 'package:instagrem/providers/user_provider.dart';
import 'package:instagrem/resourses/firestore_methods.dart';
import 'package:instagrem/utils/colors.dart';
import 'package:instagrem/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isloading = false;
  final TextEditingController _descController = TextEditingController();
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('chose Image'),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                child: Text('Pick Image'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                child: Text('from gallery'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel'),
              )
            ],
          );
        });
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isloading = true;
    });
    try {
      String res = await FirestoreMethods()
          .upploadPost(_descController.text, _file!, uid, username, profImage);
      if (res == 'succes') {
        setState(() {
          isloading = false;
        });
        clearImage();
        showSnackBar('posted', context);
      } else {
        setState(() {
          isloading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () => _selectImage(context),
                icon: Icon(
                  Icons.upload,
                  size: 140,
                )),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Post to'),
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user!.uid, user.username, user.photoUrl),
                  child: isloading == true
                      ? CircularProgressIndicator()
                      : Text(
                          'Upload',
                          style: TextStyle(color: blueColor),
                        ),
                )
              ],
              leading: IconButton(
                  onPressed: clearImage, icon: Icon(Icons.arrow_back)),
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: _descController,
                        decoration:
                            InputDecoration(hintText: 'Write a caption'),
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(
                        width: 45,
                        height: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 455,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter)),
                          ),
                        ))
                  ],
                )
              ],
            ),
          );
  }
}
