import 'dart:convert';

import 'package:async/async.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:order_booker/attendance.dart';
import 'package:order_booker/home.dart';
import 'package:order_booker/pre_sell_route.dart';
import 'package:order_booker/shopAction.dart';

import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;
import 'com/pbc/dao/repository.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;

// Obtain a list of the available cameras on the device.

// Get a specific camera from the list of available cameras.

class Merchandising extends StatefulWidget {
  @override
  _Merchandising createState() => _Merchandising();
}

class _Merchandising extends State<Merchandising> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  File _image;
  File _poster1;
  File _poster2;
  File _hanger;
  File _wobbler;
  File _shelf1;
  File _shelf2;

  var imagePath;
  int imageTypeId = 0;

  int mobileRequestId = 0;

  Repository repo = new Repository();
  List imageDetailList = new List();
  List<Map<String, dynamic>> AllMerchandsingPhotos;

  bool isLocationTimedOut = false;

  Future openCamera(typeId) async {
    print("Fronst Side Image");
    final ImagePicker _picker = ImagePicker();
    imagePath = (await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.rear));

//    imagePath = (await new ImagePicker().getImage(source: ImageSource.camera, imageQuality: 30, preferredCameraDevice: CameraDevice.rear));

    setState(() {
      imageTypeId = typeId;
      File file = File(imagePath.path);
      if (typeId == 1) {
        _shelf1 = file;
        _image = file;
        imageDetailList.add({"image": _shelf1.path, "typeId": imageTypeId});
      } else if (typeId == 2) {
        _shelf2 = file;
        _image = file;
        imageDetailList.add({"image": _shelf2.path, "typeId": imageTypeId});
      } else if (typeId == 3) {
        _poster1 = file;
        _image = file;
        imageDetailList.add({"image": _poster1.path, "typeId": imageTypeId});
      } else if (typeId == 4) {
        _poster2 = file;
        _image = file;
        imageDetailList.add({"image": _poster2.path, "typeId": imageTypeId});
      } else if (typeId == 5) {
        _hanger = file;
        _image = file;
        imageDetailList.add({"image": _hanger.path, "typeId": imageTypeId});
      } else if (typeId == 6) {
        _wobbler = file;
        _image = file;
        imageDetailList.add({"image": _wobbler.path, "typeId": imageTypeId});
      }
    });
  }

  @override
  void initState() {
    imageDetailList.clear();

    repo.getAllMerchandising(0).then((val) async {
      setState(() {
        AllMerchandsingPhotos = val;
        print(
            "_UploadMerchandisingPhoto     getAllMerchandising ==============>>> " +
                AllMerchandsingPhotos.toString());
      });
    });
  }

  bool areImagesCaptured() {
    return _shelf1 != null && _shelf2 != null;
  }

  // Function to navigate to the next screen
  void checkImageCaptured() {
    if (areImagesCaptured()) {
      print("helloo111111111oo");

      MerchandisingLocally();

      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    } else {
      print("helloooo");
      // Show an error message indicating that both images need to be captured
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please capture shelves images before saving.'),
      ));
    }
  }

  MerchandisingLocally() async {
    print("MerchandisingLocally 1");
    Dialogs.showLoadingDialog(context, _keyLoader);
    Position position = globals.currentPosition;
    if (position == null) {
      globals.getCurrentLocation(context).then((position1) {
        position = position1;
      }).timeout(Duration(seconds: 7), onTimeout: (() {
        //   print("i am here timedout");

        setState(() {
          isLocationTimedOut = true;
        });
      })).whenComplete(() async {
        double lat = 0.0;
        double lng = 0.0;
        double accuracy = 0.0;
        print(position);
        if (position != null || isLocationTimedOut) {
          if (isLocationTimedOut == false) {
            lat = position.latitude;
            lng = position.longitude;
            accuracy = position.accuracy;
          }
          print(position);

          await repo.insertMerchandising(
              globals.getUniqueMobileId(),
              globals.OutletID,
              lat,
              lng,
              accuracy,
              0,
              globals.DeviceID,
              imageDetailList,
              0,
              globals.UserID);
          Navigator.of(context, rootNavigator: true).pop('dialog');
          _UploadMerchandisingPhoto();

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShopAction()));
        } else {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Alert"),
                  content: new Text("Please allow location to proceed"),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new ElevatedButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        }
      });
    } else {
      await repo.insertMerchandising(
          globals.getUniqueMobileId(),
          globals.OutletID,
          globals.currentPosition.latitude,
          globals.currentPosition.longitude,
          globals.currentPosition.accuracy,
          0,
          globals.DeviceID,
          imageDetailList,
          0,
          globals.UserID);

      print("MerchandisingLocally 2");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      //_showDialog("Success", "Saved", 1);
      print("MerchandisingLocally 3");
      _UploadMerchandisingPhoto();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShopAction()),
      );
    }
  }

  Future<bool> _checkIfImageCaptured(int id) async {
    if (id == 1 || id == 2 || id == 3 || id == 4) {
      return true;
    }
    return false;
  }

  // Future _UploadMerchandisingPhoto() async {
  //   AllMerchandsingPhotos = new List();
  //   repo.getAllMerchandising(0).then((val) async {
  //     setState(() {
  //       AllMerchandsingPhotos = val;
  //
  //       print(
  //           "_UploadMerchandisingPhoto     getAllMerchandising ==============>>> " +
  //               AllMerchandsingPhotos.toString());
  //     });
  //     print("AllMerchandsingPhotos.length  ============>>. " +
  //         AllMerchandsingPhotos.length.toString());
  //     for (int i = 0; i < AllMerchandsingPhotos.length; i++) {
  //       int ORDERIDToDelete =
  //           int.parse(AllMerchandsingPhotos[i]['mobile_request_id']);
  //       try {
  //         File photoFile = File(AllMerchandsingPhotos[i]['image']);
  //
  //         var stream =
  //             new http.ByteStream(DelegatingStream.typed(photoFile.openRead()));
  //         var length = await photoFile.length();
  //         var localUrl = Uri.https(
  //             globals.ServerURL, "/portal/mobile/MobileUploadOrdersImageV2");
  //         var url = Uri.https(
  //             globals.ServerURL, '/portal/mobile/MobileUploadOrdersImageV2');
  //
  //         String fileName = photoFile.path.split('/').last;
  //
  //         var request = new http.MultipartRequest("POST", url);
  //         request.fields['mobile_timestamp'] =
  //             AllMerchandsingPhotos[i]['mobile_timestamp'].toString();
  //         request.fields['outletId'] =
  //             AllMerchandsingPhotos[i]['outlet_id'].toString();
  //         request.fields['lat'] = AllMerchandsingPhotos[i]['lat'].toString();
  //         request.fields['lng'] = AllMerchandsingPhotos[i]['lng'].toString();
  //         request.fields['accuracy'] =
  //             AllMerchandsingPhotos[i]['accuracy'].toString();
  //         request.fields['uuid'] = AllMerchandsingPhotos[i]['uuid'].toString();
  //         request.fields['typeId'] =
  //             AllMerchandsingPhotos[i]['type_id'].toString();
  //         request.fields['userId'] =
  //             AllMerchandsingPhotos[i]['user_id'].toString();
  //
  //         var multipartFile = new http.MultipartFile('file', stream, length,
  //             filename: fileName);
  //
  //         request.files.add(multipartFile);
  //         var response = await request.send();
  //         print(response.statusCode);
  //
  //         if (response.statusCode == 200) {
  //           print("markMerchandisingPhotoUploaded SUCCESS");
  //           await repo.markMerchandisingPhotoUploaded(
  //               ORDERIDToDelete, AllMerchandsingPhotos[i]['type_id']);
  //         }
  //       } catch (e) {
  //         //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  //         print("e.toString()  " + e.toString());
  //         //_showDialog("Error", "An error has occured " + e.toString(), 1);
  //       }
  //       //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);
  //     }
  //   });
  // }
  // Future _UploadMerchandisingPhoto(int id,  label) async {
  //   AllMerchandsingPhotos = new List();
  //   repo.getAllMerchandising(0).then((val) async {
  //     setState(() {
  //       AllMerchandsingPhotos = val;
  //
  //       print(
  //           "_UploadMerchandisingPhoto     getAllMerchandising ==============>>> " +
  //               AllMerchandsingPhotos.toString());
  //     });
  //     print("AllMerchandsingPhotos.length  ============>>. " +
  //         AllMerchandsingPhotos.length.toString());
  //     // if (id == 1) {
  //     //   bool imageCaptured = await _checkIfImageCaptured(id);
  //     //   if (!imageCaptured) {
  //     //     print("Image is compulsory for id 1");
  //     //     return;
  //     //   }
  //     // }
  //     for (int i = 0; i < AllMerchandsingPhotos.length; i++) {
  //       int ORDERIDToDelete =
  //           int.parse(AllMerchandsingPhotos[i]['mobile_request_id']);
  //       // if (id == 2 || id == 3 || id == 4) {
  //       //   bool imageCaptured = await _checkIfImageCaptured(id);
  //       //   if (!imageCaptured) {
  //       //     print("No image captured for id $id");
  //       //     continue;
  //       //   }
  //       // }
  //       try {
  //         File photoFile = File(AllMerchandsingPhotos[i]['image']);
  //
  //         var stream =
  //             new http.ByteStream(DelegatingStream.typed(photoFile.openRead()));
  //         var length = await photoFile.length();
  //         // var localUrl = Uri.https(
  //         //     globals.ServerURL, "/portal/mobile/MobileUploadOrdersImageV2");
  //         var url = Uri.https(
  //             globals.ServerURL, '/mobile/MobileSyncMerchandiserWithImages');
  //
  //         String fileName = photoFile.path.split('/').last;
  //
  //         var request = new http.MultipartRequest("POST", url);
  //         // request.fields['mobile_timestamp'] =
  //         //     AllMerchandsingPhotos[i]['mobile_timestamp'].toString();
  //         // request.fields['outletId'] =
  //         //     AllMerchandsingPhotos[i]['outlet_id'].toString();
  //         // request.fields['lat'] = AllMerchandsingPhotos[i]['lat'].toString();
  //         // request.fields['lng'] = AllMerchandsingPhotos[i]['lng'].toString();
  //         // request.fields['accuracy'] =
  //         //     AllMerchandsingPhotos[i]['accuracy'].toString();
  //         // request.fields['uuid'] = AllMerchandsingPhotos[i]['uuid'].toString();
  //         // request.fields['typeId'] =
  //         //     AllMerchandsingPhotos[i]['type_id'].toString();
  //         // request.fields['userId'] =
  //         //     AllMerchandsingPhotos[i]['user_id'].toString();
  //         request.fields['id'] = id.toString();  // Add the id parameter
  //         request.fields['label'] = label;
  //         var multipartFile = new http.MultipartFile('file', stream, length,
  //             filename: fileName);
  //
  //         request.files.add(multipartFile);
  //         var response = await request.send();
  //         print(response.statusCode);
  //
  //         if (response.statusCode == 200) {
  //
  //           print("markMerchandisingPhotoUploaded SUCCESS");
  //           print("id:");
  //           await repo.markMerchandisingPhotoUploaded(
  //               ORDERIDToDelete, AllMerchandsingPhotos[i]['type_id']);
  //         }
  //       } catch (e) {
  //         //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  //         print("e.toString()  " + e.toString());
  //         //_showDialog("Error", "An error has occured " + e.toString(), 1);
  //       }
  //       //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);
  //     }
  //   });
  // }
  Future _UploadMerchandisingPhoto() async {
    AllMerchandsingPhotos = new List();
    repo.getAllMerchandising(0).then((val) async {
      setState(() {
        AllMerchandsingPhotos = val;

        print(
            "_UploadMerchandisingPhoto     getAllMerchandising ==============>>> " +
                AllMerchandsingPhotos.toString());
      });

      print("AllMerchandsingPhotos.length  ============>>. " +
          AllMerchandsingPhotos.length.toString());
      for (int i = 0; i < AllMerchandsingPhotos.length; i++) {
        print("Inside for");
        int ORDERIDToDelete =
            int.parse(AllMerchandsingPhotos[i]['mobile_request_id']);
        try {
          File photoFile = File(AllMerchandsingPhotos[i]['image']);
          print("Inside try");

          // Use http.ByteStream directly
          var stream = http.ByteStream(photoFile.openRead());
          var length = await photoFile.length();
          var url = Uri.https(globals.ServerURL,
              '/portal/mobile/MobileSyncMerchandiserWithImagesV2');
          print(url);
          String fileName = photoFile.path.split('/').last;

          var request = http.MultipartRequest("POST", url);

          // Ensure all fields are converted to strings
          request.fields['MobileTimestamp'] = AllMerchandsingPhotos[i]['mobile_timestamp'].toString();
          request.fields['MerchandiserID'] = AllMerchandsingPhotos[i]['mobile_request_id'].toString();
          print("1");
          request.fields['OutletID'] = AllMerchandsingPhotos[i]['outlet_id'].toString();
          print("2");
          request.fields['Lat'] = AllMerchandsingPhotos[i]['lat'].toString();
          print("3");
          request.fields['Lng'] = AllMerchandsingPhotos[i]['lng'].toString();
          print("4");
          request.fields['accuracy'] = AllMerchandsingPhotos[i]['accuracy'].toString();
          print("6");
          request.fields['imgType'] = getImagetypeid(AllMerchandsingPhotos[i]['type_id']).toString();
          print("7");
          request.fields['deviceId'] = globals.DeviceID.toString();
          print("8");
          request.fields['platform'] = "android";
          print("9");
          request.fields['version'] = globals.appVersion.toString();
          print("10");
          request.fields['UserID'] = AllMerchandsingPhotos[i]['user_id'].toString();
          print("11");
          request.fields['distributor_id'] = globals.distributor_id.toString();
          request.fields['tso_id'] = globals.tso_id.toString();
          request.fields['asm_id'] = globals.asm_id.toString();
          request.fields['rsm_id'] = globals.rsm_id.toString();
          request.fields['region_id'] = globals.region_id.toString();
          request.fields['city_id'] = globals.city_id.toString();
          request.fields['pjpid'] = globals.pjpid.toString();

          var multipartFile = http.MultipartFile('file', stream, length, filename: fileName);

          request.files.add(multipartFile);
          print("======"+request.files.toString());
          var response = await request.send();
          print("Status Code :" + response.statusCode.toString());

          if (response.statusCode == 200) {
            print("markMerchandisingPhotoUploaded SUCCESS");
            await repo.markMerchandisingPhotoUploaded(
                ORDERIDToDelete, AllMerchandsingPhotos[i]['type_id']);
          } else {
            print("Error inside If");
          }
        } catch (e) {
          //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          print("e.toString()  " + e.toString());
          _showDialog("Error", "An error has occurred " + e.toString(), 1);
        }
        //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);
      }
    });
  }
  int getImagetypeid(int typeId) {
    switch (typeId) {
      case 1:
        return 1;
      case 2:
        return 1;
      case 3:
        return 2;
      case 4:
        return 2;
      case 5:
        return 3;
      case 6:
        return 4;
      default:
        throw ArgumentError("Invalid type ID");
    }
  }


  // void fetchData() async {
  //   var baseUrl = Uri.https(globals.ServerURL, '/mobile/MobileSyncMerchandiserWithImages');
  //
  //   // Define your parameters correctly
  //   var parameters = {
  //     'id': 'label',
  //     '1': 'Shelf',
  //     '2': 'Poster',
  //     '3': 'Hanger',
  //     '4': 'Wobbler',
  //     // Add more parameters as needed
  //   };
  //
  //   // Build the URL with parameters
  //   var uri = Uri.parse(baseUrl.toString() + '?' + parameters.entries.map((e) => '${e.key}=${e.value}').join('&'));
  //
  //   try {
  //     // Make the GET request
  //     var response = await http.get(uri);
  //
  //     // Check the response status code
  //     if (response.statusCode == 200) {
  //       // If the request was successful, you can parse the response body
  //       var responseBody = response.body;
  //       // Handle the response data
  //       print(responseBody);
  //     } else {
  //       // If the request failed, handle the error
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   } catch (e) {
  //     // Handle any exceptions
  //     print('Request failed with error: $e');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title: Text(
            "Merchandising",
            style: new TextStyle(color: Colors.white, fontSize: 14),
          ),
          actions: <Widget>[],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //     child: const Icon(Icons.camera_alt),
        //     onPressed: () {
        //       openCamera(_poster1);
        //     }),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          color: Colors.green[100],
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              imagePath != null ? Text("") : Text(""),
              RawMaterialButton(
                // fillColor: Colors.teal,
                elevation: 0,
                splashColor: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Save')],
                ),
                onPressed: checkImageCaptured,
                /*onPressed: () {



                  }*/
              )
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 10),
          constraints: BoxConstraints.expand(height: 800),

          // color: Colors.green,
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "TPOSM",
                          style: TextStyle(fontSize: 16),
                        ),
                        padding: EdgeInsets.all(10),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                openCamera(1);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(right: 50),
                                      child: Text(
                                        "*",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    _shelf1 != null
                                        ? new Image.file(
                                            _shelf1,
                                            width: 100,
                                            height: 100,
                                          )
                                        : Image.asset(
                                            "assets/images/take_photo.png",
                                            width: 100,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Text(
                                          'Shelf',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              ))),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                openCamera(2);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(right: 50),
                                      child: Text(
                                        "*",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    _shelf2 != null
                                        ? new Image.file(
                                            _shelf2,
                                            width: 100,
                                            height: 100,
                                          )
                                        : Image.asset(
                                            "assets/images/take_photo.png",
                                            width: 100,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Text(
                                          'shelf',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              )))
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                openCamera(3);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    _poster1 != null
                                        ? new Image.file(
                                            _poster1,
                                            width: 100,
                                            height: 100,
                                          )
                                        : Image.asset(
                                            "assets/images/take_photo.png",
                                            width: 100,
                                            height: 100,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Text(
                                          'Poster 1',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              ))),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                openCamera(4);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    _poster2 != null
                                        ? new Image.file(
                                            _poster2,
                                            width: 100,
                                            height: 100,
                                          )
                                        : Image.asset(
                                            "assets/images/take_photo.png",
                                            width: 100,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Text(
                                          'Poster 2',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              )))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                openCamera(5);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    _hanger != null
                                        ? new Image.file(
                                            _hanger,
                                            width: 100,
                                            height: 100,
                                          )
                                        : Image.asset(
                                            "assets/images/take_photo.png",
                                            width: 100,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Text(
                                          'Hanger',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              ))),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                openCamera(6);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    _wobbler != null
                                        ? new Image.file(
                                            _wobbler,
                                            width: 100,
                                            height: 100,
                                          )
                                        : Image.asset(
                                            "assets/images/take_photo.png",
                                            width: 100,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Text(
                                          'Wobbler',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              )))
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       child: Text(
                  //         "PPOSM",
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //       padding: EdgeInsets.all(10),
                  //     )
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Expanded(
                  //         child: GestureDetector(
                  //             onTap: () {
                  //               openCamera(7);
                  //             },
                  //             child: Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: <Widget>[
                  //                   _pog != null
                  //                       ? new Image.file(
                  //                           _pog,
                  //                           width: 100,
                  //                           height: 100,
                  //                         )
                  //                       : Image.asset(
                  //                           "assets/images/take_photo.png",
                  //                           width: 100,
                  //                         ),
                  //                   Padding(
                  //                       padding: EdgeInsets.fromLTRB(
                  //                           0.0, 5.0, 0.0, 0.0),
                  //                       child: Text(
                  //                         'POG',
                  //                         style: TextStyle(
                  //                             fontSize: 12,
                  //                             color: Colors.black),
                  //                       )),
                  //                 ],
                  //               ),
                  //             ))),
                  //     Expanded(
                  //         child: GestureDetector(
                  //             onTap: () {
                  //               openCamera(8);
                  //             },
                  //             child: Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: <Widget>[
                  //                   _pog2 != null
                  //                       ? new Image.file(
                  //                           _pog2,
                  //                           width: 100,
                  //                           height: 100,
                  //                         )
                  //                       : Image.asset(
                  //                           "assets/images/take_photo.png",
                  //                           width: 100,
                  //                         ),
                  //                   Padding(
                  //                       padding: EdgeInsets.fromLTRB(
                  //                           0.0, 5.0, 0.0, 0.0),
                  //                       child: Text(
                  //                         'POG 2',
                  //                         style: TextStyle(
                  //                             fontSize: 12,
                  //                             color: Colors.black),
                  //                       )),
                  //                 ],
                  //               ),
                  //             )))
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Expanded(
                  //         child: GestureDetector(
                  //             onTap: () {
                  //               openCamera(9);
                  //             },
                  //             child: Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: <Widget>[
                  //                   _shelf1 != null
                  //                       ? new Image.file(
                  //                           _shelf1,
                  //                           width: 100,
                  //                           height: 100,
                  //                         )
                  //                       : Image.asset(
                  //                           "assets/images/take_photo.png",
                  //                           width: 100,
                  //                         ),
                  //                   Padding(
                  //                       padding: EdgeInsets.fromLTRB(
                  //                           0.0, 5.0, 0.0, 0.0),
                  //                       child: Text(
                  //                         'Shelf 1',
                  //                         style: TextStyle(
                  //                             fontSize: 12,
                  //                             color: Colors.black),
                  //                       )),
                  //                 ],
                  //               ),
                  //             ))),
                  //     Expanded(
                  //         child: GestureDetector(
                  //             onTap: () {
                  //               openCamera(10);
                  //             },
                  //             child: Container(
                  //               padding: EdgeInsets.all(10),
                  //               child: Column(
                  //                 children: <Widget>[
                  //                   _shelf2 != null
                  //                       ? new Image.file(
                  //                           _shelf2,
                  //                           width: 100,
                  //                           height: 100,
                  //                         )
                  //                       : Image.asset(
                  //                           "assets/images/take_photo.png",
                  //                           width: 100,
                  //                         ),
                  //                   Padding(
                  //                       padding: EdgeInsets.fromLTRB(
                  //                           0.0, 5.0, 0.0, 0.0),
                  //                       child: Text(
                  //                         'Shelf 2',
                  //                         style: TextStyle(
                  //                             fontSize: 12,
                  //                             color: Colors.black),
                  //                       )),
                  //                 ],
                  //               ),
                  //             )))
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ));
  }

  void ShowError(context) {
    Flushbar(
      messageText: Column(
        children: <Widget>[
          Text(
            "Please take picture to proceed.",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundGradient: LinearGradient(colors: [Colors.black, Colors.black]),
      icon: Icon(
        Icons.notifications_active,
        size: 30.0,
        color: Colors.teal,
      ),
      duration: Duration(seconds: 2),
      leftBarIndicatorColor: Colors.teal,
    )..show(context);
  }

  void _showDialog(String Title, String Message, int isSuccess) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(Title),
          content: new Text(Message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Close"),
              onPressed: () {
                if (isSuccess == 1) {
                  Navigator.push(
                    context,
                    //

                    MaterialPageRoute(builder: (context) => ShopAction()
                        //  MaterialPageRoute(builder: (context) =>ShopAction_test()

                        ),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
