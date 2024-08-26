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

  void toggleOwnership(bool isOwnerSelected) {
    if (isOwnerSelected) {
      isOwner.value = true;
      isOnRent.value = false;
    } else {
      isOwner.value = false;
      isOnRent.value = true;
    }
  }


  bool _validateForm() {
    // Add validation for each field if needed
    return true;
  }

}
