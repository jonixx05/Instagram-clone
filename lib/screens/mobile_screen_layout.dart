import 'package:flutter/material.dart';

import 'package:instagram_clone/utilis/colors.dart';
import 'package:instagram_clone/utilis/global_variables.dart';
import 'package:instagram_clone/utilis/icon.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //function which controls the page displayed on tapping the bottom
  //navigation bar items
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigationTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _page == 0 ? MyFlutterApp.home3 : MyFlutterApp.home3,
              color: _page == 0 ? primaryColor : secondaryColor,
              size: _page == 0 ? 40 : 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MyFlutterApp.search,
              color: _page == 1 ? primaryColor : secondaryColor,
              size: _page == 1 ? 40 : 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _page == 2 ? primaryColor : secondaryColor,
              size: _page == 2 ? 40 : 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _page == 3 ? Icons.favorite : Icons.favorite_outline,
              color: _page == 3 ? primaryColor : secondaryColor,
              size: _page == 3 ? 40 : 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
              size: _page == 4 ? 40 : 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
