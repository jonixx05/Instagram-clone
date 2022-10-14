import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String userName;
  final String postId;
  final String postUrl;
  final String description;
  final String profImage;
  final datePublished;
  final likes;

  const Post({
    required this.uid,
    required this.userName,
    required this.postId,
    required this.postUrl,
    required this.datePublished,
    required this.description,
    required this.profImage,
    required this.likes,
  });

  //request for firebase DocumentSnapshot as map
  static Post fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;

    return Post(
      uid: snapShot["uid"],
      userName: snapShot["userName"],
      datePublished: snapShot["datePublished"],
      description: snapShot["description"],
      postId: snapShot["postId"],
      postUrl: snapShot["postUrl"],
      profImage: snapShot["profImage"],
      likes: snapShot["likes"],
    );
  }

  //convert map to json
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userName": userName,
        "datePublished": datePublished,
        "description": description,
        "postId": postId,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
      };
}
