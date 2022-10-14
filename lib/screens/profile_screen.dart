import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/services/auth_method.dart';
import 'package:instagram_clone/services/firestore_method.dart';
import 'package:instagram_clone/utilis/colors.dart';
import 'package:instagram_clone/utilis/icon.dart';
import 'package:instagram_clone/widgets/follow-button.dart';
import 'package:instagram_clone/widgets/snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  //get data from database
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      //get length of   the user post length
      //this is done by going to the post collection in the firebasefirestore and
      //then get the post by the uid...
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where(
            "uid",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .get();
      postLength = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!["followers"].length;
      following = userSnap.data()!["following"].length;
      isFollowing = userSnap.data()!["followers"].contains(
            FirebaseAuth.instance.currentUser!.uid,
          );
      setState(() {});
    } catch (e) {
      showSnackBar(
        content: e.toString(),
        context: context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData["userName"]),
              centerTitle: false,
              actions: [
                const Icon(MyFlutterApp.plus),
                const SizedBox(
                  width: 25,
                ),
                IconButton(
                  onPressed: () async {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text(
                          "Log out",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await AuthMethods().signOut();
                              Navigator.of(ctx).pop();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.menu_outlined,
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            //drawer: Drawer(),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              userData["photoUrl"],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLength, "Posts"),
                                    buildStatColumn(followers, "Followers"),
                                    buildStatColumn(following, "Following"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData["userName"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 2,
                        ),
                        child: Text(
                          userData["bio"],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //if the uid in firebase auth equals the uid of the user then
                          //allow the user to edit the profile
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? FollowButton(
                                  backgroundColor: mobileBackgroundColor,
                                  borderColor: Colors.grey,
                                  text: "Edit Profile",
                                  textColor: primaryColor,
                                  function: () async {
                                    await FirestoreMethods().followUser(
                                      FirebaseAuth
                                          .instance.currentUser!.uid, //user id
                                      userData["uid"], //followId
                                    );
                                  },
                                )
                              : isFollowing
                                  ? Row(
                                      children: [
                                        FollowButton(
                                          backgroundColor: Colors.white,
                                          borderColor: Colors.grey,
                                          text: "Unfollow",
                                          textColor: Colors.black,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid, //user id
                                              userData["uid"], //followId
                                            );
                                            setState(() {
                                              isFollowing = false;
                                              followers--;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const FollowButton(
                                          backgroundColor:
                                              mobileBackgroundColor,
                                          borderColor: Colors.grey,
                                          text: "Message",
                                          textColor: primaryColor,
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        FollowButton(
                                          backgroundColor: Colors.blue,
                                          borderColor: Colors.blue,
                                          text: "Follow",
                                          textColor: primaryColor,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                              FirebaseAuth.instance.currentUser!
                                                  .uid, //user id
                                              userData["uid"], //followId
                                            );
                                            setState(() {
                                              isFollowing = true;
                                              followers++;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const FollowButton(
                                          backgroundColor:
                                              mobileBackgroundColor,
                                          borderColor: Colors.grey,
                                          text: "Message",
                                          textColor: primaryColor,
                                        )
                                      ],
                                    )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        height: 120,
                        width: double.infinity,
                        child: const HighLights(),
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("posts")
                            .where("uid", isEqualTo: widget.uid)
                            .get(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  snapshot.data!.docs[index];
                              return Container(
                                child: Image(
                                  image: NetworkImage(
                                    snapshot.data!.docs[index]["postUrl"],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 5,
          ),
          child: Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class HighLights extends StatelessWidget {
  const HighLights({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Column(
            children: const [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/6424586/pexels-photo-6424586.jpeg?auto=compress&cs=tinysrgb&w=600"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "code.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: const [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/6770610/pexels-photo-6770610.jpeg?auto=compress&cs=tinysrgb&w=600"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "chart.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: const [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/116675/pexels-photo-116675.jpeg?auto=compress&cs=tinysrgb&w=600"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "range_rover.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: const [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/4210252/pexels-photo-4210252.jpeg?auto=compress&cs=tinysrgb&w=600"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "nature.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
