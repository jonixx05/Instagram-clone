import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/web_screen_layout.dart';
import 'package:instagram_clone/services/auth_method.dart';
import 'package:instagram_clone/utilis/colors.dart';
import 'package:instagram_clone/widgets/textfield.dart';

import '../responsive/responsive_layout.dart';
import '../utilis/image_picker.dart';
import '../widgets/snack_bar.dart';
import 'login_screen.dart';
import 'mobile_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  ///signup
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    final String response = await AuthMethods().signUpUser(
      fullName: _fullNameController.text,
      userName: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (response != "success") {
      showSnackBar(content: response, context: context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 0,
          right: 15,
          left: 15,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SvgPicture.asset(
                      "assets/logos/Instagram_logo1.svg",
                      height: 70,
                      width: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(
                                _image!,
                              ),
                            )
                          : const CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.webp",
                              ),
                            ),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: TextFieldInput(
                          hintText: 'Full Name',
                          textEditingController: _fullNameController,
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: TextFieldInput(
                          hintText: 'Username',
                          textEditingController: _usernameController,
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: TextFieldInput(
                          hintText: 'Email Address',
                          textEditingController: _emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: TextFieldInput(
                          isPassword: true,
                          hintText: 'Password',
                          textEditingController: _passwordController,
                          textInputType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: TextFieldInput(
                          hintText: 'Bio',
                          textEditingController: _bioController,
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: blueColor),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: signUpUser,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: blueColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Sign Up",
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/logos/icons8-facebook.svg",
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Log In With Facebook",
                                  style: TextStyle(color: blueColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            "Or",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Have an account already?",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                              TextButton(
                                onPressed: navigateToLogin,
                                child: const Text(
                                  "Log In.",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Divider(
                            thickness: 1.2,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Instagram from Facebook",
                            style: TextStyle(
                                // fontSize: 14,
                                ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
