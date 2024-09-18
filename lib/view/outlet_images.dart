import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moiz_steel/widgets/build_section_title.dart';
import '../controller/outlet_images_controller.dart';
import 'package:moiz_steel/constants.dart';

import '../services/database.dart';
import '../utilities/common_functions.dart';
import '../widgets/build_image_section.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button_widget.dart';

class OutletImages extends StatelessWidget {
  final PerformTask controller = Get.put(PerformTask());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Outlet Details'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    BuildImageSection(
                      title: "Outlet Image",
                      imagePath: commonFunctions.outletImagePath,
                      gradient: controller.cardGradients[0],
                    ),

                    BuildImageSection(
                        title: "Storage Image",
                        imagePath: commonFunctions.storageImagePath,
                        gradient: controller.cardGradients[1]),

                    BuildImageSection(
                      title: "Visit Card",
                      imagePath: commonFunctions.visitingCardImagePath,
                      gradient: controller.cardGradients[2],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                CustomButtonWidget(
                  text: 'Save',
                  icon: Icons.save_alt_outlined,
                  onPressed: () async {
                    controller.proceedWithRegistration();
                    await controller.submitData();
                    commonFunctions.visitingCardImagePath.value = '';
                    commonFunctions.storageImagePath.value = '';
                    commonFunctions.outletImagePath.value = '';
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
