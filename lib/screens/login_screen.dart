import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utilis/colors.dart';
import 'package:instagram_clone/utilis/global_variables.dart';
import 'package:instagram_clone/widgets/textfield.dart';
import '../responsive/responsive_layout.dart';
import '../services/auth_method.dart';
import '../widgets/snack_bar.dart';
import 'mobile_screen_layout.dart';
import 'signup_screen.dart';
import 'web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void logInUser() async {
    setState(() {
      _isLoading = true;
    });
    String response = await AuthMethods().logInUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(content: response, context: context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: (MediaQuery.of(context).size.width / 3),
              )
            : const EdgeInsets.only(
                top: 50,
                right: 15,
                left: 15,
              ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/logos/Instagram_logo1.svg",
                    height: 70,
                    width: 70,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: TextFieldInput(
                          hintText: 'Phone number, username or email',
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
                            onTap: logInUser,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: blueColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Log in",
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
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                              TextButton(
                                onPressed: navigateToSignUp,
                                child: const Text(
                                  "Sign Up.",
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
                            style: TextStyle(),
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
