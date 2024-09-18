import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../constants.dart';
import '../controller/attendance_controller.dart';
import '../utilities/common_functions.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button_widget.dart';

class Attendance extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double cardWidth = width / 1.1;

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        child: Scaffold(
          appBar: const CustomAppBar(title: 'Attendance'),
          body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Please select the attendance type",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.attendanceTypeId.value = 1;
                                        _showBottomSheet(context, 'Check In', commonFunctions.checkInImage);
                                      },
                                      child: Card(
                                        color: Color(0xFFDCE6FD),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              height: 76,
                                              padding: EdgeInsets.all(10),
                                              child: const Column(
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: Icon(
                                                      Icons.access_time,
                                                      color: Color(0xFF4682B4),
                                                      size: 30,
                                                    ),
                                                    title: Text(
                                                      'Check In',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Color(0xFF4682B4),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.attendanceTypeId.value = 2;
                                        _showBottomSheet(context, 'Check Out', commonFunctions.checkOutImage);
                                      },
                                      child: Card(
                                        color: Color(0xFFDCE6FD),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              height: 76,
                                              padding: EdgeInsets.all(10),
                                              child: const Column(
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: Icon(
                                                      Icons.exit_to_app,
                                                      color: Color(0xFF4682B4),
                                                      size: 30,
                                                    ),
                                                    title: Text(
                                                      'Check Out',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Color(0xFF4682B4),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String action, RxString imagePath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This allows the bottom sheet to expand further
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now); // Format date as YYYY-MM-DD
        String formattedTime = DateFormat('HH:mm:ss').format(now);
        return FractionallySizedBox(
          heightFactor: 0.8, // Adjust this value to set the height (80% of the screen height)
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  action,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Current Date: $formattedDate', // Display formatted date
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5), // Add spacing between date and time
                Text(
                  'Current Time: $formattedTime', // Display formatted time
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    commonFunctions.captureImage(imagePath);
                  },
                  child: Obx(
                        () => CircleAvatar(
                      radius: 200,
                      backgroundImage: action == 'Check In'
                          ? (commonFunctions.checkInImage.value.isNotEmpty
                          ? FileImage(File(commonFunctions.checkInImage.value))
                          : null)
                          : (commonFunctions.checkOutImage.value.isNotEmpty
                          ? FileImage(File(commonFunctions.checkOutImage.value))
                          : null),
                      child: (action == 'Check In' &&
                          commonFunctions.checkInImage.value.isEmpty) ||
                          (action == 'Check Out' &&
                              commonFunctions.checkOutImage.value.isEmpty)
                          ? Icon(Icons.camera_alt, size: 40)
                          : null,
                    ),

                  ),

                ),
                CustomButtonWidget(
                  text: 'Save',
                  onPressed: () {
                    // Clear image paths on submit
                    Get.back();
                    commonFunctions.checkInImage.value='';
                    commonFunctions.checkOutImage.value  ='';

                    // Additional submit functionality
                  },
                ),
              ],

            ),

          ),
        );
      },
    );
  }
}
