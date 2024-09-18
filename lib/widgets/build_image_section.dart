import 'dart:io'; // Import dart:io for the File class
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utilities/common_functions.dart';

class BuildImageSection extends StatelessWidget {
  final String title;
  final RxString imagePath;
  final LinearGradient gradient;

  // Constructor with required parameters
  BuildImageSection({
    required this.title,
    required this.imagePath,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final CommonFunctions commonFunctions = Get.put(CommonFunctions());

    return GestureDetector(
      onTap: () {
        commonFunctions.captureImage(imagePath); // Capture image on tap
      },
      child: Obx(() => Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          gradient: gradient, // Apply the gradient color
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: imagePath.value.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            File(imagePath.value), // Display the image from the file path
            fit: BoxFit.cover,
            width: 150,
            height: 150,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 40, color: Colors.grey), // Placeholder icon
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              'Tap to add image',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      )),
    );
  }
}
