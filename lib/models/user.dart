import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String fullName;
  final String userName;
  final String email;
  final String photoUrl;
  final List followers;
  final List following;
  final String bio;

  const User({
    required this.uid,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.bio,
  });

  //request for firebase DocumentSnapshot as map
  static User fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapShot["uid"],
      userName: snapShot["userName"],
      fullName: snapShot["fullName"],
      email: snapShot["email"],
      photoUrl: snapShot["photoUrl"],
      followers: snapShot["followers"],
      following: snapShot["following"],
      bio: snapShot["bio"],
    );
  }

//convert map to json since we send data to the server in json format
  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "userName": userName,
        "uid": uid,
        "bio": bio,
        "email": email,
        "followers": followers,
        "following": following,
        "photoUrl": photoUrl,
      };
}
