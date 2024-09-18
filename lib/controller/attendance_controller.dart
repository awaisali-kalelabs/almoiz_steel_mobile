import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';

// import '../view/first_page_view.dart';

class AttendanceController extends GetxController {
  final isLocationTimedOut = false.obs;
  final AllNoOrders = <Map<String, dynamic>>[].obs;
  final SelectFreightTerms = ''.obs;
  final NoOrderReasons = <Map<String, dynamic>>[].obs;
  var attendanceTypeId = 0.obs;
  final isSelected = [false, false, false, false, false, false, false].obs;

  var checkInImage = ''.obs;
  var checkOutImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    //globals.startContinuousLocation();
  }
  Future<void> saveCheckInStatus(bool hasCheckedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCheckedIn', hasCheckedIn);
  }
  Future<bool> getCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasCheckedIn') ?? false;
  }
  Future<void> resetCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCheckedIn', false);
  }

  void showError() {
    Get.snackbar(
      "Error",
      "Please select the reason to proceed.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      icon: Icon(Icons.notifications_active, color: Colors.teal),
      duration: Duration(seconds: 2),
    );
  }

  void showDialogBox(String title, String message, int isSuccess) {
    Get.defaultDialog(
      title: title,
      content: Text(message),
      confirm: ElevatedButton(
        onPressed: () {
          if (isSuccess == 1) {
            // Get.off(() => FirstPage());
          } else {
            Get.back();
          }
        },
        child: Text("Close"),
      ),
    );
  }
}
