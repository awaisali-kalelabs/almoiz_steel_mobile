// import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../snack_bar_model.dart';
import '../utilities/common_functions.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

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

  @override
  void onClose() {
    // Cleanup when controller is disposed
    super.onClose();
  }

}