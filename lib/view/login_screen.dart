// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../utilities/common_functions.dart';
import '../widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool isObscured = true.obs;

  LoginScreen({super.key});

  void toggleObscured() {
    isObscured.value = !isObscured.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(height: screenSize.height * 0.1),
                  Image.asset(
                    'assets/images/moiz_logo.png', // Replace with your logo path
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF08344A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please log in to your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: loginController.userNameController,
                          hintText: 'Username',
                          prefixIcon: const Icon(Icons.person, color: Colors.grey),
                          validator: (val) => null,
                        ),
                        const SizedBox(height: 20),
                        Obx(
                              () => CustomTextFormField(
                            controller: loginController.passwordController,
                            hintText: 'Password',
                            obscureText: isObscured.value,
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscured.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: toggleObscured,
                            ),
                            validator: (val) => null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,

                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {
                    loginController.onPressed(_formKey),
                    FocusScope.of(context).unfocus(),
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF08344A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(screenSize.width * 0.8, 50),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                     Text(
                      'DeviceID: ${commonFunctions.deviceId} ',
                      style: const TextStyle(
                        color: Color(0xFF08344A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
