import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utilis/colors.dart';
import 'package:instagram_clone/utilis/global_variables.dart';
import 'package:instagram_clone/utilis/icon.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                "assets/logos/Instagram_logo1.svg",
                height: 50,
                color: Colors.white,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(MyFlutterApp.expand_plus),
                ),
                const SizedBox(
                  width: 25,
                ),
                const Icon(
                  MyFlutterApp.messenger,
                  size: 30,
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 20,
            ),
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            height: 120,
            width: 600,
            child: const Stories(),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("posts").snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width > webScreenSize ? width * 0.3 : 0,
                      vertical: width > webScreenSize ? 15 : 0,
                    ),
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//dummy static stories data.
class Stories extends StatelessWidget {
  const Stories({
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
                    "https://images.pexels.com/photos/13694870/pexels-photo-13694870.png?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your story",
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
                    "https://images.pexels.com/photos/13709301/pexels-photo-13709301.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "inii_edk",
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
                    "https://images.pexels.com/photos/13365744/pexels-photo-13365744.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "perry",
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
                    "https://images.pexels.com/photos/13013833/pexels-photo-13013833.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "zo!",
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
                    "https://images.pexels.com/photos/13729108/pexels-photo-13729108.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "chris",
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
                    "https://images.pexels.com/photos/10406699/pexels-photo-10406699.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "jummy",
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
                    "https://images.pexels.com/photos/9869141/pexels-photo-9869141.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "daps",
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
