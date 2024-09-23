import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../utilities/common_functions.dart';
import 'login_controller.dart';


class FormController extends GetxController {
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());
  final LoginController loginController = Get.put(LoginController());

  final businessNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final cnicNumberController = TextEditingController();
  final ntnNumberController = TextEditingController();
  final landlineNumberController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final billingAddressController = TextEditingController();
  final shippingAddressController = TextEditingController();
  final billingContactPersonController = TextEditingController();
  final logisticsContactPersonController = TextEditingController();
  final cityNameController = TextEditingController();
  final completeAddressController = TextEditingController();
  final yearInBusinessController = TextEditingController();
  final monthlySaleVolumeController = TextEditingController();
  final previousDealershipController = TextEditingController();
  var isOwner = false.obs;
  var isOnRent = false.obs;
  var createdBy = ''.obs;

  @override
  void onClose() {
    // Dispose of each controller to avoid memory leaks
    businessNameController.dispose();
    ownerNameController.dispose();
    cnicNumberController.dispose();
    ntnNumberController.dispose();
    landlineNumberController.dispose();
    mobileNumberController.dispose();
    billingAddressController.dispose();
    shippingAddressController.dispose();
    billingContactPersonController.dispose();
    logisticsContactPersonController.dispose();
    cityNameController.dispose();
    completeAddressController.dispose();
    yearInBusinessController.dispose();
    monthlySaleVolumeController.dispose();
    previousDealershipController.dispose();
    super.onClose();
  }

  void toggleOwnership(bool isOwnerSelected) {
    if (isOwnerSelected) {
      isOwner.value = !isOwner.value; // Toggle the current state
      if (isOwner.value) {
        isOnRent.value = false; // Ensure the other checkbox is unselected
      }
    } else {
      isOnRent.value = !isOnRent.value; // Toggle the current state
      if (isOnRent.value) {
        isOwner.value = false; // Ensure the other checkbox is unselected
      }
    }
  }
  bool validateForm() {
    // Example of validating required fields
    if (businessNameController.text.isEmpty ||
        ownerNameController.text.isEmpty ||
        cnicNumberController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        cityNameController.text.isEmpty) {
      return false; // Invalid form
    }
    return true; // Form is valid
  }
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

  Future<void> submitFormData() async {
    const String serverIp = "18.199.215.22";  // Replace with your actual server IP
    // const String serverIp = "192.168.201.197:8080";  // Replace with your actual server IP
    const String apiEndpoint = "/portal/mobile/MobileSyncOutletRegistration";  // Replace with your actual API endpoint
    //String getCurrentTimestamp() {
/*      DateFormat dateFormat1 = DateFormat("dd/MM/yyyy HH:mm:ss");
      String currDateTime = dateFormat1.format(DateTime.now());
      var str = currDateTime.split(".");*/
    String getCurrentTimestamp() {
      DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
      String currDateTime = dateFormat.format(DateTime.now());
      var str = currDateTime.split(".");

      String TimeStamp = str[0];
      return TimeStamp;
    }
    //  String TimeStamp = str[0];
 /*     return TimeStamp;
    }*/

    String getCurrentTimestampSql() {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
      String currDateTime = dateFormat.format(DateTime.now());
      var str = currDateTime.split(".");

      String TimeStamp = str[0];
      return TimeStamp;
    }
    // Construct the parameter string manually as you provided in the example
    String params =
        "timestamp=${getCurrentTimestamp()}"
        "&business_name=${businessNameController.text}"
        "&owner_name=${ownerNameController.text}"
        "&cnic_number=${cnicNumberController.text}"
        "&ntn_number=${ntnNumberController.text}"
        "&landline_number=${landlineNumberController.text}"
        "&mobile_number=${mobileNumberController.text}"
        "&billing_address=${billingAddressController.text}"
        "&shipping_address=${shippingAddressController.text}"
        "&billing_contact_person=${billingContactPersonController.text}"
        "&logistics_contact_person=${logisticsContactPersonController.text}"
        "&city_name=${cityNameController.text}"
        "&complete_address=${completeAddressController.text}"
        "&year_in_business=${yearInBusinessController.text}"
        "&monthly_sale_volume=${monthlySaleVolumeController.text}"
        "&previous_dealership=${previousDealershipController.text}"
        "&is_owner=${isOwner.value}"
        "&mobile_request_id=${commonFunctions.orderId.value}"
        "&lat=${commonFunctions.latitude.value.toString()}"
        "&lng=${commonFunctions.longitude.value.toString()}"
        "&accuracy=${commonFunctions.accuracy.value.toString()}"
        "&created_on=${getCurrentTimestampSql()}"
        "&created_by=${loginController.username.value}"
        "&uuid= ${commonFunctions.deviceId.value}"
        "&platform=Android"
        "&version=1.0";

    try {
      print(params);
      var queryParameters = <String, String>{
        "SessionID": encryptSessionID(params),
      };
      print(queryParameters);
     // var url = Uri.http(serverIp, apiEndpoint , queryParameters );
      var url = Uri.http(serverIp, '/portal/mobile/MobileSyncOutletRegistration');

      print(url);
/*      var response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        },
      );*/
      var response = await http.post(
          url,
          headers: {
            HttpHeaders.contentTypeHeader:
            'application/x-www-form-urlencoded'
          },
          body: queryParameters);
      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));

        if (responseBody["success"] == true) {
          // Handle successful submission
          print("Form submitted successfully: ${responseBody["message"]}");
        } else {
          // Handle API response error
          print("Form submission failed: ${responseBody["error_message"]}");
        }
      } else {
        // Handle HTTP response error
        print("Server returned status: ${response.statusCode}");
      }
    } catch (e) {
      // Handle general error
      print("An error occurred: $e");
    }
  }

}
