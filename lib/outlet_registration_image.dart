import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:another_flushbar/flushbar.dart';import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:order_booker/com/pbc/model/pre_sell_outlets.dart';
import 'com/pbc/dao/repository.dart';
import 'globals.dart' as globals;
import 'home.dart';

class OutletRegistrationImage extends StatefulWidget {
  String outletId;
  OutletRegistrationImage({this.outletId});
  @override
  _OutletRegistrationImage createState() => _OutletRegistrationImage();
}

class _OutletRegistrationImage extends State<OutletRegistrationImage> {
  int OrderID = 0;
  @override
  void initState() {
    super.initState();
    OrderID = 0;
  }
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  //String outletImagePath = "";

  List<String> outletImagePath = ["", "", "", ""];

  Repository repo = new Repository();

  Future SaveOutletImage() async {
    print('Image Start');
    print("newOutletId "+globals.newOutletId);
    print("newOutletLat "+globals.newOutletLat.toString());
    print("newOutletLng "+globals.newOutletLng.toString());
    print("newOutletAcc "+globals.newOutletAcc.toString());


    DateTime mobile_timeStamp = DateTime.now();
    String mobile_request_id = globals.UserID.toString().substring(2) + DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
bool imgFlag = false;
    for(int i=0; i<4; i++){
      if (outletImagePath.elementAt(i) != "") {
        imgFlag=true;
      }
    }

    if(imgFlag) {

      /* Upload Data */
      Dialogs.showLoadingDialog(context, _keyLoader);
      int error = await _OutletRegisterationUpload(context);
      if(error==0){
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home()),
      );

      /* Upload Images */
      for (int i = 0; i < 4; i++) {
        if (outletImagePath.elementAt(i) != "") {
          List imageDetailList1 = new List();

          imageDetailList1.add({
            "unique_id": globals.newOutletId + i.toString(),
            "mobile_request_id": globals.NewOutletId,
            "documentfile": outletImagePath.elementAt(i),
            "lat": globals.newOutletLat,
            "lng": globals.newOutletLng,
            "accuracy": globals.newOutletAcc,
            "mobile_timeStamp": mobile_timeStamp.toString()
          });
          //Save Locally
          await repo.saveRegisterOutletImages(imageDetailList1);

          //Get All Locally
          await repo.getRegisterOutletImages().then((val) async {
            for (int i = 0; i < val.length; i++) {
              String unique_id = val[i]['id'];
              String mobile_request_id =globals.NewOutletId.toString();
              File photoFile = File(val[i]['file']);
              String imageLat = val[i]['lat'];
              String imageLng = val[i]['lng'];
              String imageAccuracy = val[i]['accuracy'];
              String mobile_timeStamp = val[i]['mobile_timeStamp'];

            //  print(mobile_request_id + " - " + mobile_request_id);

              try {
                var stream = new http.ByteStream(
                    DelegatingStream.typed(photoFile.openRead()));
                var length = await photoFile.length();

                var url = Uri.http(globals.ServerURL,
                    '/portal/mobile/MobileUploadNewOutletImage_V2');


                print('URL ' + url.toString());
                String fileName = photoFile.path
                    .split('/')
                    .last;
                var request = new http.MultipartRequest("POST", url);
                request.fields['value1'] =
                    mobile_request_id; //OutletID.toString();
                request.fields['value2'] =
                    globals.UserID.toString(); //UserId.toString();
                request.fields['value3'] = imageLat;
                request.fields['value4'] = imageLng;
                request.fields['value5'] = imageAccuracy;
                request.fields['value6'] = mobile_timeStamp;

                var multipartFile = new http.MultipartFile(
                    'file', stream, length,
                    filename: "Outlet_" + fileName);

                request.files.add(multipartFile);
                var response = await request.send();
                print(response.statusCode);
                if (response.statusCode == 200) {
                  print("markMerchandisingPhotoUploaded SUCCESS");
                  await repo.deleteRegisterOutletImage(unique_id);
                } else {
                  // If that response was not OK, throw an error.

                  //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
                }
              } catch (e) {

              }
            }
          });
        }
      }
    }// success
    }else {
        Flushbar(
          messageText: Column(
            children: <Widget>[
              Text(
                "Please provide at least 1 outlet image",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundGradient:
          LinearGradient(colors: [Colors.black, Colors.black]),
          icon: Icon(
            Icons.notifications_active,
            size: 30.0,
            color: Colors.green[800],
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.green[800],
        )
          ..show(context);
    }

    /*for(int i=0; i<4; i++){

      if (outletImagePath.elementAt(i) != "") {
        Dialogs.showLoadingDialog(context, _keyLoader);
        List imageDetailList1 = new List();

        imageDetailList1.add({
          "unique_id" : globals.newOutletId + i.toString(),
          "mobile_request_id": globals.newOutletId,
          "documentfile": outletImagePath.elementAt(i),
          "lat": globals.newOutletLat,
          "lng": globals.newOutletLng,
          "accuracy": globals.newOutletAcc,
          "mobile_timeStamp": mobile_timeStamp.toString()
        });
        //Save Locally
        await repo.saveRegisterOutletImages(imageDetailList1);

        //Get All Locally
        await repo.getRegisterOutletImages().then((val) async {
          for (int i = 0; i < val.length; i++) {
            String unique_id = val[i]['id'];
            String mobile_request_id = val[i]['outlet_request_id'];
            File photoFile = File(val[i]['file']);
            String imageLat = val[i]['lat'];
            String imageLng = val[i]['lng'];
            String imageAccuracy = val[i]['accuracy'];
            String mobile_timeStamp = val[i]['mobile_timeStamp'];

            print(mobile_request_id + " - " + mobile_request_id);

            try {
              var stream = new http.ByteStream( DelegatingStream.typed(photoFile.openRead()));
              var length = await photoFile.length();

              var url = Uri.http(globals.ServerURL, '/portal/mobile/MobileUploadNewOutletImage');


              print('URL ' + url.toString());
              String fileName = photoFile.path.split('/').last;
              var request = new http.MultipartRequest("POST", url);
              request.fields['value1'] = mobile_request_id; //OutletID.toString();
              request.fields['value2'] =
                  globals.UserID.toString(); //UserId.toString();
              request.fields['value3'] = imageLat;
              request.fields['value4'] = imageLng;
              request.fields['value5'] = imageAccuracy;
              request.fields['value6'] = mobile_timeStamp;

              var multipartFile = new http.MultipartFile('file', stream, length,
                  filename: "Outlet_" + fileName);

              request.files.add(multipartFile);
              var response = await request.send();
              print(response.statusCode);
              if (response.statusCode == 200) {
                print("markMerchandisingPhotoUploaded SUCCESS");
                await repo.deleteRegisterOutletImage(unique_id);

              } else {
                // If that response was not OK, throw an error.

                //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
              }


            }catch(e){

            }

          }
        });
        _OutletRegisterationUpload(context);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home()),
        );
      }

    }*/
  }

  Future<int> _OutletRegisterationUpload(context) async {
    int error=1;
    await repo.getAllRegisteredOutletsByIsUploaded(0).then((val) async {
      for (int i = 0; i < val.length; i++) {
        String outletRegisterationsParams =
            "timestamp=" + globals.getCurrentTimestamp() +
                "&outlet_name=" + val[i]['outlet_name'] +
                "&mobile_transaction_no=" + (val[i]['mobile_request_id']).toString() +
                "&mobile_timestamp=" + val[i]['mobile_timestamp'] +
                "&channel_id=" + val[i]['channel_id'].toString() +
                "&area_label=" + val[i]['area_label'].toString() +
                "&sub_area_label=" + val[i]['sub_area_label'].toString() +
                "&address=" + val[i]['address'] +
                "&owner_name=" + val[i]['owner_name'] +
                "&owner_cnic=" + val[i]['owner_cnic'] +
                "&owner_mobile_no=" + val[i]['owner_mobile_no'] +
                "&purchaser_name=" + val[i]['purchaser_name'] +
                "&purchaser_mobile_no=" + val[i]['purchaser_mobile_no'] +
                "&is_owner_purchaser=" + val[i]['is_owner_purchaser'].toString() +
                "&lat=" + val[i]['lat'].toString() +
                "&lng=" + val[i]['lng'].toString() +
                "&accuracy=" + (val[i]['accuracy']).toStringAsFixed(3).toString() +
                "&created_on=" + val[i]['created_on'] +
                "&created_by=" + val[i]['created_by'].toString() +
                "&uuid=" + globals.DeviceID +
                "&platform=android" +
                "&distributor_id=" + globals.distributor_id.toString() +
                "&pjp_id="+globals.pjpid.toString();

        print("outletRegisterationsParams:" + outletRegisterationsParams);


        var QueryParameters = <String, String>{
          "SessionID": globals.EncryptSessionID(outletRegisterationsParams),
        };

        var url = Uri.http( globals.ServerURL, '/portal/mobile/MobileSyncOutletRegistration_V2');
        try {
          print('URL ' + url.toString());
          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader:
                'application/x-www-form-urlencoded'
              },
              body: QueryParameters);

          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          if (response.statusCode == 200) {
            if(responseBody["success"] == "true") {
              List pre_sell_outlets_rows = responseBody['BeatPlanRows'];

              for (var i = 0; i < pre_sell_outlets_rows.length; i++) {
                pre_sell_outlets_rows[i]['visit_type'] =
                await repo.getVisitType(pre_sell_outlets_rows[i]['OutletID']);

                //alternate week day logic starts

                int isVisible = 0;
                if (globals
                    .isOutletAllowed(pre_sell_outlets_rows[i]['IsAlternative'])) {
                  isVisible = 1;
                }
                pre_sell_outlets_rows[i]['is_alternate_visible'] = isVisible;

                //alternate week day logic ends
                print("BeatPlanRows :"+responseBody["BeatPlanRows"].toString());
                await repo.insertPreSellOutlet(
                    PreSellOutlets.fromJson(pre_sell_outlets_rows[i]));
              }
              print("15");


              print("16");
              List promotions_active = responseBody['promotions_active'];

              for (var i = 0; i < promotions_active.length; i++) {
                repo.insertPromotionsActive(
                    promotions_active[i]['PromotionID'],
                    promotions_active[i]['OutletID']);
              }
              globals.NewOutletId=responseBody["outlet_id"];
              print("New Outlet"+globals.NewOutletId.toString());
              print("Saved");
              error=0;
              repo.markOutletUploaded(val[i]['mobile_request_id'].toString());
              //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            }else if(responseBody["success"] == "false") {
              print("Error");
              repo.markOutletUploaded(val[i]['mobile_request_id'].toString());
              _showDialog("Error", responseBody["msg"], 0);
            }

          } else {
            //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            //_showDialog("Error", "An error has occured: " + responseBody.statusCode, 0);
            print("Error: An error has occured: " + responseBody.statusCode);
          }
        } catch (e) {
          // Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          //_showDialog("Error", "An error has occured " + e.toString(), 1);
          print("Error: An error has occured: " + e.toString());
        }
      }
    });// end of getAllRegisteredOutletsByIsUploaded
return error;
  }

  void _showDialog(String Title, String Message, int isSuccess) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        print('Title '+Title);
        print('Message '+Message);
        print('isSuccess '+isSuccess.toString());
        return AlertDialog(
          title: new Text(Title),
          content: new Text(Message ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Close"),
              onPressed: () {

                if (isSuccess == 1) {
                  // Navigator.push(
                  //   context,
                  //   //
                  //
                  //   MaterialPageRoute(builder: (context) => Attendance()
                  //     //  MaterialPageRoute(builder: (context) =>ShopAction_test()
                  //
                  //   ),
                  // );
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




  openCamera(int count) async {
    print("add for "+count.toString());
    final _picker = ImagePicker();

    final imageFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.rear);
    setState(() {
      if (imageFile != null)if (imageFile != null) outletImagePath.insert(count, imageFile.path);
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () async {

                      SaveOutletImage();



                    },
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Save',
                          style: TextStyle(fontSize: 20, color: Colors.green)),
                    ),
                  )
                ]),
          ),
          appBar: AppBar(
              backgroundColor: Colors.green[800],
              actions: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                )
              ],
              title: Text(
                "Outlet Images",
                style: TextStyle(fontSize: 16),
              ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          body: new Container(
            //padding: EdgeInsets.all(16.0),
              child: new ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                        "Please use the camera  icon to take image"),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      outletImagePath.elementAt(0) != ""
                                          ? Container(
                                          margin: const EdgeInsets.all(15.0),
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          width: 100,
                                          height: 100,
                                          child:
                                          Image.file(File(outletImagePath[0])))
                                          : Container(
                                        margin: const EdgeInsets.all(15.0),
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        width: 100,
                                        height: 100,
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          openCamera(0);
                                        },
                                        icon: Icon(Icons.camera_alt,
                                            color: Color(0xFFC9002B)),
                                        label: Text("Camera",
                                            style: TextStyle(
                                                color: Color(0xFFC9002B))),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // btnOkIcon: Icons.photo_library,
                            // btnCancelIcon: Icons.camera_alt,
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      outletImagePath.elementAt(1) != ""
                                          ? Container(
                                          margin: const EdgeInsets.all(15.0),
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          width: 100,
                                          height: 100,
                                          child:
                                          Image.file(File(outletImagePath[1])))
                                          : Container(
                                        margin: const EdgeInsets.all(15.0),
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        width: 100,
                                        height: 100,
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          openCamera(1);
                                        },
                                        icon: Icon(Icons.camera_alt,
                                            color: Color(0xFFC9002B)),
                                        label: Text("Camera",
                                            style: TextStyle(
                                                color: Color(0xFFC9002B))),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // btnOkIcon: Icons.photo_library,
                            // btnCancelIcon: Icons.camera_alt,
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      outletImagePath.elementAt(2) != ""
                                          ? Container(
                                          margin: const EdgeInsets.all(15.0),
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          width: 100,
                                          height: 100,
                                          child:
                                          Image.file(File(outletImagePath[2])))
                                          : Container(
                                        margin: const EdgeInsets.all(15.0),
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        width: 100,
                                        height: 100,
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          openCamera(1);
                                        },
                                        icon: Icon(Icons.camera_alt,
                                            color: Color(0xFFC9002B)),
                                        label: Text("Camera",
                                            style: TextStyle(
                                                color: Color(0xFFC9002B))),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // btnOkIcon: Icons.photo_library,
                            // btnCancelIcon: Icons.camera_alt,
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      outletImagePath.elementAt(3) != ""
                                          ? Container(
                                          margin: const EdgeInsets.all(15.0),
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          width: 100,
                                          height: 100,
                                          child:
                                          Image.file(File(outletImagePath[3])))
                                          : Container(
                                        margin: const EdgeInsets.all(15.0),
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        width: 100,
                                        height: 100,
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          openCamera(1);
                                        },
                                        icon: Icon(Icons.camera_alt,
                                            color: Color(0xFFC9002B)),
                                        label: Text("Camera",
                                            style: TextStyle(
                                                color: Color(0xFFC9002B))),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // btnOkIcon: Icons.photo_library,
                            // btnCancelIcon: Icons.camera_alt,
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              )),
        ));


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

