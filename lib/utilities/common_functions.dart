import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;


import '../services/database.dart';
import '../util/config.dart';
import 'device_info.dart';

class CommonFunctions {
  final DatabaseHelper dbController = Get.put(DatabaseHelper());


  final ImagePicker _picker = ImagePicker();
  var userName = '';
  var outletImagePath = ''.obs;
  var storageImagePath = ''.obs;
  var visitingCardImagePath = ''.obs;

  var outletImageRegistrationPath = ''.obs;
  var godownImagePath = ''.obs;
  var idCardImagePath = ''.obs;
  var visitingCardRegistrationImagePath = ''.obs;


  var checkInImage = ''.obs;
  var checkOutImage = ''.obs;


  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var accuracy = 0.0.obs;
  var deviceId = ''.obs;

  var userId= ''.obs;
  var orderId= 0.obs;


  CommonFunctions() {
    // Initialize the unique mobile ID when the class is instantiated
    orderId.value = getUniqueMobileId();
  }

  Future<void> captureImage(RxString imagePath) async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      print('Captured image path: ${imagePath.value}');
    }
  }

  void fetchDeviceId() async {
    deviceId.value = await DeviceIdProvider.getDeviceId();
    print("deviceId.value${deviceId.value}");
  }
  Future<void> fetchLocation() async {
    try {
      // Step 1: Get the IP address
      final ipResponse = await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (ipResponse.statusCode == 200) {
        String ipAddress = json.decode(ipResponse.body)['ip'];

        // Step 2: Get the location based on IP address
        final locationResponse = await http.get(Uri.parse('https://ipapi.co/$ipAddress/json/'));
        if (locationResponse.statusCode == 200) {
          Map<String, dynamic> locationData = json.decode(locationResponse.body);

          // Extract latitude and longitude
          latitude.value = locationData['latitude'] ?? 0.0;
          longitude.value = locationData['longitude'] ?? 0.0;
          accuracy.value = locationData['accuracy'] ?? 0.0;

          print('Latitude: ${latitude.value}');
          print('Longitude: ${longitude.value}');
          print('Accuracy: ${accuracy.value}');
        } else {
          print('Failed to fetch location data: ${locationResponse.statusCode}');
        }
      } else {
        print('Failed to fetch IP address: ${ipResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }
  void showLoader() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }
  void hideLoader() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  // void fetchLocation() async {
  //   try {
  //     Map<String, double> locationData =
  //     await LocationService().getCurrentLocation();
  //     latitude.value = locationData['latitude'] ?? 0.0;
  //     longitude.value = locationData['longitude'] ?? 0.0;
  //     accuracy.value = locationData['accuracy'] ?? 0.0;
  //     print("latitude${latitude.value}");
  //     print("latitude${longitude.value}");
  //     print("latitude${accuracy.value}");
  //   } catch (e) {
  //     print("Error fetching location: $e");
  //   }
  // }
  int getUniqueMobileId() {
    ////print("UserID:" + username.toString());
    String MobileId = "";
    if (userName.toString().length > 4) {
      MobileId = userName.toString() +
          DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      MobileId = userName.toString() +
          DateTime.now().millisecondsSinceEpoch.toString();
    }
    return int.parse(MobileId);
  }

  void fetchUsernameFromLocalDB() async {
    String? storedUsername = await dbController.getStoredUsername();
    if (storedUsername != null && storedUsername.isNotEmpty) {
      userId.value = storedUsername;
      print("helloooo"+userId.value.toString());
    } else {
      userId.value = 'Guest'; // Or handle it as per your requirement
    }
  }


}
