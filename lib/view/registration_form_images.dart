import 'dart:io'; // Import dart:io for the File class

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/outlet_images_controller.dart';
import 'package:moiz_steel/constants.dart';

import '../controller/registration_outlet_images_controller.dart';
import '../utilities/common_functions.dart';
import '../widgets/build_image_section.dart';
import '../widgets/build_section_title.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button_widget.dart';

class OutletRegistrationImages extends StatelessWidget {
  final RegistrationImages controller = Get.put(RegistrationImages());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());

  // Define a list of gradient colors for the cards
  final List<LinearGradient> cardGradients = [
    LinearGradient(colors: [Color(0xFFFAEFE9), Color(0xFFFAEFE9)]),
    LinearGradient(colors: [Color(0xFFDDF3EB),Color(0xFFDDF3EB)]),
    LinearGradient(colors: [Color(0xFFE1F5FC), Color(0xFFE1F5FC)]),
    LinearGradient(colors: [Color(0xFFE1EBEF), Color(0xFFE1EBEF)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Images'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildCard('Outlet Image', commonFunctions.outletImageRegistrationPath, cardGradients[0]),
                _buildCard('Godown Image', commonFunctions.godownImagePath, cardGradients[1]),
                _buildCard('ID Card', commonFunctions.idCardImagePath, cardGradients[2]),
                _buildCard('Visiting Card', commonFunctions.visitingCardRegistrationImagePath, cardGradients[3]),
              ],
            ),
            const SizedBox(height: 40),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Obx(
            //           () => Checkbox(
            //         activeColor: Color(0xFF00A375),
            //         value: controller.isOwner.value,
            //         onChanged: (bool? value) {
            //           controller.isOwner.value = value!;
            //         },
            //       ),
            //     ),
            //     const Text(
            //       'Owner',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w700,
            //         fontSize: 16,
            //         color: Colors.black54,
            //       ),
            //     ),
            //   ],
            // ),
            CustomButtonWidget(
              text: 'Save',
              icon: Icons.save_alt_outlined,
              onPressed: ()  {
                  controller.proceedWithRegistration();
                // Clear image paths on submit
                commonFunctions.outletImageRegistrationPath.value = '';
                commonFunctions.godownImagePath.value = '';
                commonFunctions.idCardImagePath.value = '';
                commonFunctions.visitingCardImagePath.value = '';

                // Additional submit functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, RxString imagePath, LinearGradient gradient) {
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
