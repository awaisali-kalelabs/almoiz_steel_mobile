import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/outlet_images_controller.dart';
import 'package:moiz_steel/constants.dart';

import '../controller/registration_outlet_images_controller.dart';
import '../widgets/custom_button_widget.dart';

class OutletRegistrationImages extends StatelessWidget {
  final RegistrationImages controller = Get.put(RegistrationImages());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Outlet Details",
          style: kAppBarTextColor,
        ),
        elevation: 5,
        backgroundColor: kAppBarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle("Outlet Image"),
              const SizedBox(height: 10),
              _buildImageSection(controller.outletImagePath),
              const SizedBox(height: 20),
              _buildSectionTitle("Godown Image"),
              const SizedBox(height: 10),
              _buildImageSection(controller.GodownImagePath),
              const SizedBox(height: 20),
              _buildSectionTitle("ID Card "),
              const SizedBox(height: 10),
              _buildImageSection(controller.iDCardImagePath),
              const SizedBox(height: 20),
              _buildSectionTitle("Visitng Card "),
              const SizedBox(height: 10),
              _buildImageSection(controller.visitingCardImagePath),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                        () => Checkbox(
                          activeColor: kAppBarColor,
                      value: controller.isOwner.value,
                      onChanged: (bool? value) {
                        controller.isOwner.value= value!;

                      },
                    ),
                  ),
                  const Text('Owner',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black54),),
                ],
              ),

              CustomButtonWidget(text: 'Save',
                onPressed: () {
                  // Implement submit functionality
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: kAppBarColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImageSection(RxString imagePath) {
    return GestureDetector(
      onTap: () {
        controller.captureImage(imagePath);
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Obx(() {
            return imagePath.value == ''
                ? Icon(
              Icons.camera_alt,
              color: Colors.grey[600],
              size: 50,
            )
                : Image.file(
              File(imagePath.value),
              fit: BoxFit.cover,
            );
          }),
        ),
      ),
    );
  }

}
