import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/outlet_images_controller.dart';

import '../services/database.dart';
import '../snack_bar_model.dart';
import '../utilities/common_functions.dart';
import '../widgets/build_image_section.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button_widget.dart';
import 'daily_visit.dart';
import 'home.dart';

class OutletImages extends StatelessWidget {
  final PerformTask controller = Get.put(PerformTask());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());
  final DatabaseHelper dbController = Get.put(DatabaseHelper());


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:  CustomAppBar(title: 'Outlet Details',onBackPressed: () {
          // Your custom function
          print('Custom back button pressed!');
          dbController.deleteOutletNoOrders();
          Get.back();
          // Or any other logic
        },),
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
                      // Show loader while processing

                      // Check if saveImageDataLocally() succeeds
                      bool isSavedLocally = await controller.saveImageDataLocally();

                      if (isSavedLocally) {
                        // If the function returns true, continue with the rest of the operations
                        commonFunctions.showLoader();

                        await controller.SaveNoOrder();
                        await controller.sendOutletImage();
                        commonFunctions.hideLoader();

                        Get.to(() => Home());
                        CustomSnackbar.show(
                          title: "Visit",
                          message: " Visit has been completed successfully",
                        );

                        // await controller.sendDataToServer();
                      } else {
                        // Handle the case when saveImageDataLocally() fails
                        commonFunctions.hideLoader();
                        CustomSnackbar.show(
                          title: "Error",
                          message: " Failed to save image data locallyy",
                        );
                        return; // Exit the function early
                      }

                      // Hide loader after processing

                      // Navigate to Home
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}