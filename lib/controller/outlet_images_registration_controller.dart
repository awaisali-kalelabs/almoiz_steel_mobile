import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FormController extends GetxController {
  final businessNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final cnicNumberController = TextEditingController();
  final ntnNumberController = TextEditingController();
  final landlineNumberController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final billingAddressController = TextEditingController();
  final shippingAddressController = TextEditingController();
  final billingContactPersonController = TextEditingController();
  final logisticsContactPersonController = TextEditingController();
  final cityNameController = TextEditingController();
  final completeAddressController = TextEditingController();
  final yearInBusinessController = TextEditingController();
  final monthlySaleVolumeController = TextEditingController();
  final previousDealershipController = TextEditingController();
  var isOwner = false.obs;
  var isOnRent = false.obs;

  @override
  void onClose() {
    // Dispose of each controller to avoid memory leaks
    businessNameController.dispose();
    ownerNameController.dispose();
    cnicNumberController.dispose();
    ntnNumberController.dispose();
    landlineNumberController.dispose();
    mobileNumberController.dispose();
    billingAddressController.dispose();
    shippingAddressController.dispose();
    billingContactPersonController.dispose();
    logisticsContactPersonController.dispose();
    cityNameController.dispose();
    completeAddressController.dispose();
    yearInBusinessController.dispose();
    monthlySaleVolumeController.dispose();
    previousDealershipController.dispose();
    super.onClose();
  }

  void toggleOwnership(bool isOwnerSelected) {
    if (isOwnerSelected) {
      isOwner.value = !isOwner.value; // Toggle the current state
      if (isOwner.value) {
        isOnRent.value = false; // Ensure the other checkbox is unselected
      }
    } else {
      isOnRent.value = !isOnRent.value; // Toggle the current state
      if (isOnRent.value) {
        isOwner.value = false; // Ensure the other checkbox is unselected
      }
    }
  }
  bool validateForm() {
    // Example of validating required fields
    if (businessNameController.text.isEmpty ||
        ownerNameController.text.isEmpty ||
        cnicNumberController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        cityNameController.text.isEmpty) {
      return false; // Invalid form
    }
    return true; // Form is valid
  }
}
