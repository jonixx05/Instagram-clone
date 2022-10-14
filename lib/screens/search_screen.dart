import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utilis/colors.dart';
import 'package:instagram_clone/utilis/icon.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Container(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 46, 44, 44),
          ),
          child: Row(
            children: [
              const Icon(MyFlutterApp.search),
              Expanded(
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                  ),
                  onFieldSubmitted: (String _) {
                    setState(() {
                      isShowUser = true;
                    });
                    print(_);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: isShowUser
          ? Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where(
                      "userName",
                      isGreaterThan: searchController.text,
                      //search for users by username
                    )
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      //list of searched users
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          //redirected to the searched user profile screen on tapping
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: snapshot.data!.docs[index]["uid"],
                              ),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                snapshot.data!.docs[index]["photoUrl"],
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]["userName"],
                            ),
                          ),
                        );
                      });
                },
              ),
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  width: double.infinity,
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    padding: const EdgeInsets.all(4),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Container(
                      color: Colors.transparent,
                      child: Image.network(
                        snapshot.data!.docs[index]["postUrl"],
                        fit: BoxFit.cover,
                      ),
                    ),
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                      1,
                      index.isEven ? 1.2 : 2,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
