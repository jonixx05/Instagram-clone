import 'package:flutter/material.dart';

import 'package:instagram_clone/utilis/global_variables.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  //Adds data to our screens by using provider to call refresh user
  ///which updates the user when there are changes

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(

        ///helps us make our app responsive
        ///The constraint gives us  the constraint of the app size which
        ///enables flutter to do the responsive work
        builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        //display web screen layout
        return widget.webScreenLayout;
      } else {
        //display mobile screen layout
        return widget.mobileScreenLayout;
      }
    });
  }
}
