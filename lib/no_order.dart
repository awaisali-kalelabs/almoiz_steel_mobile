import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:order_booker/com/pbc/dao/repository.dart';
import 'package:order_booker/order_cart_view.dart';
import 'package:order_booker/shopAction.dart';
import 'package:intl/intl.dart';

import 'globals.dart' as globals;
import 'globals.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(NoOrder(globals.OutletID));
}

// This app is a stateful, it tracks the user's current choice.
class NoOrder extends StatefulWidget {
  int OutletId;

  NoOrder(OutletId) {
    this.OutletId = OutletId;

    print(OutletId);
  }
  @override
  _NoOrder createState() => _NoOrder(OutletId);
}

class _NoOrder extends State<NoOrder> {
  int OutletId;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String selected;
  int weekday;
  int noOrderReason;
  bool isLocationTimedOut = false;
  List<Map<String, dynamic>> AllNoOrders;
  List<Map<String, dynamic>> AllOrders;
  List<Map<String, dynamic>> AllOrdersItems;
  String _SelectFerightTerms;
  _NoOrder(OutletId) {
    this.OutletId = OutletId;
  }
  Repository repo = new Repository();
  List Days = new List();

  List<bool> isSelected = [false, false, false, false, false, false, false];

  List<Map<String, dynamic>> NoOrderReasons;
  Timer timer;
  double Newdistance = 0.0;
  double lat1 = globals.Lat; // Latitude of the first location
  double lon1 = globals.Lng; // Longitude of the first location

  double lat2 = double.tryParse(globals.IsGeoFenceLat); // Latitude of the second location
  double lon2 = double.tryParse(globals.IsGeoFenceLng);
  @override
  void initState() {
    //NoOrderReasons=new List();
    noOrderReason = 0;

    Repository repo = new Repository();
    //weeK DAY to be Placed
    weekday = globals.WeekDay;

    NoOrderReasons = new List();

    repo.getNoOrderReasons().then((val) {
      setState(() {
        NoOrderReasons = val;
      });
    });

    if (weekday > 0) {
      isSelected[weekday - 1] = true;
    } else {
      isSelected[0] = true;
    }
    timer= Timer.periodic(Duration(seconds: 2), (Timer timer) {
      // Update the coordinates here (for demonstration purposes, we're just changing them randomly)
      lat2 = Random().nextDouble() * 90; // Random latitude between -90 and 90
      lon2 = Random().nextDouble() * 180; // Random longitude between -180 and 180

      //Newdistance = calculateDistance(lat1, lon1, lat2, lon2);
      setState(() {
        Newdistance = _calculateDistance();
      });
     // print('Updated Distance: $Newdistance meters');
    });

    _getLocation();
  }
  double _latitude = 0.0;
  double _longitude = 0.0;
  double _calculateDistance() {
    double latDouble = double.tryParse(globals.IsGeoFenceLat);
    double lngDouble = double.tryParse(globals.IsGeoFenceLng);

    double distanceInMeters = Geolocator.distanceBetween(
      _latitude,
      _longitude,
      latDouble,
      lngDouble,
    );

    // Convert the distance to other units if needed
    // For example, to kilometers: distanceInKm = distanceInMeters / 1000;

    return distanceInMeters;
  }
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      print("Error: $e");
    }
  }
  bool visibility = false;

/*  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(globals.Lat, globals.Lng),
    zoom: 14.4746,
  );*/
  setNoOrderReason(int val) {
    setState(() {
      noOrderReason = val;
    });
  }

  saveNoOrder() {
    Dialogs.showLoadingDialog(context, _keyLoader);
    Position position=globals.currentPosition;
    if(position==null){
      globals.getCurrentLocation(context).then((position1) {
        position = position1;
      })
          .timeout(Duration(seconds: 7), onTimeout: ((){
        print("i am here timedout");

        setState(() {
          isLocationTimedOut = true;
        });

      }))

          .whenComplete(() {

        double lat = 0.0;
        double lng = 0.0;
        double accuracy = 0.0;
        print(position);
        if (position != null || isLocationTimedOut) {
          if(isLocationTimedOut==false){
            lat = position.latitude;
            lng = position.longitude;
            accuracy = position.accuracy;
          }

          print(position);
          repo.saveNoOrder(
              globals.getUniqueMobileId(),
              globals.OutletID,
              noOrderReason,
              lat,
              lng,
              accuracy,
              globals.DeviceID);
          Navigator.of(context, rootNavigator: true).pop('dialog');
          _UploadNoOrder();
          repo.setVisitType(globals.OutletID, 2).then((value) {
            Navigator.push(
              context,
              //

              MaterialPageRoute(builder: (context) => ShopAction()
                //  MaterialPageRoute(builder: (context) =>ShopAction_test()

              ),
            );
          });
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
    }else{
      repo.saveNoOrder(
          globals.getUniqueMobileId(),
          globals.OutletID,
          noOrderReason,
          position.latitude,
          position.longitude,
          position.accuracy,
          globals.DeviceID);
      Navigator.of(context, rootNavigator: true).pop('dialog');
      _UploadNoOrder();
      repo.setVisitType(globals.OutletID, 2).then((value) {
        Navigator.push(
          context,
          //

          MaterialPageRoute(builder: (context) => ShopAction()
            //  MaterialPageRoute(builder: (context) =>ShopAction_test()

          ),
        );
      });
    }

  }



  Future _UploadNoOrder() async {
    String TimeStamp = globals.getCurrentTimestamp();
    print("currDateTime" + TimeStamp);
    int ORDERIDToDelete = 0;
    AllNoOrders = new List();
    await repo.getAllNoOrders(0).then((val) async {
      setState(() {
        AllNoOrders = val;

        print("MAIN ORDER" + AllNoOrders.toString());
      });

      for (int i = 0; i < AllNoOrders.length; i++) {
        String orderParam = "timestamp=" +
            TimeStamp +
            "&NoOrderID=" +
            AllNoOrders[i]['id'].toString() +
            "&version=" +
            appVersion +
            "&OutletID=" +
            AllNoOrders[i]['outlet_id'].toString() +
            "&ReasonID=" +
            AllNoOrders[i]['reason_type_id'].toString() +
            "&MobileTimestamp=" +
            AllNoOrders[i]['created_on'].toString() +
            "&UserID=" +
            globals.UserID.toString() +
            "&uuid=" +
            globals.DeviceID +
            "&platform=android&Lat=" +
            AllNoOrders[i]['lat'] +
            "&Lng=" +
            AllNoOrders[i]['lng'] +
            "&accuracy=" +
            AllNoOrders[i]['accuracy'] +
            "&platform=android&Lat=" +
            AllNoOrders[i]['lat'] +
            "&Lng=" +
            AllNoOrders[i]['lng'] +
            "&accuracy=" +
            AllNoOrders[i]['accuracy'] +
            //
            "&distributor_id=" +
          globals.distributor_id.toString() +
            "&tso_id=" +
            globals.tso_id.toString() +
            "&asm_id=" +
            globals.asm_id.toString() +
            "&rsm_id=" +
            globals.rsm_id.toString() +
            "&region_id=" +
            globals.region_id.toString() +
            "&city_id=" +
            globals.city_id.toString() +
            "&pjpid=" +
            globals.pjpid.toString() +
            "&device_id=" +
            globals.DeviceID.toString() +
            "";
        ORDERIDToDelete = AllNoOrders[i]['id'];
        var QueryParameters = <String, String>{
          "SessionID": globals.EncryptSessionID(orderParam),
        };
        var url =
            Uri.https(globals.ServerURL, '/portal/mobile/MobileSyncNoOrdersV4');
        print(url);
        print("orderParam :"+orderParam);
        try {
          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/x-www-form-urlencoded'
              },
              body: QueryParameters);

          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          print('called4');
          if (response.statusCode == 200) {
            if (responseBody["success"] == "true") {
              await repo.markNoOrderUploaded(ORDERIDToDelete);
            } else {
              _showDialog("Error", responseBody["error_code"], 0);
            }
          } else {
            // If that response was not OK, throw an error.

            //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
          }
        } catch (e) {
          //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          //_showDialog("Error", "An error has occured " + e.toString(), 1);
        }
        //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);

      }
    });
  }

  void ShowError(context) {
    Flushbar(
      messageText: Column(
        children: <Widget>[
          Text(
            "Please select the reason to proceed.",
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
    if (globals.isLocalLoggedIn == 1) {
      return;
    }
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


  void dispose() {
//    timer.cancel();
    super.dispose();
  }
  Widget _getNoOrderReasonsList(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        index == 0 ? Container() : Divider(),
        Container(
          child: RadioListTile(
            value: NoOrderReasons[index]['id'],
            groupValue: noOrderReason,
            title: Text("" + NoOrderReasons[index]['label'],
                style: new TextStyle(fontSize: 16, color: Colors.black54)),
            //subtitle: Text("Radio 1 Subtitle"),
            onChanged: (val) {
              print("Radio Tile pressed $val");
              setNoOrderReason(val);
            },
            activeColor: Colors.orange[200],

            selected: true,
          ),
        )
      ],
    );
  }

  double cardWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    cardWidth = width / 1.1;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.green[800],
              title: Text(
                globals.OutletID.toString() + " - " + globals.OutletName,
                style: new TextStyle(color: Colors.white, fontSize: 14),
              ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShopAction()),
                        ModalRoute.withName("/ShopAction"));
                  }),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey, // Background color
                  ),
                  child: Text('Save',
                      style: TextStyle(
                        color: noOrderReason == 0 ? Colors.grey : Colors.white,
                      )),
                  onPressed: () async {
                    /* _UploadOrder();*/
                    //  _showIndicator();
                    noOrderReason == 0 ? ShowError(context) : saveNoOrder();

                  /*  List OutletData = await repo.SelectOutletByID(globals.OutletID);
                    globals.IsGeoFence = OutletData[0]["IsGeoFence"];
                    globals.IsGeoFenceLat = OutletData[0]["lat"];
                    globals.IsGeoFenceLng = OutletData[0]["lng"];
                    globals.Radius = OutletData[0]["Radius"];
                    print("_latitude===>" + _latitude.toString());
                    print("IsGeoFenceLat" + globals.IsGeoFenceLat.toString());
                    print("IsGeoFvenceLng" + globals.IsGeoFenceLng.toString());
                    print("Radius====================" + globals.Radius.toString());

                    int Distance2 = globals.Radius;
                    print("Distance 2" + Distance2.toString());
                    double distance = _calculateDistance();
                    print("distance" + distance.toString());

                    if (globals.IsGeoFence == 0 ) {
                      noOrderReason == 0 ? ShowError(context) : saveNoOrder();
                    } else {
                      if (distance <= Distance2) {
                        noOrderReason == 0 ? ShowError(context) : saveNoOrder();
                      } else {
                        repo.deletePastOrders(globals.OutletID);
repo.deleteNoOrder();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Error"),
                              content: new Text(
                                  'Can\'t place order, you are ${distance.toInt()} meters away from the shop.'),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new ElevatedButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      MaterialPageRoute(builder: (context) => OrderCartView()),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }*/
                  },
                ),
              ]),
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
                         /* Container(
                           // height: 200,
                            child :Text(
                              'You are ${Newdistance.toStringAsFixed(1)} m away from the Outlet',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),*/
                        /*  Container(
                            height: 200,
                            child : GoogleMap(
                              initialCameraPosition: _kGooglePlex,
                              markers: {
                                Marker(
                                  markerId: MarkerId('Sydney'),
                                  position: LatLng(globals.Lat, globals.Lng),
                                )
                              },
                              // markers: markers.values.toSet(),
                            ),
                          ),

                          Container(
                            child: Text(
                              "Please select the reason for not placing an order",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                            alignment: Alignment.topLeft,
                          ),*/
                          Container(
                            //  width: cardWidth,

                            child: Container(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                    child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: NoOrderReasons.length,
                                  itemBuilder: _getNoOrderReasonsList,
                                )),
                              ],
                            )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ])),
    );
  }
}
