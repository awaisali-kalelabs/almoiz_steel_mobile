import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// import '../services/database_sqflite.dart';
// import '../view/attendence.dart';
// import '../widgets/first_page_widget.dart';
// import 'attendence_controller.dart';

class AttendanceActionController extends GetxController {
  // final ImagePicker _picker = ImagePicker();
  // var imagePath = Rx<XFile?>(null);
  // var isLocationTimedOut = false.obs;
  // var allMarkedAttendances = <Map<String, dynamic>>[].obs;
  // var allMarkedAttendancesPhotos = <Map<String, dynamic>>[].obs;
  // var isLoading = false.obs;
  // var isLocationUpdated = false.obs;
  // var latitude = 0.0.obs;
  // var username = ''.obs;
  // var longitude = 0.0.obs;
  // var accuracy = 0.0.obs;
  // late List<Map<String, dynamic>> AllMarkedAttendances;
  // late List<Map<String, dynamic>> AllMarkedAttendancesPhotos;
  //
  // final TextEditingController updatedLatitudeController =
  // TextEditingController();
  // final TextEditingController updatedLongitudeController =
  // TextEditingController();
  // final TextEditingController updatedAccuracyController =
  // TextEditingController();
  // final DatabaseController databaseController = Get.put(DatabaseController());
  // final AttendanceController controller = Get.put(AttendanceController());
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   // globals.startContinuousLocation(Get.context!);
  //   updateLocation();
  //   // Fetch all marked attendances
  //   fetchAllMarkedAttendances();
  //   fetchAllMarkedUploadedAttendances();
  //   fetchUsernameFromLocalDB();
  // }
  //
  // void fetchUsernameFromLocalDB() async {
  //   String? storedUsername = await databaseController.getStoredUsername();
  //   if (storedUsername != null && storedUsername.isNotEmpty) {
  //     username.value = storedUsername;
  //     //print("helloooo"+username.value.toString());
  //   } else {
  //     username.value = 'Guest'; // Or handle it as per your requirement
  //   }
  // }
  //
  // Future<void> fetchAllMarkedAttendances() async {
  //   var pendingAttendances = await databaseController.getAllMarkedAttendances(0);
  //   var uploadedAttendances = await databaseController.getAllMarkedAttendances(1);
  //   allMarkedAttendances.addAll(pendingAttendances.cast<Map<String, dynamic>>());
  //   allMarkedAttendances.addAll(uploadedAttendances.cast<Map<String, dynamic>>());
  // }
  //
  // Future<void> fetchAllMarkedUploadedAttendances() async {
  //   //print("fetchAllMarkedUploadedAttendances");
  //   var uploadedPhotos = await databaseController.getAllMarkedUploadedAttendances(0);
  //   allMarkedAttendancesPhotos.assignAll(uploadedPhotos.cast<Map<String, dynamic>>());
  //   //print("allMarkedAttendancesPhotos : "+allMarkedAttendancesPhotos.toString());
  //
  // }
  //
  // Future<void> openCamera() async {
  //   try {
  //     XFile? image = await _picker.pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 30,
  //       preferredCameraDevice: CameraDevice.front,
  //     );
  //     if (image != null) {
  //       imagePath.value = image;
  //     } else {
  //       // Handle the case where the user cancels the image capture
  //       Get.snackbar('Error', 'No image captured. Please try again.',
  //           snackPosition: SnackPosition.BOTTOM);
  //     }
  //   } catch (e) {
  //     // Handle any errors that occur during image capture
  //     Get.snackbar('Error', 'Failed to capture image: $e',
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }
  //
  // void updateLocation() async {
  //   isLoading.value = true;
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   updatedLatitudeController.text = position.latitude.toString();
  //   updatedLongitudeController.text = position.longitude.toString();
  //   updatedAccuracyController.text = position.accuracy.toString();
  //   isLoading.value = false;
  //   isLocationUpdated.value = true;
  // }
  // int getUniqueMobileId() {
  //   ////print("UserID:" + username.toString());
  //   String MobileId = "";
  //   if (username.toString().length > 4) {
  //     MobileId = username.toString() +
  //         DateTime.now().millisecondsSinceEpoch.toString();
  //   } else {
  //     MobileId = username.toString() +
  //         DateTime.now().millisecondsSinceEpoch.toString();
  //   }
  //   return int.parse(MobileId);
  // }
  // Future<void> markAttendanceLocally() async {
  //   // globals.startContinuousLocation(Get.context!);
  //   // Position? position = globals.currentPosition;
  //   //print("inside a markAttendanceLocally function");
  //   //print(imagePath.value!.path);
  //   //print( "attendanceTypeId :"+controller.attendanceTypeId.value.toString());
  //   //print( "updatedLatitudeController :"+ updatedLatitudeController.text.toString());
  //   //print( "updatedLongitudeController :"+updatedLongitudeController.text.toString());
  //   //print( "updatedAccuracyController :"+updatedAccuracyController.text.toString());
  //   //print( "username :"+username.toString());
  //
  //   await databaseController.markAttendance(
  //     getUniqueMobileId(),
  //     imagePath.value!.path,
  //     controller.attendanceTypeId.value,
  //     updatedLatitudeController.text,
  //     updatedLongitudeController.text,
  //     updatedAccuracyController.text,
  //     username.value,
  //     0,
  //     getUniqueMobileId(),
  //     0,
  //   );
  //
  //   _UploadMarkAttendance();
  //   Get.off(() => Attendance()); // Navigate to Attendance Screen
  //
  // }
  // String getCurrentTimestamp() {
  //   DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  //   String currDateTime = dateFormat.format(DateTime.now());
  //   var str = currDateTime.split(".");
  //
  //   String TimeStamp = str[0];
  //   return TimeStamp;
  // }
  //
  // String EncryptSessionID(String qry) {
  //   String ret = "";
  //   //print(qry.length);
  //   for (int i = 0; i < qry.length; i++) {
  //     int ch = (qry.codeUnitAt(i) * 5) - 21;
  //     ret += ch.toString() + ",";
  //   }
  //
  //   String ret2 = "";
  //   for (int i = 0; i < ret.length; i++) {
  //     int ch = (ret.codeUnitAt(i) * 5) - 21;
  //     ret2 += ch.toString() + "0a";
  //   }
  //
  //   return ret2;
  // }
  //
  // Future _UploadMarkAttendance() async {
  //
  //   String TimeStamp = getCurrentTimestamp();
  //   //print("currDateTime" + TimeStamp);
  //   int ORDERIDToDelete = 0;
  //   AllMarkedAttendances =[];
  //   await databaseController.getAllMarkedAttendances(0).then((val) async {
  //
  //     AllMarkedAttendances = val.cast<Map<String, dynamic>>();
  //
  //     //print("_UploadMarkAttendance" + AllMarkedAttendances.toString());
  //
  //
  //     for (int i = 0; i < AllMarkedAttendances.length; i++) {
  //       String orderParam = "MobileTimestamp=" +
  //           TimeStamp +
  //           "&MobileTransactionNo=" +
  //           AllMarkedAttendances[i]['mobile_request_id'].toString() +
  //           "&AttendanceType=" +
  //           AllMarkedAttendances[i]['attendance_type_id'].toString() +
  //           "&MobileTimestamp=" +
  //           AllMarkedAttendances[i]['mobile_timestamp'].toString() +
  //           "&UserID=" +
  //           username.value.toString() +
  //           "&Lat=" +
  //           AllMarkedAttendances[i]['lat'].toString() +
  //           "&Lng=" +
  //           AllMarkedAttendances[i]['lng'].toString() +
  //           "&Accuracy=" +
  //           AllMarkedAttendances[i]['accuracy'].toString() +
  //           "&DeviceID=" +
  //           AllMarkedAttendances[i]['uuid'] +
  //           "&AppVersion=''" +
  //           "";
  //       ORDERIDToDelete =
  //       AllMarkedAttendances[i]['mobile_request_id'];
  //
  //       var QueryParameters = <String, String>{
  //         "SessionID": EncryptSessionID(orderParam),
  //       };
  //       //print("orderParam" + orderParam.toString());
  //       const String serverIp = "18.184.139.178";
  //       const String path = "/portal/mobile/attendance/MobileAttendance";
  //
  //       var url = Uri.http(serverIp, path, QueryParameters);
  //       //var localUrl = "http://192.168.30.125:8080/nisa_portal/mobile/MobileSyncMarkAttendanceV3";
  //
  //       //print("url :" + url.toString());
  //       try {
  //         var response = await http.post(url,
  //             headers: {
  //               HttpHeaders.contentTypeHeader:
  //               'application/x-www-form-urlencoded'
  //             },
  //             body: QueryParameters);
  //
  //         var responseBody = json.decode(utf8.decode(response.bodyBytes));
  //         // //print('called4');
  //         if (response.statusCode == 200) {
  //           //  if (responseBody["success"] == "true") {
  //           //   print ("success");
  //           //   Navigator.of(context, rootNavigator: true).pop('dialog');
  //           //  _showDialog("Success", "Attendance saved", 1);
  //
  //           await databaseController.markAttendanceUploaded(ORDERIDToDelete);
  //           await  _UploadMarkAttendancePhoto();
  //           //print("After _UploadMarkAttendancePhoto");
  //         } else {
  //           // If that response was not OK, throw an error.
  //
  //           //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
  //         }
  //       } catch (e) {
  //         //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  //         // _showDialog("Error", "An error has occured " + e.toString(), 1);
  //       }
  //       //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);
  //
  //     }
  //   });
  // }
  // Future _UploadMarkAttendancePhoto() async {
  //   AllMarkedAttendancesPhotos = [];
  //   await databaseController.getAllMarkedUploadedAttendances(0).then((val) async {
  //
  //     AllMarkedAttendancesPhotos = val.cast<Map<String, dynamic>>();
  //
  //     //print(
  //     //     "_UploadMarkAttendancePhoto     getAllMarkedUploadedAttendances ==============>>> " +
  //     //         AllMarkedAttendancesPhotos.toString());
  //
  //
  //     for (int i = 0; i < AllMarkedAttendancesPhotos.length; i++) {
  //       //print("inside loop");
  //       int ORDERIDToDelete =
  //       AllMarkedAttendancesPhotos[i]['mobile_request_id'];
  //       try {
  //         //print("image_path :"+AllMarkedAttendancesPhotos[i]['image_path']);
  //         File photoFile = File(AllMarkedAttendancesPhotos[i]['image_path']);
  //         var stream =
  //         new http.ByteStream(DelegatingStream.typed(photoFile.openRead()));
  //         var length = await photoFile.length();
  //         //var localUrl = Uri.http(globals.ServerURLLocal,"/nisa_portal/mobile/MobileUploadMarkAttendaceImage");
  //         const String serverIp = "18.184.139.178";
  //         const String path = "/portal/mobile/attendance/MobileAttendanceImage";
  //
  //         var url = Uri.http(serverIp, path);
  //         String fileName = photoFile.path.split('/').last;
  //         //print("Image url :"+url.toString());
  //         var request = new http.MultipartRequest("POST", url);
  //         request.fields['MobileTransactionNo'] =
  //             AllMarkedAttendancesPhotos[i]['mobile_request_id'].toString();
  //         request.fields['UserID'] =
  //             username.value;
  //
  //         var multipartFile = new http.MultipartFile('file', stream, length,
  //             filename: fileName);
  //         // var multipartFile = new http.MultipartFile.fromString("file", photoFile.path);
  //         request.files.add(multipartFile);
  //         var response = await request.send();
  //         //print(response.statusCode);
  //
  //         if (response.statusCode == 200) {
  //           //print("MobileUploadMarkAttendaceImage SUCCESS");
  //           await databaseController.markAttendanceUploadedPhoto(ORDERIDToDelete);
  //           //Navigator.of(context, rootNavigator: true).pop('dialog');
  //           //_showDialog("Success", "Attendance saved", 1);
  //           //Navigator.push(context, MaterialPageRoute(builder: (context) => Attendance()));
  //           _UploadMarkAttendance();
  //           _UploadMarkAttendancePhoto();
  //
  //           //print("MarkAttendanceLocally 3");
  //         } else if (response.statusCode == 500) {
  //           await databaseController.markAttendanceUploadedPhoto(ORDERIDToDelete);
  //         }
  //         // } else {
  //         //   // If that response was not OK, throw an error.
  //         //   //print("MobileUploadMarkAttendaceImage NOT WORKEDd");
  //         //  _showDialog(
  //         //       "Error", "An error has occured ", 0);
  //         // }
  //
  //       } catch (e) {
  //         //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  //         //print("e.toString()  " + e.toString());
  //         // _showDialog("Error", "An error has occured " + e.toString(), 1);
  //       }
  //       //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);
  //
  //     }
  //   });
  // }

}
