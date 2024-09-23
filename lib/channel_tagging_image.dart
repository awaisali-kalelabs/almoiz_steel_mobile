import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:another_flushbar/flushbar.dart';import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:order_booker/shopAction.dart';


import 'com/pbc/dao/repository.dart';
import 'globals.dart' as globals;

class ChannelTaggingImage extends StatefulWidget {
  int outletId;
  ChannelTaggingImage({this.outletId});
  @override
  _ChannelTaggingImage createState() => _ChannelTaggingImage();
}

class _ChannelTaggingImage extends State<ChannelTaggingImage> {
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

  Future SaveChannelTagging() async {
    int id = globals.channelTagId;
    String outletId = globals.OutletID.toString();
    String outletName = globals.OutletName;
    double lat = globals.channellat;
    double lng = globals.channellng;
    double acc = globals.channelacc;
    String userId = globals.UserID.toString();
    String mobile_request_id = userId.substring(2) + DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    // print(" =================> " + mobile_request_id + ' - ' + outletId + ' - ' + outletName + ' - ' +
    //     lat.toString() + ' - ' + outletName + ' - ' + lng.toString() + ' - ' +
    //     acc.toString() + ' - ' + userId);
    await repo.addChannel(
        mobile_request_id,
        outletId,
        outletName,
        id.toString(),
        lat,
        lng,
        acc,
        userId);

    await repo.getAddedChnnelTgging().then((val) async {
      for (int i = 0; i < val.length; i++) {
        String MUID = val[i]['mobile_request_id'];
        DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
        String currDateTime = dateFormat.format(DateTime.now());
        var str = currDateTime.split(".");

        // String TimeStamp = str[0];
        String orderParam = "timestamp=" +
            str[0] +
            "&OutletID=" +
            val[i]['outlet_id'] +
            "&OutletName=" +
            val[i]['outlet_name'] +
            "&OutletLat=" +
            val[i]['lat'] +
            "&OutletLong=" +
            val[i]['lng'] +
            "&OutletAccu=" +
            val[i]['accuracy'] +
            "&Channel=" +
            val[i]['channel_id'] +
            "&UserID=" +
            val[i]['user_id'];

        var QueryParameters = <String, String>{
          "SessionID": globals.EncryptSessionID(orderParam),
        };
        //  print(QueryParameters);
        try {
          //  print('inner catch');
          //alfalah_portal
          // globals.ServerURL = "192.168.201.162:8080";
          var url = Uri.https(globals.ServerURL,
              '/portal/mobile/MobileMDEOutletInformationUpdateExecute');
          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader:
                'application/x-www-form-urlencoded'
              },
              body: QueryParameters
          );

          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          //  print('response.statusCode '+response.statusCode.toString());
          if (response.statusCode == 200) {
            if (responseBody["success"] == "true") {
              print ("success");
              await repo.deleteChannel(MUID);



            }
          }
        } catch (e) {
          //  print(e);
          //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          // _showDialog("Error", "An error has occured " + e.toString(), 1);
        }


        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => ShopAction()));

      }
    });
  }

  Future SaveOutletImage() async {

    print('image');
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

    if(imgFlag){
      Dialogs.showLoadingDialog(context, _keyLoader);
     await SaveChannelTagging();
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShopAction()),
      );

      /* Upload Images */
      for(int i=0; i<4; i++) {
        if (outletImagePath.elementAt(i) != "") {
          List imageDetailList1 = new List();

          imageDetailList1.add({
            "mobile_request_id": mobile_request_id,
            "outletId": globals.OutletID.toString(),
            "documentfile": outletImagePath.elementAt(i),
            "lat": globals.channellat.toString(),
            "lng": globals.channellng.toString(),
            "accuracy": globals.channelacc.toString(),
            "mobile_timeStamp": mobile_timeStamp.toString()
          });

          //   bool result1 = await repo.saveOutletOrderImage(imageDetailList);
          await repo.saveChannelTaggingImage(imageDetailList1);

          await repo.getAddedChnnelTggingImages().then((val) async {
            //   print(val);
            for (int i = 0; i < val.length; i++) {
              String MUID = val[i]['mobile_request_id'];
              String outletId = val[i]['id'];
              String fileTypeId = val[i]['file_type_id'];
              File photoFile = File(val[i]['file']);
              String imageLat = val[i]['lat'];
              String imageLng = val[i]['lng'];
              String imageAccuracy = val[i]['accuracy'];
              String mobile_timeStamp = val[i]['mobile_timeStamp'];

              print(MUID + " - " + outletId);
              try {
                var stream = new http.ByteStream( DelegatingStream.typed(photoFile.openRead()));
                var length = await photoFile.length();
                //  globals.ServerURL = "192.168.201.162:8080";
                //alfalah_portal
                var url = Uri.https(globals.ServerURL, '/portal/mobile/MobileUploadOutletImage');
                print('URL ' + url.toString());
                String fileName = photoFile.path
                    .split('/')
                    .last;

                var request = new http.MultipartRequest("POST", url);
                print("request.fields['value1'] =");
                request.fields['value1'] = outletId; //OutletID.toString();
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

                //   print("response.toString()");
                //  print(response.toString());

                if (response.statusCode == 200) {
                  print("markMerchandisingPhotoUploaded SUCCESS");
                  await repo.deleteChannelImage(MUID);
                } else {
                  print('error');
                  // If that response was not OK, throw an error.

                  //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
                }
              } catch (e) {
                print('error');

                //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                // _showDialog("Error", "An error has occured " + e.toString(), 1);
              }
            }
          });

        }
      }// end of loop

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
          color: Colors.red[800],
        ),
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: Colors.red[800],
      )
        ..show(context);
    }

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
                          style: TextStyle(fontSize: 20, color: Colors.red)),
                    ),
                  )
                ]),
          ),
          appBar: AppBar(
              backgroundColor: Colors.red[800],
              actions: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                )
              ],
              title: Text(
                "Channel Tagging Image",
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

