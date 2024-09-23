import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

import '../services/database.dart';
import '../utilities/common_functions.dart';
import '../utilities/device_info.dart';
import '../view/home.dart';
// import '../models/constants.dart';
// import '../services/device_info.dart';
// import '../services/database_sqflite.dart';
// import '../view/home.dart';
// import 'package:sign_in_alfalah/new_user_login/new_view/new_first_page.dart';

class LoginController extends GetxController {
  final DatabaseHelper dbController = Get.put(DatabaseHelper());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());

  late TextEditingController userNameController;
  late TextEditingController passwordController;
  var username = ''.obs;
  var password = ''.obs;
  var isLoginSuccessful = false.obs;
  var fullName = ''.obs;
  var deviceId = ''.obs; // New observable for device ID
  double appVersion = 1.0;
  String platform = "android";
  // var outlets = [].obs;


  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController(text: "wildspace");
    userNameController = TextEditingController(text: "2");
    commonFunctions
        .fetchDeviceId(); // Fetch the device ID when the controller is initialized
    commonFunctions.fetchLocation();
  }

  // This function checks if the provided username and password are valid
  Future<void> loginCheck() async {
    const String serverIp = "18.199.215.22";
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());

    String param =
        "timestamp=$currDateTime&LoginUsername=${username.value}&LoginPassword=${password.value}&DeviceID=${commonFunctions.deviceId}&Platform=$platform&AppVersion=$appVersion";
    var queryParameters = <String, String>{
      "SessionID": encryptSessionID(param),
    };

    try {
      var url = Uri.http(serverIp, '/portal/mobile/MobileAuthenticateUser', queryParameters);
      var response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        if (responseBody["success"] == 'true') {
          fullName.value = responseBody["DisplayName"];
          isLoginSuccessful.value = true;

          // Storing outlet data from BeatPlanRows dynamically
          List<dynamic> beatPlanRows = responseBody["BeatPlanRows"];

          // Iterate through each outlet and store its details
          for (var outlet in beatPlanRows) {
            var outletID = outlet["OutletID"];
            var outletName = outlet["OutletName"];
            var address = outlet["Address"];
            var telephone = outlet["Telepohone"];
            var lat = outlet["lat"];
            var lng = outlet["lng"];
            var dayNumber = outlet["DayNumber"];
            var PJPID= outlet['PJPID'];
            var distributor_id= outlet['distributor_id'];
            var region_id= outlet['region_id'];
            var city_id= outlet['city_id'];


            // Example: Storing in a list (could be a GetX observable list or a simple list)

            // Example of logging the stored values
            print("OutletID: $outletID");
            print("OutletName: $outletName");
            print("Address: $address");
            print("Telephone: $telephone");
            print("Lat: $lat, Lng: $lng");
            print("dayNumber: $dayNumber");
            print("PJPID: $PJPID");
            print("distributor_id: $distributor_id");
            print("region_id: $region_id");
            print("city_id: $city_id");

            int outletIDInt = int.tryParse(outletID) ?? 0;  // Convert to int
            int dayNumberInt = int.tryParse(dayNumber) ?? 1;

            try {
              await dbController.insertPreSellOutlet(
                outlet_id: outletIDInt,
                outlet_name: outletName,
                day_number: dayNumberInt,
                owner: fullName.value,
                address: address,
                telephone: telephone,
                nfc_tag_id: 'abc'.toString(),
                visit_type: 0,
                lat: lat.toString(),
                lng: lng.toString(),
                area_label: 'xyz',
                sub_area_label: 'pqr',
                is_alternate_visible: 0,
                pic_channel_id: 'asd',
                channel_label: 'tru',
                order_created_on_date: 'uti',
                common_outlets_vpo_classifications: 'he',
                Visit: 'she',
                purchaser_name: 'rut'.toString(),
                purchaser_mobile_no: '00000'.toString(),
                cache_contact_nic: '987654'.toString(),
              );
              print("Outlet data inserted successfully");
            } catch (e) {
              print("Error inserting outlet data: $e");
              showErrorDialog('Error', 'Failed to insert outlet data: $e');
              // You may decide to skip the database insertion if it fails and still allow login
              isLoginSuccessful.value = false;
              return;  // Skip the rest of the process
            }




          }

          print("response==200 successful");
        } else {
          isLoginSuccessful.value = false;
          showErrorDialog('Login Failed', responseBody["error_message"]);
          print("response==200 failed");
        }
      } else {
        isLoginSuccessful.value = false;
        showErrorDialog('Status code Error', 'Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      isLoginSuccessful.value = false;
      showErrorDialog('Error', 'An error occurred: Try Again${e.toString()}');
    }
  }

  // Handle the login logic
  Future<bool> handleLogin(String uname, String pass) async {
    await dbController.deletePreSellOutlet();

    setCredentials(uname, pass);

    await loginCheck(); // Validate the credentials by checking the server

    if (isLoginSuccessful.value) {
      // If the login is successful, store the user data locally
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      await dbController.addUserData(
        userID: uname,
        password: pass,
        timestamp: timestamp.toString(),
        name: fullName.value,
      );
      return true;
    } else {
      // If the login fails, just return false without storing anything
      return false;
    }
  }

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
    if (formKey.currentState?.validate() ?? false) {
      final String userName = userNameController.text;
      final String password = passwordController.text;

      final bool loginSuccess = await handleLogin(userName, password);

      if (loginSuccess) {
        Get.to(
          () => Home(),
          transition: Transition.downToUp,
        );
        // Navigate to the next screen if login is successful
        userNameController.clear();
        passwordController.clear();
      } else {
        print("Invalid login attempt");
      }

      userNameController.clear();
      passwordController.clear();
    }
  }

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
          backgroundColor: Colors.green,
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
