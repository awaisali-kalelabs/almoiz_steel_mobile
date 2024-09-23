// import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../snack_bar_model.dart';
import '../utilities/common_functions.dart';
class RegistrationImages extends GetxController {
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());

  var outletImagePath = ''.obs;
  var GodownImagePath = ''.obs;
  var visitingCardImagePath = ''.obs;
  var iDCardImagePath = ''.obs;
  var isOwner = false.obs;


  // final _picker = ImagePicker();
  var imagePath = ''.obs;

  // Future<void> captureImage(RxString imagePath) async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //
  //   if (pickedFile != null) {
  //     //image.value = XFile(pickedFile.path);
  //     imagePath.value = pickedFile.path;
  //   }
  // }
  bool areAllImagesSelected() {
    return commonFunctions.outletImageRegistrationPath.isNotEmpty &&
        commonFunctions.godownImagePath.isNotEmpty &&
        commonFunctions.visitingCardRegistrationImagePath.isNotEmpty &&
        commonFunctions.idCardImagePath.isNotEmpty;
  }

  // Method to trigger validation and proceed if all images are selected
  Future<void> proceedWithRegistration() async {
    if (areAllImagesSelected()) {
      // All images are set, proceed with registration
      commonFunctions.outletImageRegistrationPath.value = '';
      commonFunctions.godownImagePath.value = '';
      commonFunctions.idCardImagePath.value = '';
      commonFunctions.visitingCardImagePath.value = '';
      CustomSnackbar.show(
        title: "Success",
        message: "images selected.",
      );
      // Logic to proceed
    } else {
      // Show error message
      CustomSnackbar.show(
        title: "Error",
        message: "Please select all required images before proceeding.",
      );
    }
  }
  Future<void> sendDataToServer(List allDocuments) async {
    // Assuming `allDocuments` is provided from some external source
    print("retrieve data::::${allDocuments}");

    for (int i = 0; i < allDocuments.length; i++) {
      int MobileRequestID = int.parse(allDocuments[i]['OrderID'].toString());
      print("MobileRequestID ::::${MobileRequestID}");

      final url = Uri.parse('http://18.199.215.22/portal/mobile/MobileUploadNewOutletImage');

      // Use image paths from commonFunctions directly
      var photoFile1 = File(commonFunctions.outletImageRegistrationPath.value);
      var photoFile2 = File(commonFunctions.godownImagePath.value);
      var photoFile3 = File(commonFunctions.idCardImagePath.value);
      var photoFile4 = File(commonFunctions.visitingCardImagePath.value);

      try {
        print("Sending data for user: " + commonFunctions.userId.value.toString());

        var request = http.MultipartRequest('POST', url)
          ..fields['order_id'] = MobileRequestID.toString()
          ..fields['user_id'] = commonFunctions.userId.value;

        // Add the four image files if they exist
        if (photoFile1.existsSync()) {
          request.files.add(await _createMultipartFile(photoFile1, "Outlet_image1"));
        }
        if (photoFile2.existsSync()) {
          request.files.add(await _createMultipartFile(photoFile2, "Godown_image"));
        }
        if (photoFile3.existsSync()) {
          request.files.add(await _createMultipartFile(photoFile3, "ID_Card_image"));
        }
        if (photoFile4.existsSync()) {
          request.files.add(await _createMultipartFile(photoFile4, "Visiting_Card_image"));
        }

        // Send the request and await response
        var response = await request.send();

        if (response.statusCode == 200) {
          print("Image upload successful for order $MobileRequestID");
          var responseData = await response.stream.bytesToString();
          print("Response: $responseData");
        } else {
          print("Image upload failed with status code: ${response.statusCode}");
        }
      } catch (e) {
        print('Error uploading images: $e');
        // Handle the error here
      }
    }
  }    Future<http.MultipartFile> _createMultipartFile(
        File file, String fieldName) async {
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      String fileName =
      basename(file.path); // Use path.basename to get the file name

      return http.MultipartFile(fieldName, stream, length, filename: fileName);
    }
  }
