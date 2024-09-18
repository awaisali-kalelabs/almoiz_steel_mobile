// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../services/database.dart';
import '../snack_bar_model.dart';
import '../utilities/common_functions.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

class PerformTask extends GetxController {
  final DatabaseHelper dbController = Get.put(DatabaseHelper());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());
  final List<LinearGradient> cardGradients = [
    LinearGradient(colors: [Color(0xFFFAEFE9), Color(0xFFFAEFE9)]),
    LinearGradient(colors: [Color(0xFFDDF3EB), Color(0xFFDDF3EB)]),
    LinearGradient(colors: [Color(0xFFE1F5FC), Color(0xFFE1F5FC)]),
    LinearGradient(colors: [Color(0xFFE1EBEF), Color(0xFFE1EBEF)]),
  ];

  // var outletImagePath = ''.obs;
  // var storageImagePath = ''.obs;
  // var visitingCardImagePath = ''.obs;
  //

  // final _picker = ImagePicker();
  var imagePath = ''.obs;
  @override
  void onInit() {
    super.onInit();
    commonFunctions.fetchDeviceId();  // Fetch the device ID when the controller is initialized
    commonFunctions.fetchLocation();
  }
  @override
  void onClose() {
    // Cleanup when controller is disposed
    super.onClose();
  }
  bool areAllImagesSelected() {
    return commonFunctions.outletImagePath.isNotEmpty &&
        commonFunctions.storageImagePath.isNotEmpty &&
        commonFunctions.visitingCardImagePath.isNotEmpty &&
        commonFunctions.idCardImagePath.isNotEmpty;
  }

  // Method to trigger validation and proceed if all images are selected
  void proceedWithRegistration() {
    if (areAllImagesSelected()) {
      // All images are set, proceed with registration
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
  Future<void> submitData() async {
    // Sample values for userID, lat, lng, accuracy, createdOn, orderID, and deviceID
    int userID = 1;
    String lat = commonFunctions.latitude.value.toString();
    String lng = commonFunctions.longitude.value.toString();
    String accuracy = commonFunctions.accuracy.value.toString();
    String createdOn = DateTime.now().toString();
    int orderID = commonFunctions.getUniqueMobileId();
    String deviceID = commonFunctions.deviceId.value;

    // Call the addOutletImage function with the paths of the captured images
    await dbController.addOutletImage(
      userID: userID,
      imagePath1: commonFunctions.outletImagePath.value,
      imagePath2: commonFunctions.storageImagePath.value,
      imagePath3: commonFunctions.visitingCardImagePath.value,
      lat: lat,
      lng: lng,
      accuracy: accuracy,
      createdOn: createdOn,
      orderID: orderID,
      deviceID: deviceID,

    );
    print('Outlet Image Path: ${commonFunctions.outletImagePath.value}');
    print('Storage Image Path: ${commonFunctions.storageImagePath.value}');
    print('Visiting Card Image Path: ${commonFunctions.visitingCardImagePath.value}');
  }


}