import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagrem/resourses/auth_methods.dart';
import 'package:instagrem/screens/login_screen.dart';
import 'package:instagrem/screens/mobile_screen_layout.dart';
import 'package:instagrem/utils/colors.dart';
import 'package:instagrem/utils/utils.dart';
import 'package:instagrem/widgets/text_field_mine.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Uint8List? _Image;
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    bioController.dispose();
  }

  Future<void> selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _Image = im;
    });
  }

  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        bio: bioController.text,
        username: userNameController.text,
        file: _Image!);
    setState(() {
      _isLoading = false;
    });
    if (res != 'succes') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MobileScreenLayout()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Stack(
              children: [
                _Image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_Image!),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-shapes-2-free/128/social-instagram-new-circle-1024.png',
                        ),
                      ),
                Positioned(
                    left: 80,
                    bottom: -10,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          size: 30,
                          Icons.add_a_photo,
                          color: Colors.white,
                        )))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldeMine(
                name: 'Enter Username',
                controller: userNameController,
                password: false,
                textInputTypee: TextInputType.text),
            SizedBox(
              height: 16,
            ),
            TextFieldeMine(
                name: 'Your email',
                controller: emailController,
                password: false,
                textInputTypee: TextInputType.emailAddress),
            SizedBox(
              height: 16,
            ),
            TextFieldeMine(
                name: 'Your password',
                controller: passwordController,
                password: true,
                textInputTypee: TextInputType.text),
            SizedBox(
              height: 15,
            ),
            TextFieldeMine(
                name: 'Bio',
                controller: bioController,
                password: false,
                textInputTypee: TextInputType.text),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: signUp,
              child: _isLoading == true
                  ? CircularProgressIndicator()
                  : Container(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(14),
                      decoration: ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'you have an accout?',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'sign in',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
