import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/services/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //function which get the user details from firebase
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    // print('documentSnapshot: $snap');

    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String response = "Some error occured";
    try {
      if (email.isNotEmpty ||
          userName.isNotEmpty ||
          password.isNotEmpty ||
          fullName.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //  print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePic", file, false);
        //Creating user
        model.User user = model.User(
          uid: cred.user!.uid,
          fullName: fullName,
          userName: userName,
          email: email,
          photoUrl: photoUrl,
          followers: [],
          following: [],
          bio: bio,
        );
        //add user to our database
        await _firestore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );
        response = "success";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        response = "Invalid email address";
      } else if (error.code == "weak-password") {
        response = "Password should be more than 6 characters";
      }
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  //Log in user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String response = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        response = "success";
      } else {
        response = "Please enter all the fields";
      }
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
