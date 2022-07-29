import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/screens/auth/login_screen.dart';
import 'package:insta_clone/screens/auth/services/auth.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/loader.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';
import '../../utils/asset_manager.dart';
import '../../utils/colors.dart';
import '../../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  selectImage() async {
    _image = await pickImage(ImageSource.gallery);
    setState(() {});
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: emailController.text.trim(),
        password: passwordController.text,
        bio: bioController.text,
        userName: usernameController.text.trim(),
        file: _image!,
        context: context);
    setState(() {
      _isLoading = false;
    });
    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                const SizedBox(
                  height: 64,
                ),
                SvgPicture.asset(
                  logo,
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(64))),
                        child: _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1608889175123-8ee362201f81?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDF8fGdyZXklMjBhdmF0YXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
                                ),
                              )),
                    Positioned(
                        bottom: -1,
                        left: 45,
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: const Icon(Icons.add_a_photo_outlined),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textController: usernameController,
                  hintText: 'Username',
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textController: emailController,
                  hintText: 'Email address',
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textController: passwordController,
                  hintText: 'Password',
                  isPass: true,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textController: bioController,
                  hintText: 'Enter your bio',
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () async {
                    signUpUser();
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading ? const Loader() : const Text('Sign up'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Have an account? '),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigateToLogin();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Login!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
