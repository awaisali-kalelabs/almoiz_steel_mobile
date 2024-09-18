import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

import '../utilities/common_functions.dart';
import '../utilities/device_info.dart';
import '../view/home.dart';
// import '../models/constants.dart';
// import '../services/device_info.dart';
// import '../services/database_sqflite.dart';
// import '../view/home.dart';
// import 'package:sign_in_alfalah/new_user_login/new_view/new_first_page.dart';

class LoginController extends GetxController {
  // final DatabaseController databaseController = Get.put(DatabaseController());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());


  late TextEditingController userNameController;
  late TextEditingController passwordController;
  var username = ''.obs;
  var password = ''.obs;
  var isLoginSuccessful = false.obs;
  var fullName = ''.obs;
  var deviceId = ''.obs;  // New observable for device ID

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    commonFunctions.fetchDeviceId();  // Fetch the device ID when the controller is initialized
      commonFunctions.fetchLocation();
  }

  // This function checks if the provided username and password are valid
  Future<void> loginCheck() async {
    const String serverIp = "18.184.139.178";
    // String deviceId = await DeviceIdProvider.getDeviceId();
    print("device id: $deviceId");

    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());

    String param =
        "timestamp=$currDateTime&UserID=${username.value}&Password=${password.value}&DeviceID=${commonFunctions.deviceId}";
    var queryParameters = <String, String>{
      "SessionID": encryptSessionID(param),
    };

    try {
      var url = Uri.http(
          serverIp, '/portal/mobile/MobileAuthenticateUserV1', queryParameters);
      var response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        print("response==200");
        if (responseBody["success"] == 'true') {
          fullName.value = responseBody["DisplayName"];
          isLoginSuccessful.value = true;
          print("response==200 successful");
        } else {
          isLoginSuccessful.value = false;
          showErrorDialog('Login Failed', responseBody["error_message"]);
          print("response==200 failed");
        }
      } else {
        isLoginSuccessful.value = false;
        showErrorDialog('Status code Error',
            'Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      isLoginSuccessful.value = false;
      showErrorDialog('Error', 'An error occurred: Try Again');
    }
  }

  // Handle the login logic
  // Future<bool> handleLogin(String uname, String pass) async {
  //   setCredentials(uname, pass);
  //
  //   await loginCheck(); // Validate the credentials by checking the server
  //
  //   if (isLoginSuccessful.value) {
  //     // If the login is successful, store the user data locally
  //     int timestamp = DateTime.now().millisecondsSinceEpoch;
  //     await databaseController.addDataLocally(
  //       Name: uname,
  //       password: pass,
  //       timestamp: timestamp,
  //       fullName: fullName.value,
  //     );
  //     return true;
  //   } else {
  //     // If the login fails, just return false without storing anything
  //     return false;
  //   }
  // }

  void setCredentials(String uname, String pass) {
    username.value = uname;
    password.value = pass;
  }

  // Encryption function for session ID
  String encryptSessionID(String qry) {
    String ret = "";
    for (int i = 0; i < qry.length; i++) {
      int ch = (qry.codeUnitAt(i) * 5) - 21;
      ret += "$ch,";
    }

    String ret2 = "";
    for (int i = 0; i < ret.length; i++) {
      int ch = (ret.codeUnitAt(i) * 5) - 21;
      ret2 += "${ch}0a";
    }

    return ret2;
  }

  void onPressed(GlobalKey<FormState> formKey) async {
    // if (formKey.currentState?.validate() ?? false) {
    //   final String userName = userNameController.text;
    //   final String password = passwordController.text;
    //
    //   final bool loginSuccess =
    //   await handleLogin(userName, password);
    //
    //   if (loginSuccess) {
    //     if(userName == '2593' ){
    //       print("first");

    Get.to(() => Home(), transition: Transition.downToUp,);
    //
    //     }
    //     else if(userName == '2693')
    //     {
    print("second");

    // Get.to(() => NewFirstPage());

  }
  // Navigate to the next screen if login is successful
  // Get.toNamed('/nextScreen');

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


  // Error dialog to display error messages
  void showErrorDialog(String title, String message) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      confirmTextColor: Colors.white,
      backgroundColor: Colors.white,
      onConfirm: () => Get.back(),
      textConfirm: 'OK',
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 50),
        ),
        child: const Text(
          'OK',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
