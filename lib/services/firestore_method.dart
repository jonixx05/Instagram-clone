import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/services/storage_method.dart';
import 'package:uuid/uuid.dart';

///data database (firestore)
class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String userName,
    String profImage,
  ) async {
    String response = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        "posts",
        file,
        true,
      );
      //v1 creates a unique id based on the time user posted
      String postId = const Uuid().v1();
      //create a post
      Post post = Post(
        uid: uid,
        userName: userName,
        postId: postId,
        postUrl: photoUrl,
        datePublished: DateTime.now(),
        description: description,
        profImage: profImage,
        likes: [],
      );
      //upload post to firestore
      _firestore.collection("posts").doc(postId).set(
            post.toJson(),
          );
      response = "Success";
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  //sending likes to firestore
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      //remove likes from "likes" list
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        //add likes to the list of likes
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //sending user comment to database
  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      //check if text is not empty.
      //The text is the user comment on the post
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //following
  Future<void> followUser(
    String uid,
    String followId,
  ) async {
    try {
      //get snapshot of user data to
      //know if the user is already  following or not
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];

      if (following.contains(followId)) {
        await _firestore.collection("users").doc(followId).update(
          {
            "followers": FieldValue.arrayRemove(
              [uid],
            ), //remove the user by uid if following
          },
        );
        await _firestore.collection("users").doc(uid).update(
          {
            "following": FieldValue.arrayRemove(
              [followId],
            ), //remove the user followId if  following
          },
        );
      } else {
        await _firestore.collection("users").doc(followId).update(
          {
            "followers": FieldValue.arrayUnion(
              [uid],
            ), //add the user by uid if not following
          },
        );
        await _firestore.collection("users").doc(uid).update(
          {
            "following": FieldValue.arrayUnion(
              [followId],
            ), //add the user by followId if not following
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
