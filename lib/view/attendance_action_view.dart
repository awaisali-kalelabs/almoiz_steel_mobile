// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../constants.dart';
// // import '../controller/AttendanceAction_controller.dart';
// import '../controller/attendance_action_controller.dart';
// import '../controller/attendance_controller.dart';
// // import '../controller/attendence_controller.dart';
// // import '../models/constants.dart';
// import 'attendance_view.dart';
// // import 'attendence.dart';
//
// class AttendanceAction extends StatelessWidget {
//    final AttendanceActionController attendanceController = Get.put(AttendanceActionController());
//   final AttendanceController controller = Get.put(AttendanceController());
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: GestureDetector(
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "Mark Attendance",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             backgroundColor: kAppBarColor, // You can change the color
//             elevation: 5,
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//               ), // Choose your preferred icon
//               onPressed: () {
//                 // Navigate to FirstPage using GetX
//                 Get.to(() => Attendance());
//               },
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             child: const Icon(Icons.camera_alt),
//             onPressed: () {
//               // attendanceController.openCamera();
//             },
//           ),
//           bottomNavigationBar: BottomAppBar(
//             shape: CircularNotchedRectangle(),
//             notchMargin: 4.0,
//             color: kAppBarColor,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Obx(() => attendanceController.imagePath.value != null
//                     ? RawMaterialButton(
//                   onPressed: () {
//                     attendanceController.imagePath.value = null;
//                     attendanceController.openCamera();
//                   },
//                   child: Text('Retake' ,style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 20)),
//                 )
//                     : Text("")),
//                 Obx(() => RawMaterialButton(
//                   onPressed: attendanceController.imagePath.value != null
//                       ? attendanceController.markAttendanceLocally
//                       : () => showErrorDialog(context),
//                   child: Text('Save' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 20),),
//                 )),
//               ],
//             ),
//           ),
//           body: Container(
//             margin: EdgeInsets.only(top: 10),
//             child: Column(
//               children: [
//                 // Display the captured image inside a container
//                 Obx(() {
//                   if (attendanceController.imagePath.value != null) {
//                     return Center(
//                       child: Container(
//                         height: 400,
//                         width: 350,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 2),
//                         ),
//                         child: Image.file(
//                           File(attendanceController.imagePath.value!.path), // Correctly display the image from the path
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Center(
//                       child: Container(
//                         height: 400,
//                         width: 350,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           border: Border.all(color: Colors.black, width: 2),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Please Capture Image',
//                             style: TextStyle(fontSize: 16, color: Colors.black54),
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 }),
//                 SizedBox(height: 10),
//                 // Add other widgets for the attendance screen here
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showErrorDialog(BuildContext context) {
//     // Show an error dialog if the image is not selected
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text('No image captured. Please capture an image before saving.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
