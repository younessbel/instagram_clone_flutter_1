import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagrem/providers/user_provider.dart';
import 'package:instagrem/screens/add_post_screen.dart';
import 'package:instagrem/screens/feed_screen.dart';
import 'package:instagrem/screens/profile.dart';
import 'package:instagrem/screens/search_screen.dart';
import 'package:instagrem/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  List<Widget> pages = [
    FeedScreen(),
    SearchScreen(),
    AddPostScreen(),
    Profile(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  int initPage = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    addData();
  }

  addData() async {
    UserProvider _userPRovider = Provider.of(context, listen: false);
    await _userPRovider.refreshUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  _navigatePage(int page) {
    pageController.jumpToPage(page);
  }

  onPageChanged(int page) {
    setState(() {
      initPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          // onTap: (val) {
          //   setState(() {
          //     initPage = val;
          //   });
          // },
          onTap: _navigatePage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: initPage == 0 ? blueColor : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: initPage == 1 ? blueColor : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: initPage == 2 ? blueColor : Colors.white,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: initPage == 3 ? blueColor : Colors.white,
                ),
                label: ''),
          ],
        ),
        body: PageView(
          children: pages,
          onPageChanged: onPageChanged,
          controller: pageController,
        ));
  }
}
