import 'package:flutter/material.dart';
import 'package:instagrem/resourses/auth_methods.dart';
import 'package:instagrem/screens/mobile_screen_layout.dart';
import 'package:instagrem/screens/registe_screen.dart';
import 'package:instagrem/utils/colors.dart';
import 'package:instagrem/utils/utils.dart';
import 'package:instagrem/widgets/text_field_mine.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> login_user() async {
    setState(() {
      isloading = true;
    });
    String res = await AuthMethods()
        .Login_user(emailController.text, passwordController.text);
    setState(() {
      isloading = false;
    });
    if (res == 'succes') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MobileScreenLayout()));
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esi Insta'),
        centerTitle: true,
      ),
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
            Icon(
              Icons.logo_dev_outlined,
              size: 100,
            ),
            SizedBox(
              height: 10,
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
            GestureDetector(
              onTap: login_user,
              child: Container(
                child: isloading == true
                    ? CircularProgressIndicator()
                    : Text('Sign in'),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RegisterScreen()));
                  },
                  child: Text('Register'),
                )
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
