// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../services/database.dart';
import '../snack_bar_model.dart';
import '../utilities/common_functions.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:io';

import 'daily_visit_controller.dart';
import 'login_controller.dart';

class PerformTask extends GetxController {
  final DatabaseHelper dbController = Get.put(DatabaseHelper());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());
  final DailyVisitController dailyVisitController = Get.put(DailyVisitController());
  final LoginController loginController = Get.put(LoginController());


  final List<LinearGradient> cardGradients = [
    LinearGradient(colors: [Color(0xFFFAEFE9), Color(0xFFFAEFE9)]),
    LinearGradient(colors: [Color(0xFFDDF3EB), Color(0xFFDDF3EB)]),
    LinearGradient(colors: [Color(0xFFE1F5FC), Color(0xFFE1F5FC)]),
    LinearGradient(colors: [Color(0xFFE1EBEF), Color(0xFFE1EBEF)]),
  ];

  // var outletImagePath = ''.obs;
  // var storageImagePath = ''.obs;
  // var visitingCardImagePath = ''.obs;
  //

  // final _picker = ImagePicker();
  var imagePath = ''.obs;
  int OrderID = 0;

  @override
  void onInit() {
    super.onInit();
    commonFunctions
        .fetchDeviceId(); // Fetch the device ID when the controller is initialized
    commonFunctions.fetchLocation();
    commonFunctions.fetchUsernameFromLocalDB();
  }

  @override
  void onClose() {
    // Cleanup when controller is disposed
    super.onClose();
  }

  // bool areAllImagesSelected() {
  //   return commonFunctions.outletImagePath.isNotEmpty &&
  //       commonFunctions.storageImagePath.isNotEmpty &&
  //       commonFunctions.visitingCardImagePath.isNotEmpty;
  // }

  // Method to trigger validation and proceed if all images are selected
  Future saveImageDataLocally() async {
    if (commonFunctions.outletImagePath.isNotEmpty &&
        commonFunctions.storageImagePath.isNotEmpty &&
        commonFunctions.visitingCardImagePath.isNotEmpty) {
      // All images are set, proceed with registration
      await submitData();
      commonFunctions.visitingCardImagePath.value = '';
      commonFunctions.storageImagePath.value = '';
      commonFunctions.outletImagePath.value = '';
      CustomSnackbar.show(
        title: "Success",
        message: "images selected.",
      );
      // Logic to proceed
      return true;
    } else {
      // Show error message
      CustomSnackbar.show(
        title: "Error",
        message: "Please capture all required images before proceeding.",
      );
      return false;

    }
  }


  Future<void> submitData() async {
    // Sample values for userID, lat, lng, accuracy, createdOn, orderID, and deviceID
    int userID = int.parse(commonFunctions.userId.value);
    String lat = commonFunctions.latitude.value.toString();
    String lng = commonFunctions.longitude.value.toString();
    String accuracy = commonFunctions.accuracy.value.toString();
    String createdOn = DateTime.now().toString();
    int orderID =dailyVisitController.orderId.value;
    String deviceID = commonFunctions.deviceId.value;

    // Call the addOutletImage function with the paths of the captured images
    await dbController.addOutletImage(
      userID: userID,
      imagePath1: commonFunctions.outletImagePath.value,
      imagePath2: commonFunctions.storageImagePath.value,
      imagePath3: commonFunctions.visitingCardImagePath.value,
      lat: lat,
      lng: lng,
      accuracy: accuracy,
      createdOn: createdOn,
      orderID: orderID.toString(),
      deviceID: deviceID,

    );
    print('Outlet Image Path: ${commonFunctions.outletImagePath.value}');
    print('Storage Image Path: ${commonFunctions.storageImagePath.value}');
    print(
        'Visiting Card Image Path: ${commonFunctions.visitingCardImagePath.value}');
  }

  Future<void> sendOutletImage() async {
    List AllDocuments = [];

    // Fetch all outlet images from the local database
    await dbController.getAllOutletImages().then((val) async {
      AllDocuments = val;
      print("retrieve data::::${AllDocuments}");

      for (int i = 0; i < AllDocuments.length; i++) {
        int MobileRequestID = int.parse(AllDocuments[i]['OrderID'].toString());
        print("MobileRequestID ::::${MobileRequestID}");
        // const String serverIp = "192.168.201.197:8080";  // Replace with your actual server IP


        final url = Uri.parse(
            'http://18.199.215.22/portal/mobile/MobileUploadOrdersImage');

        // Convert image paths to File objects
        var photoFile1 = File(AllDocuments[i]['imagePath1']);
        var photoFile2 = File(AllDocuments[i]['imagePath2']);
        var photoFile3 = File(AllDocuments[i]['imagePath3']);

        try {
          print("Sending data for user: " +
              commonFunctions.userId.value.toString());

          var request = http.MultipartRequest('POST', url)
            ..fields['order_id'] = MobileRequestID.toString();


          // Add the three image files if they exist
          if (photoFile1.existsSync()) {
            request.files
                .add(await _createMultipartFile(photoFile1, "Outlet_image1"));
          }
          if (photoFile2.existsSync()) {
            request.files
                .add(await _createMultipartFile(photoFile2, "Outlet_image2"));
          }
          if (photoFile3.existsSync()) {
            request.files
                .add(await _createMultipartFile(photoFile3, "Outlet_image3"));
          }

          // Send the request and await response
          var response = await request.send();

          if (response.statusCode == 200) {
            print("Image upload successful for order $MobileRequestID");
            var responseData = await response.stream.bytesToString();
            await dbController.markOrderImageUploaded(MobileRequestID.toString());
            print("Response: $responseData");
          } else {
            print(
                "Image upload failed with status code: ${response.statusCode}");
          }
        } catch (e) {
          print('Error uploading images: $e');
          // Handle the error here
        }
      }
    });
  }

  Future<http.MultipartFile> _createMultipartFile(
      File file, String fieldName) async {
    var stream = http.ByteStream(file.openRead());
    var length = await file.length();
    String fileName =
    basename(file.path); // Use path.basename to get the file name

    return http.MultipartFile(fieldName, stream, length, filename: fileName);
  }



  String encryptSessionID(String qry) {
    String ret = "";
    for (int i = 0; i < qry.length; i++) {
      int ch = (qry.codeUnitAt(i) * 5) - 21;
      ret += "$ch,";
    }

    String ret2 = "";
    for (int i = 0; i < ret.length; i++) {
      int ch = (ret.codeUnitAt(i) * 5) - 21;
      ret2 += "${ch}0a";
    }

    return ret2;
  }
  Future<void>  SaveNoOrder()async {
    print("SaveNoOrder");
    List<dynamic>  AllNoOrders = [];
/*    var currDate = new DateTime.now();
    String TimeStamp = currDate.toString();*/
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());
    var str = currDateTime.split(".");
    String TimeStamp = str[0];
    int ORDERIDToDelete = 0;
    String getCurrentTimestamp() {
      DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
      String currDateTime = dateFormat.format(DateTime.now());
      var str = currDateTime.split(".");

      String TimeStamp = str[0];
      return TimeStamp;
    }
    String getCurrentTimestampSql() {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
      String currDateTime = dateFormat.format(DateTime.now());
      var str = currDateTime.split(".");

      String TimeStamp = str[0];
      return TimeStamp;
    }
    await dbController.getOutletNoOrders().then((val) async {
      AllNoOrders = val;
      print("AllNoOrders :"+AllNoOrders.toString());
      print("AllNoOrders length :"+AllNoOrders.length.toString());

      for (int i = 0; i < AllNoOrders.length; i++){
        String orderParam = "MobileTransactionNo=${AllNoOrders[i]['id']}"
            "&PJPID=${loginController.PJPID.value}"
            "&timestamp=${getCurrentTimestamp()}"
            "&MobileTimestamp=${getCurrentTimestampSql()}"
            "&ReasonID=1&"
            "OutletID=${AllNoOrders[i]['outlet_id']}"
            "&UserID=${commonFunctions.userId}&"
            "Lat=${AllNoOrders[i]['lat']}&"
            "Lng=${AllNoOrders[i]['lng']}&"
            "Accuracy=0"
            "&UUID=${commonFunctions.deviceId.value}&"
            "Platform=android&"
            "AppVersion=1.0&"
            "RegionID=${loginController.region_id.value}&"
            "CityID=${loginController.city_id.value}"
            "&DeviceID=${commonFunctions.deviceId.value}";


        ORDERIDToDelete = AllNoOrders[i]['id'];
        print("orderParam for no order: $orderParam");
        print("ORDERIDToDelete: $ORDERIDToDelete");

        var QueryParameters = <String, String>{
          "SessionID": encryptSessionID(orderParam),
        };
       const String serverIp = "18.199.215.22";

        const String path = "/portal/mobile/MobileSyncNoOrdersV1";
        var url = Uri.http(serverIp, path);
        print(url);
        try {
          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
              },
              body: QueryParameters);

          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          print("statusCode ===: ${response.statusCode}");

          if (response.statusCode == 200) {
            // await controller.sendNoOrderDataToServer();
            // await imageController.saveNoOrderAssets();
            //
            // await databaseController.markNoOrderUploaded(ORDERIDToDelete);
            // await databaseController.markOrderUploaded(ORDERIDToDelete);
            // await databaseController.markOrderCompleted(ORDERIDToDelete);
            // SnackBar(content: Text("Success: Order uploaded."));
            await dbController.markOrderUploaded(ORDERIDToDelete);
            print("Order successfully uploaded.");
          } else {
            print("Error: ${response.statusCode} - ${responseBody}");
          }
        } catch (e) {

          print("Exception========: $e");
        }
      }
    });
  }

}