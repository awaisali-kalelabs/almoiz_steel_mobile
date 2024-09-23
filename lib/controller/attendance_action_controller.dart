import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../services/database.dart';
import '../utilities/common_functions.dart';
import '../view/attendance_view.dart';
import 'attendance_controller.dart';

// import '../services/database_sqflite.dart';
// import '../view/attendence.dart';
// import '../widgets/first_page_widget.dart';
// import 'attendence_controller.dart';

class AttendanceActionController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var imagePath = Rx<File?>(null);
  var isLocationTimedOut = false.obs;
  var allMarkedAttendances = <Map<String, dynamic>>[].obs;
  var allMarkedAttendancesPhotos = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isLocationUpdated = false.obs;
  var latitude = 0.0.obs;
  var username = ''.obs;
  var longitude = 0.0.obs;
  var accuracy = 0.0.obs;
  late List<Map<String, dynamic>> AllMarkedAttendances;
  late List<Map<String, dynamic>> AllMarkedAttendancesPhotos;

  final TextEditingController updatedLatitudeController =
  TextEditingController();
  final TextEditingController updatedLongitudeController =
  TextEditingController();
  final TextEditingController updatedAccuracyController =
  TextEditingController();
  final DatabaseHelper dbController = Get.put(DatabaseHelper());
  final AttendanceController controller = Get.put(AttendanceController());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());

  @override
  void onInit() {
    super.onInit();
    // globals.startContinuousLocation(Get.context!);
/*
    updateLocation();
*/
    // Fetch all marked attendances
    fetchAllMarkedAttendances();
    fetchAllMarkedUploadedAttendances();
    fetchUsernameFromLocalDB();
  }

  void fetchUsernameFromLocalDB() async {
    String? storedUsername = await dbController.getStoredUsername();
    if (storedUsername != null && storedUsername.isNotEmpty) {
      username.value = storedUsername;
      //print("helloooo"+username.value.toString());
    } else {
      username.value = 'Guest'; // Or handle it as per your requirement
    }
  }

  Future<void> fetchAllMarkedAttendances() async {
    var pendingAttendances = await dbController.getAllMarkedAttendances(0);
    var uploadedAttendances = await dbController.getAllMarkedAttendances(1);
    allMarkedAttendances.addAll(pendingAttendances.cast<Map<String, dynamic>>());
    allMarkedAttendances.addAll(uploadedAttendances.cast<Map<String, dynamic>>());
  }

  Future<void> fetchAllMarkedUploadedAttendances() async {
    //print("fetchAllMarkedUploadedAttendances");
    var uploadedPhotos = await dbController.getAllMarkedUploadedAttendances(0);
    allMarkedAttendancesPhotos.assignAll(uploadedPhotos.cast<Map<String, dynamic>>());
    //print("allMarkedAttendancesPhotos : "+allMarkedAttendancesPhotos.toString());

  }

  /*Future<void> openCamera() async {
    try {
      final File? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.front,
      );
      if (image != null) {
        imagePath.value = File(image.path); // Convert XFile to File
      } else {
        // Handle the case where the user cancels the image capture
        Get.snackbar('Error', 'No image captured. Please try again.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Handle any errors that occur during image capture
      Get.snackbar('Error', 'Failed to capture image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }*/



  int getUniqueMobileId() {
    ////print("UserID:" + username.toString());
    String MobileId = "";
    if (username.toString().length > 4) {
      MobileId = username.toString() +
          DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      MobileId = username.toString() +
          DateTime.now().millisecondsSinceEpoch.toString();
    }
    return int.parse(MobileId);
  }
  Future<void> markAttendanceLocally() async {

    print("inside a markAttendanceLocally function");
    print(commonFunctions.checkInImage.value,);
    print( "attendanceTypeId :"+controller.attendanceTypeId.value.toString());
    print( "updatedLatitudeController :"+ updatedLatitudeController.text.toString());
    print( "updatedLongitudeController :"+updatedLongitudeController.text.toString());
    print( "updatedAccuracyController :"+updatedAccuracyController.text.toString());
    print( "username :"+username.toString());

    await dbController.markAttendance(
      getUniqueMobileId(),
      commonFunctions.checkInImage.value,
      controller.attendanceTypeId.value,
      commonFunctions.latitude.value,
     commonFunctions.longitude.value,
      commonFunctions.accuracy.value,
      username.value,
      0,
      getUniqueMobileId(),
      0,
    );

    //();
    Get.off(() => Attendance()); // Navigate to Attendance Screen

  }
  String getCurrentTimestamp() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());
    var str = currDateTime.split(".");

    String TimeStamp = str[0];
    return TimeStamp;
  }

  String EncryptSessionID(String qry) {
    String ret = "";
    //print(qry.length);
    for (int i = 0; i < qry.length; i++) {
      int ch = (qry.codeUnitAt(i) * 5) - 21;
      ret += ch.toString() + ",";
    }

    String ret2 = "";
    for (int i = 0; i < ret.length; i++) {
      int ch = (ret.codeUnitAt(i) * 5) - 21;
      ret2 += ch.toString() + "0a";
    }

    return ret2;
  }

  Future UploadMarkAttendance() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());
    String TimeStamp = getCurrentTimestamp();
    print("currDateTime" + TimeStamp);
    int ORDERIDToDelete = 0;
    AllMarkedAttendances =[];
    await dbController.getAllMarkedAttendances(0).then((val) async {

      AllMarkedAttendances = val.cast<Map<String, dynamic>>();

      print("_UploadMarkAttendance" + AllMarkedAttendances.toString());


      for (int i = 0; i < AllMarkedAttendances.length; i++) {
        String orderParam = "timestamp=" +
            currDateTime +
            "&AttendanceID=" +
            AllMarkedAttendances[i]['mobile_request_id'].toString() +
            "&TyepID=" +
            AllMarkedAttendances[i]['attendance_type_id'].toString() +
            "&MobileTimestamp=" +
            AllMarkedAttendances[i]['mobile_timestamp'].toString() +
            "&UserID=" +
           username.value.toString() +
            "&LAT=" +
            AllMarkedAttendances[i]['lat'].toString() +
            "&LNG=" +
            AllMarkedAttendances[i]['lng'].toString() +
            "&Accu=" +
            AllMarkedAttendances[i]['accuracy'].toString() +
            "&UUID=" +
            AllMarkedAttendances[i]['uuid'] +
            "&DevicePlatformVersion='Android'" +
            "";
        ORDERIDToDelete =
        AllMarkedAttendances[i]['mobile_request_id'];

        var QueryParameters = <String, String>{
          "SessionID": EncryptSessionID(orderParam),
        };
        print("orderParam" + orderParam.toString());
        const String serverIp = "18.199.215.22";
        const String path = "/portal/mobile/MobileSyncMarkAttendanceV3";
/*
         const String serverIp = "192.168.201.197:8080";  // Replace with your actual server IP
*/

        var url = Uri.http(serverIp, path);
        //var localUrl = "http://192.168.30.125:8080/nisa_portal/mobile/MobileSyncMarkAttendanceV3";

        print("url :" + url.toString());
        try {
          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader:
                'application/x-www-form-urlencoded'
              },
              body: orderParam);

          var responseBody = json.decode(utf8.decode(response.bodyBytes));
        print('called4');
          if (response.statusCode == 200) {
            //  if (responseBody["success"] == "true") {
              print ("success");
            //   Navigator.of(context, rootNavigator: true).pop('dialog');
            //  _showDialog("Success", "Attendance saved", 1);

            await dbController.markAttendanceUploaded(ORDERIDToDelete);
          } else {
            // If that response was not OK, throw an error.
            print("========================");
            //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
          }
        } catch (e) {
          print("ffffffffffffffffffffffffffffffffff");
          //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          // _showDialog("Error", "An error has occured " + e.toString(), 1);
        }
        //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);

      }
    });
  }
  Future<void> uploadMarkAttendancePhoto() async {
    print("Inside image function");
    List<Map<String, dynamic>> allMarkedAttendancesPhotos = [];

    try {
      allMarkedAttendancesPhotos = (await dbController.getAllMarkedUploadedAttendances(0)).cast<Map<String, dynamic>>();
      print("_UploadMarkAttendancePhoto getAllMarkedUploadedAttendances ==============>>> $allMarkedAttendancesPhotos");

      for (var photoData in allMarkedAttendancesPhotos) {
        int orderId = photoData['mobile_request_id'];
        String imagePath = photoData['image_path'];

        try {
          print(imagePath);
          File photoFile = File(imagePath);
          var stream = http.ByteStream(DelegatingStream.typed(photoFile.openRead()));
          var length = await photoFile.length();

          const String serverIp = "18.199.215.22";
          var url = Uri.http(serverIp, '/portal/mobile/MobileUploadMarkAttendaceImage');

          String fileName = photoFile.path.split('/').last;
          var request = http.MultipartRequest("POST", url)
            ..fields['value1'] = orderId.toString()
            ..files.add(http.MultipartFile('file', stream, length, filename: fileName));

          var response = await request.send();
          print(response.statusCode);

          if (response.statusCode == 200) {
            print("MobileUploadMarkAttendaceImage SUCCESS");
            await dbController.markAttendanceUploadedPhoto(orderId);
          } else {
            print("MobileUploadMarkAttendaceImage FAILED with status ${response.statusCode}");
            // Optionally handle the error response
          }
        } catch (e) {
          print("Error uploading photo for order $orderId: ${e.toString()}");
        }
      }
    } catch (e) {
      print("Error fetching marked attendance photos: ${e.toString()}");
    }
  }

}
