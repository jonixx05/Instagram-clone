import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/auth_method.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}













// class UserProvider with ChangeNotifier {
//   User? _user;
//   final AuthMethods _authMethods = AuthMethods();

//   User get getUser => _user!;

//   Future<void> refreshUser() async {
//     User user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }
// // class UserProvider with ChangeNotifier {
// //   User? _user;
// //   final AuthMethods _authMethods = AuthMethods();

// //   User? get getUser => _user; //getting the user from different part of the app

// //   //function used to update the value of the user
// //   Future<void> refreshUser() async {
// //     User user = await _authMethods.getUserDetails();
// //     _user = user;
// //     notifyListeners();
// //   }
// // }
