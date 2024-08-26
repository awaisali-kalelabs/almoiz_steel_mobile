import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
// import '../services/database_sqflite.dart';
import 'package:moiz_steel/clipper.dart';
import 'package:moiz_steel/widgets/custom_text_form_field.dart';
import 'package:moiz_steel/constants.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  // final DatabaseController databaseController = Get.put(DatabaseController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool isObscured = true.obs;

  void toggleObscured() {
    isObscured.value = !isObscured.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFF08344A),
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background_img4.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          // ClipPath(
                          //   clipper: StretchedTriangleClipper(),
                          //   child: Container(
                          //     width: double.infinity,
                          //     height: screenSize.height * 0.13,
                          //     decoration: BoxDecoration(
                          //       color: Colors.black.withOpacity(0.2),
                          //     ),
                          //   ),
                          // ),
                          // ClipPath(
                          //   clipper: StretchedTriangleClipper(),
                          //   child: Container(
                          //     width: double.infinity,
                          //     height: screenSize.height * 0.12,
                          //     decoration: kClipperDec,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // AvatarGlow(
                    //   startDelay: const Duration(milliseconds: 10000),
                    //   glowColor: Color(0xFF062830),
                    //   glowShape: BoxShape.circle,
                    //   curve: Curves.fastOutSlowIn,
                    //   glowRadiusFactor: 0.2,
                    //   child: const CircleAvatar(
                    //     backgroundColor: Colors.white,
                    //     backgroundImage: AssetImage(
                    //       'assets/images/moiz_logo.png',
                    //     ),
                    //     radius: 55.0,
                    //   ),
                    // ),
                    SizedBox(height: screenSize.height * 0.028),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Stack(
                            children: [
                              Container(
                                height: screenSize.height * 0.51,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // border: Border.all(
                                  //   color: Colors.white.withOpacity(0.3),
                                  // ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent.withOpacity(0.1),
                                      Colors.transparent.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: screenSize.height * 0.07),
                                          const Text(
                                            'Login',
                                            style: kText,
                                          ),
                                          SizedBox(height: screenSize.height * 0.05),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                            child: CustomTextFormField(
                                              controller: loginController
                                                  .userNameController,
                                              hintText: 'Username',
                                              textColor: Colors.white,

                                              keyboardType: TextInputType.number,
                                              prefixIcon: const Icon(
                                                Icons.person,
                                                color: kThemeColor,
                                              ),
                                              validator: (val) {
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(height: screenSize.height * 0.04),
                                          Obx(
                                                () => Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 0),
                                              child: CustomTextFormField(
                                                controller: loginController
                                                    .passwordController,
                                                hintText: 'Password',
                                                textColor: Colors.white,
                                                obscureText: isObscured.value,
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: kThemeColor,
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    isObscured.value
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: kThemeColor,
                                                  ),
                                                  onPressed: toggleObscured,
                                                ),
                                                validator: (val) {
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: screenSize.height * 0.05),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   right: 0,
                        //   top: -1,
                        //   child: Stack(
                        //     children: [
                        //       ClipPath(
                        //         clipper: TriangleClipper(),
                        //         child: Container(
                        //           width: 300,
                        //           height: 104,
                        //           decoration: BoxDecoration(
                        //             color: Colors.black.withOpacity(0.3),
                        //           ),
                        //         ),
                        //       ),
                        //       ClipPath(
                        //         clipper: TriangleClipper(),
                        //         child: Container(
                        //           width: 300,
                        //           height: 100,
                        //           decoration: kClipperDec,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Positioned(
                          bottom: 15,
                          child: ElevatedButton(
                             // onPressed: onPressed,
                            onPressed: () => loginController.onPressed(_formKey),
                            style: kButtonStyle,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 2),
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: screenSize.width * 0.05, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 45.0,
                      // child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Image(
                      //       fit: BoxFit.fill,
                      //       height: 35,
                      //       width: 35,
                      //       image: AssetImage('assets/images/logo.png'),
                      //     ),
                      //     Text(
                      //       'Powered by Kale Labs' /*AppLocalizations.of(context).translate('continue_string')*/,
                      //       style: TextStyle(fontSize: 15.0, color: Colors.red),
                      //     ),
                      //   ],
                      // ),
                    ),
                    Obx(
                          () => Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Device ID: ${loginController.deviceId.value}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// void onPressed() async {
//   if (_formKey.currentState?.validate() ?? false) {
//     final String userName = userNameController.text;
//     final String password = passwordController.text;
//
//     final bool loginSuccess =
//         await loginController.handleLogin(userName, password);
//
//     if (loginSuccess) {
//       // Navigate to the next screen if login is successful
//       // Get.toNamed('/nextScreen');
//       Get.to(() => FirstPage());
//
//       userNameController.clear();
//       passwordController.clear();
//     } else {
//       print("Invalid login attempt");
//     }
//
//     userNameController.clear();
//     passwordController.clear();
//   }
// }
}
