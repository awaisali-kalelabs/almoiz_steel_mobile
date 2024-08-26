// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PerformTask extends GetxController {
  var outletImagePath = ''.obs;
  var storageImagePath = ''.obs;
  var visitingCardImagePath = ''.obs;


  final _picker = ImagePicker();
  var imagePath = ''.obs;

  Future<void> captureImage(RxString imagePath) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      //image.value = XFile(pickedFile.path);
      imagePath.value = pickedFile.path;
    }
  }

  @override
  void onClose() {
    // Cleanup when controller is disposed
    super.onClose();
  }

}