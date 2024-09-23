import 'dart:async';
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
import 'package:permission_handler/permission_handler.dart';
import 'globals.dart' as globals;
import 'package:another_flushbar/flushbar.dart';import 'package:http/http.dart' as http;
import 'package:network_type_reachability/network_type_reachability.dart';

// Obtain a list of the available cameras on the device.

// Get a specific camera from the list of available cameras.

class AttendanceAction extends StatefulWidget {
  @override
  _AttendanceActionState createState() => _AttendanceActionState();
}

class _AttendanceActionState extends State<AttendanceAction> {

  XFile _image;
  var imagePath;


  bool isLocationTimedOut = false;
  bool _isButtonDisabled = false;

  Future openCamera() async {
    print("Fronst Side Image");
    final ImagePicker _picker = ImagePicker();
    imagePath = (await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.front));

//    imagePath = (await new ImagePicker().getImage(source: ImageSource.camera, imageQuality: 30, preferredCameraDevice: CameraDevice.rear));

    setState(() {
      //File _image = File(imagePath);
      _image = imagePath;
      //  print("IMAGE PATH"+imagePath.toString());
      // print("IMAGE PATH"+_image.path);
    });
  }

  @override
  void initState() {
    _isButtonDisabled = false;
  }


  Future MarkAttendanceLocally() async {
    setState(() {
      _isButtonDisabled = true;
    });

    Future<String> _getCurrentNetworkStatus() async {
      if (Platform.isAndroid) {
        await NetworkTypeReachability().getPermisionsAndroid;
      }

      NetworkStatus status =
      await NetworkTypeReachability().currentNetworkStatus();
     /* "unreachable";
      "wifi";
      "mobile2G";
      "moblie3G";
      "moblie4G";
      "moblie5G";
      "otherMoblie";*/

      print("In func : "+status.toString());
      return status.toString();
    }

    String networkStatus = await _getCurrentNetworkStatus();
    print("Out func : "+networkStatus);

    int internetCheck =0;
    if(networkStatus == "NetworkStatus.wifi" || networkStatus == "NetworkStatus.moblie3G" || networkStatus == "NetworkStatus.moblie4G" || networkStatus == "NetworkStatus.moblie5G"){
      internetCheck =1;
    }


    print("MarkAttendanceLocally 1");
    var position = await GeolocatorPlatform.instance .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    double lat = position.latitude != null ? position.latitude : 0.0;
    double lng = position.longitude != null ? position.longitude : 0.0;
    double accuracy = position.accuracy != null ? position.accuracy : 0.0;
    String TimeStamp = globals.getCurrentTimestamp();

    String UUID = globals.getUniqueMobileId().toString();

    String orderParam = "timestamp=" + TimeStamp +
        "&AttendanceID=" + UUID +
        "&TyepID=" + globals.attendanceTypeId.toString() +
        "&MobileTimestamp=" + globals.getCurrentTimestampSql().toString() +
        "&UserID=" + globals.UserID.toString() +
        "&LAT=" + lat.toString() +
        "&LNG=" + lng.toString() +
        "&Accu=" + accuracy.toString() +
        "&UUID=" + globals.DeviceID.toString() +
        "&DevicePlatformVersion="+globals.appVersion;

    print("orderParam "+orderParam.toString());
    var QueryParameters = <String, String>{
      "SessionID": globals.EncryptSessionID(orderParam),
    };
    print("QueryParameters "+QueryParameters.toString());

   var url = Uri.https( globals.ServerURL, '/portal/mobile/MobileSyncMarkAttendanceV2');

    print("url" + url.toString());

    if(position != null) {
      if (internetCheck == 1) {
        try {
          print("Upload Attendance");
          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader:
                'application/x-www-form-urlencoded'
              },
              body: QueryParameters);

          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          //print("response "+responseBody.toString());
          if (responseBody["success"] == "true") {
            //  print("in true");

            // print(" responseBody[error]"+responseBody["error"]);
            File photoFile = File(_image.path);
            var stream =
            new http.ByteStream(DelegatingStream.typed(photoFile.openRead()));
            var length = await photoFile.length();
            var url = Uri.https(globals.ServerURL,
                '/portal/mobile/MobileUploadMarkAttendaceImage');
            String fileName = photoFile.path
                .split('/')
                .last;

            var request = new http.MultipartRequest("POST", url);
            request.fields['value1'] = UUID;
            var multipartFile = new http.MultipartFile('file', stream, length,
                filename: fileName);
            request.files.add(multipartFile);
            try {
              var response = await request.send().timeout(
                  const Duration(seconds: 10));
              // var response = await request.send();
              print("response : " + response.toString());
              if (response.statusCode == 200) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                _showDialog(
                    "Attendence Save", " Attendance marked successfully ", 1);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              } else {
                _showDialog(
                    "Error", " Error " + response.statusCode.toString(), 1);
              }
            } on TimeoutException catch (e) {
              print("e : " + e.toString());
              _showDialog(
                  "Error",
                  "Attendance not uploaded, Please Check your internet connection",
                  1);
            } on SocketException catch (e) {
              print("e2 : " + e.toString());
              _showDialog(
                  "Error", "Attendance not uploaded, Socket Error",
                  1);
            }
          } else if (responseBody["success"] == "false") {
            _showDialog("Error", responseBody["error"], 1);
          } else {
            _showDialog(
                "Error", responseBody["error_code"] + ": Attendance Not Upload",
                1);
          }
        } catch (e) {
          //  print('e ==> '+e.toString());
          //   Navigator.of(context, rootNavigator: true).pop('dialog');
          //  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          ///  ShowErrorGeneral(context, "Please login with remote server");
          _showDialog("Error : ", "Please login with remote server", 1);
        }
      } else {
        _showDialog("Error : ", "Please Check your internet connectivity", 1);
      }
    }else {
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
    setState(() {
      _isButtonDisabled = false;
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[800],
          title: Text(
            globals.attendanceTypeId == 1 ? "Check In" : "Check Out",
            style: new TextStyle(color: Colors.white, fontSize: 14),
          ),
          actions: <Widget>[],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.camera_alt),
            onPressed: () {
              openCamera();
            }),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          color: Colors.redAccent[100],
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              imagePath != null
                  ? RawMaterialButton(
                      //fillColor: Colors.teal,
                      elevation: 0,
                      splashColor: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text('Retake')],
                      ),
                      onPressed: () {
                        //print("M pressed");
                        setState(() {
                          imagePath = null;
                          _image = null;
                        });

                        openCamera();
                      })
                  : Text(""),
              RawMaterialButton(
                  // fillColor: Colors.teal,
                  elevation: 0,
                  splashColor: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(_isButtonDisabled ? "Hold on..." :  "Save")],
                  ),
                  onPressed: () => _image != null && imagePath != null
                      ? MarkAttendanceLocally()
                      : ShowError(context)
                  /*onPressed: () {

//_isButtonDisabled ? "Hold on..." :

                  }*/

                  )
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 10),
          constraints: BoxConstraints.expand(height: 800),

          // color: Colors.red,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: _image == null
                      ? Container(
                          child: Text(
                            "Please press camera button to take your picture",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                          alignment: Alignment.topLeft,
                        )
                      : new Image.file(File(_image.path)),
                ),
              ],
            ),
          ),
        ));
  }



  void ShowErrorGeneral(context, msg) {
    Flushbar(
      messageText: Column(
        children: <Widget>[
          Text(
            msg.toString(),
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
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.teal,
    )..show(context);
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

                    MaterialPageRoute(builder: (context) => Home()
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
