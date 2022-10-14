import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/services/firestore_method.dart';
import 'package:instagram_clone/utilis/colors.dart';
import 'package:instagram_clone/utilis/image_picker.dart';
import 'package:instagram_clone/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  ///post data to firebase
  void postImage(
    String uid,
    String userName,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String response = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        userName,
        profImage,
      );

      if (response == "Success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          content: "Posted!",
          context: context,
        );
        clearImage();
      } else {
        showSnackBar(
          content: response,
          context: context,
        );
      }
    } catch (e) {
      showSnackBar(
        content: e.toString(),
        context: context,
      );
    }
  }

  //function to allow user to select the image to be posted
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Create a post"),
        children: [
          //allows user to select a post via camera
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Take a photo"),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          //allows user to select a post via gallery
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Choose from gallery"),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Cancel"),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(
                Icons.upload,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user.uid,
                    user.userName,
                    user.photoUrl,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _isLoading
                        ? const LinearProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(),
                          ),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            user.photoUrl,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              hintText: "Write a caption...",
                              border: InputBorder.none,
                            ),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.width / 450,
                      child: Container(
                        width: double.infinity,
                        child: Image(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
