/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:another_flushbar/flushbar.dart';import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:order_booker/com/pbc/dao/repository.dart';
import 'package:http/http.dart' as http;

import 'package:order_booker/merchandising.dart';
import 'package:order_booker/no_order.dart';
import 'package:order_booker/outlet_location.dart';
import 'package:order_booker/pre_sell_route.dart';
import 'package:order_booker/OutletOrderImage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'channel_tagging.dart';
import 'globals.dart' as globals;
import 'globals.dart';

// This app is a stateful, it tracks the user's current choice.
class ShopAction extends StatefulWidget {
  ShopAction() {}

  @override
  _ShopAction createState() => _ShopAction();
}

class _ShopAction extends State<ShopAction> {
  _ShopAction() {}

  Repository repo = new Repository();
  List OutletOrder = new List();
  int IsOrderPlaced = 0;
  List<Map<String, dynamic>> AllOrders;
  double _latitude = 0.0;
  double _longitude = 0.0;
  double Accuracy = 0.0;
  bool isLoading = false;
  Timer timer;
  double Newdistance = 0.0;
  double lat1 = globals.Lat; // Latitude of the first location
  double lon1 = globals.Lng;
  double lat2 = globals.Lat; // Latitude of the second location
  double lon2 = globals.Lng;
  @override
  void initState() {
    print("init state");


    _getLocation1(); // Call this function to get initial location
    startTimer(); // Start the timer for periodic updates

    globals.startContinuousLocation1(context);

    repo.isVisitExists(globals.OutletID).then((value) => {
      if(mounted)
        setState(() {
          IsOrderPlaced = value;
        })
    });
    _getLocation1();

  }
  double _latitude1 = 0.0;
  double _longitude1 = 0.0;
  Future<void> _getLocation1() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude1 = position.latitude;
        _longitude1 = position.longitude;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }
  void startTimer() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      lat2 = Random().nextDouble() * 90; // Random latitude between -90 and 90
      lon2 = Random().nextDouble() * 180; // Random longitude between -180 and 180
      setState(() {
        Newdistance = _calculateDistance();
      });
    });
  }

  double _calculateDistance() {
    double latDouble = lat2; // Use the updated lat2 and lon2 values
    double lngDouble = lon2;

    double distanceInMeters = Geolocator.distanceBetween(
      _latitude1,
      _longitude1,
      latDouble,
      lngDouble,
    );

    // Convert the distance to other units if needed
    // For example, to kilometers: distanceInKm = distanceInMeters / 1000;

    return distanceInMeters;
  }
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radius of the Earth in meters
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
  Future GetOutletOrder() async {
    OutletOrder = await repo.getAllOrders(globals.OutletID, 1);
    setState(() {
      OutletOrder = OutletOrder;
      if (OutletOrder.isNotEmpty && OutletOrder[0]["is_completed"] == 1) {
        //IsOrderPlaced = 1;
      }
    });

    print(OutletOrder);
  }

  @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //
  //   super.dispose();
  // }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("not navigating"); // Do some stuff.
    //work here
    return true;
  }
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        Accuracy = position.accuracy;
      });
    } catch (e) {
      print("Error: $e");
    }
  }
  Future Save_Start_Time_Stamp() async {
    if (Start_Visit_Time != "" ) {
      List DataList = new List();
      int mobileRequestID = getUniqueMobileId();
      DataList.add({
        "id": mobileRequestID,
        "mobile_timestamp": Start_Visit_Time,
        "file_type": 1,
        "outlet_id": globals.OutletID,
        "lat": _latitude,
        "lng":_longitude,
        "accuracy":Accuracy,
      });

      // await repo.insertOutletOrderTimestamp(globals.orderId, 3);
      await repo.InsertVisitTime(DataList);
      */
/*   if (result1 == true) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Orders(outletId: widget.outletId)));
      }*//*

    }
  }
  Future Save_End_Time_Stamp() async {
    if (End_Visit_Time != "" ) {
      List DataList = new List();
      int mobileRequestID = getUniqueMobileId();
      DataList.add({
        "id": mobileRequestID,
        "mobile_timestamp": End_Visit_Time,
        "file_type": 2,
        "outlet_id": globals.OutletID,
        "lat":_latitude,
        "lng":_longitude,
        "accuracy":Accuracy,
      });

      await repo.InsertVisitTime(DataList);

    }
  }

  Future _EndVisit() async {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());
    var str = currDateTime.split(".");

    String TimeStamp = str[0];
    AllOrders = new List();
    await repo.getVisitTime().then((val) async {
      AllOrders = val;

      print(AllOrders.toString());

      for (int i = 0; i < AllOrders.length; i++) {
        String orderParam = "timestamp=" +
            TimeStamp +
            "&outlet_id=" +
            AllOrders[i]['outlet_id'].toString() +
            "&id=" +
            AllOrders[i]['id'].toString() +
            "&mobile_timestamp=" +
            AllOrders[i]['mobile_timestamp'].toString() +
            "&file_type=" +
            AllOrders[i]['file_type'].toString() +
            "&created_by=" +
            globals.UserID.toString() +
            "&uuid=" +
            globals.DeviceID +
            "&platform=android&lat="+
            AllOrders[i]['lat'] +
            "&lng=" +
            AllOrders[i]['lng'] +
            "&accuracy=" +
            AllOrders[i]['accuracy'] +
            "&version=" +
            appVersion;


        print("orderParam: " + orderParam.toString());
        print("orderParam==========================: " + orderParam);
        var QueryParameters = <String, String>{
          "SessionID": EncryptSessionID(orderParam),
        };
        print("QueryParameters ===================: " + QueryParameters.toString());
        var url =
        Uri.https(globals.ServerURL, '/portal/mobile/MobileSyncOutletVisitDuration');
        print(url);

        try {

          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader:
                'application/x-www-form-urlencoded'

              },
              body: QueryParameters);
          var responseBody = json.decode(utf8.decode(response.bodyBytes));
          print('called4');
          // if (response.statusCode == 200) {
          ///  final data = json.decode(response.body);
          //  print("Inside 200");
          if (responseBody["success"] == "true") {
            print("Inside True");
            await repo.MarkVisitUpdate(globals.OutletID);
            if(await repo.CheckVisit(globals.OutletID)){
              print("============================");
              repo.setVisitType(globals.OutletID , 4);
            }
            print("Success==");
          } else if (responseBody["success"] == "false") {
            print("In Geo ssssss");
            // _showDialog("Error", responseBody["error_code"], 0);
          } else {
            //  _showDialog("Error", responseBody["error_code"], 0);
          }
          */
/*   } else {
            //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
          }*//*

        } catch (e) {
          print(e);
        }
      }
    });
  }

  void ShowError(context, String message) {
    Flushbar(
      messageText: Column(
        children: <Widget>[
          Text(
            message,
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

  @override
  Widget build(BuildContext context) {
    String selected;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          //automaticallyImplyLeading: false,
          automaticallyImplyLeading: false,

          leading: showLeadingIcon ? IconButton( // Check the boolean flag before displaying the leading icon
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
              );
            },
          ) : null, // Set leading to null if showLeadingIcon is false
          title: Text(
            globals.OutletName,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    width: 180,
                                    // height: 235,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 0, 5.0),
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: Colors.green,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 5.0, 0, 5.0),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OutletLocation(
                                                                address: globals
                                                                    .OutletAddress,
                                                                name: globals
                                                                    .OutletName,
                                                                lat:
                                                                globals.Lat,
                                                                lng:
                                                                globals.Lng,
                                                                calledFrom: 2,
                                                              )),
                                                    );
                                                  },
                                                  child: Text(
                                                    globals.OutletAddress,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                            )
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 0, 5.0),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.green,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 5.0, 0, 5.0),
                                              child: Text(
                                                globals.OutletOwner,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 0, 5.0),
                                                child: Icon(
                                                  Icons.phone_android,
                                                  color: Colors.green,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 5.0, 0, 5.0),
                                              child: GestureDetector(
                                                  onTap: () async {
                                                    var url = "tel:" +
                                                        globals.OutletNumber;
                                                    if (await canLaunch(url)) {
                                                      await launch(url);
                                                    } else {
                                                      throw 'Could not launch $url';
                                                    }
                                                  },
                                                  child: Text(
                                                    globals.OutletNumber == null
                                                        ? ""
                                                        : globals.OutletNumber,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 80,
                                                alignment: Alignment.center,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        0.0),
                                                  ),
                                                  color: HexColor("#006400"),
                                                  elevation: 2,
                                                  child: Center(
                                                    child: Container(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            'General Store',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Channel',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                // width: cardWidth,
                                                height: 80,
                                                alignment: Alignment.center,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        0.0),
                                                  ),
                                                  color: HexColor("#006400"),
                                                  elevation: 2,
                                                  child: Center(
                                                    child: Container(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            '2',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Visit Frequency',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 80,
                                                alignment: Alignment.center,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        0.0),
                                                  ),
                                                  color: HexColor("#006400"),
                                                  elevation: 2,
                                                  child: Center(
                                                    child: Container(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            globals.order_created_on_date ?? 'Null',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Last Sale',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))),
                          ],
                        ),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            :
                        Visibility(
                          visible: showSecondSection, // Set visibility based on the boolean variable
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 12.0,
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OutletOrderImage(
                                                                    outletId: globals
                                                                        .OutletID)),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Image.asset(
                                                            "assets/images/mobile-shopping.png",
                                                            width: 55,
                                                          ),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.fromLTRB(
                                                                  0.0,
                                                                  5.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Text(
                                                                'Order',
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color:
                                                                    Colors.black),
                                                              )),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        IsOrderPlaced == 1
                                                            ? ShowError(context,
                                                            "Order Already Placed")
                                                            : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  NoOrder(
                                                                      22222)),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Image.asset(
                                                              "assets/images/no_order.png",
                                                              width: 55,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0.0,
                                                                    5.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: Text(
                                                                  'No Order',
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      color: IsOrderPlaced ==
                                                                          1
                                                                          ? Colors
                                                                          .grey
                                                                          : Colors
                                                                          .black),
                                                                )),
                                                          ],
                                                        ),
                                                      ))),
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Merchandising()),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Image.asset(
                                                              "assets/images/merchandising.png",
                                                              width: 55,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0.0,
                                                                    5.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: Text(
                                                                  'Merchandising',
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      color: Colors
                                                                          .black),
                                                                )),
                                                          ],
                                                        ),
                                                      ))),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        "assets/images/settings.png",
                                                        width: 55,
                                                      ),
                                                      Padding(
                                                          padding:
                                                          EdgeInsets.fromLTRB(
                                                              0.0, 5.0, 0.0, 0.0),
                                                          child: Text(
                                                            'Update Profile',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        globals.channellng = 0.0;
                                                        globals.channellat = 0.0;
                                                        globals.channelacc = 0.0;
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(

                                                              builder: (context) => ChannelTagging()),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Image.asset(
                                                              "assets/images/marked_closed.png",
                                                              width: 55,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    0.0,
                                                                    5.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: Text(
                                                                  'Channel Tagging',
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      color: IsOrderPlaced ==
                                                                          1
                                                                          ? Colors
                                                                          .grey
                                                                          : Colors
                                                                          .black),
                                                                )),
                                                          ],
                                                        ),
                                                      ))),
                                            ],
                                          ),
                                        ],
                                      ))),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),

                        Divider(height: 15,),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true; // Show the circular progress indicator
                                    });
                                    try{
                                      List OutletData = new List();
                                      OutletData = await repo.SelectOutletByID(globals.OutletID);
                                      globals.IsGeoFence = OutletData[0]["IsGeoFence"];
                                      globals.Radius =  OutletData[0]["Radius"];
                                      await _getLocation();
                                      double lat1 = globals.Lat; // Latitude of the first point
                                      double lon1 = globals.Lng; // Longitude of the first point
                                      double lat2 = _latitude; // Latitude of the second point
                                      double lon2 = _longitude; // Longitude of the second point

                                      double distance = calculateDistance(lat1, lon1, lat2, lon2);
                                      //  print("lat1===>" + globals.Lat.toString());
                                      // print("lon1===>" + globals.Lng.toString());
                                      // print("lat2===>" + _latitude.toString());
                                      // print("lon2===>" + _longitude.toString());

                                      //    print("distance===>" + distance.toString());
                                      setState(() {
                                        globals.Start_Visit_Time = DateTime.now().toString();
                                      });
                                      //  print("globals.Radius"+Radius.toString());
                                      //   print("Start_Visit_Time====>" + Start_Visit_Time);
                                      //  print("globals.IsGeoFence"+IsGeoFence.toString());
                                      // 700 <= 300
                                      //   print("distance====>"+distance.toString());
                                      if (distance <= Radius && IsGeoFence == 1) {
                                        Save_Start_Time_Stamp();
                                        setState(() {
                                          showSecondSection = true;
                                          showLeadingIcon = false;
                                        });
                                      }else if(globals.IsGeoFence == 0){
                                        //    print("IsGeoFence"+IsGeoFence.toString());
                                        Save_Start_Time_Stamp();
                                        setState(() {
                                          showSecondSection = true;
                                          showLeadingIcon = false;
                                        });
                                      }else{
                                        Flushbar(
                                          messageText: Column(
                                            children: <Widget>[
                                              Text(
                                                "Please be within the location",
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
                                    }catch (e) {
                                      print('Error fetching data: $e');
                                      // Handle any errors that occur during data fetching
                                    } finally {
                                      setState(() {
                                        isLoading = false; // Hide the circular progress indicator
                                      });
                                    }
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    color: Colors.green,
                                    elevation: 2,
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Start Visit',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // width: cardWidth,
                                height: 60,
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true; // Show the circular progress indicator
                                    });
                                    try{
                                      List OutletData = new List();
                                      OutletData = await repo.SelectOutletByID(globals.OutletID);
                                      globals.IsGeoFence = OutletData[0]["IsGeoFence"];
                                      globals.Radius =  OutletData[0]["Radius"];
                                      await _getLocation();
                                      double lat1 = globals.Lat; // Latitude of the first point
                                      double lon1 = globals.Lng; // Longitude of the first point
                                      double lat2 = _latitude; // Latitude of the second point
                                      double lon2 = _longitude; // Longitude of the second point

                                      double distance = calculateDistance(lat1, lon1, lat2, lon2);
                                      //   print("lat1===>" + globals.Lat.toString());
                                      //  print("lon1===>" + globals.Lng.toString());
                                      //   print("lat2===>" + _latitude.toString());
                                      //  print("lon2===>" + _longitude.toString());

                                      //  print("distance===>" + distance.toString());
                                      setState(() {
                                        globals.End_Visit_Time = DateTime.now().toString();
                                      });
                                      // print("globals.Radius"+Radius.toString());
                                      //  print("End_Visit_Time====>" + End_Visit_Time);
                                      //   print("globals.IsGeoFence"+IsGeoFence.toString());
                                      // 700 <= 300
                                      //  print("distance====>"+distance.toString());
                                      if (distance <= Radius && IsGeoFence == 1) {
                                        Save_End_Time_Stamp();
                                        await _EndVisit();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
                                        );
                                      }else if(globals.IsGeoFence == 0){
                                        //  print("IsGeoFence"+IsGeoFence.toString());
                                        Save_End_Time_Stamp();
                                        await _EndVisit();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
                                        );
                                      }  else{
                                        Flushbar(
                                          messageText: Column(
                                            children: <Widget>[
                                              Text(
                                                "Please be within the location",
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
                                    }catch (e) {
                                      print('Error fetching data: $e');
                                      // Handle any errors that occur during data fetching
                                    } finally {
                                      setState(() {
                                        isLoading = false; // Hide the circular progress indicator
                                      });
                                    }
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          0.0),
                                    ),
                                    color: Colors.red,
                                    elevation: 2,
                                    child: Center(
                                      child: Container(
                                        alignment:
                                        Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              'End Visit',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  color: Colors
                                                      .white),
                                              textAlign: TextAlign
                                                  .center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(height: 10,),
                        Container(
                          height: 200,
                          child :Text(
                            'You are ${Newdistance.toStringAsFixed(2)} m away from the Outlet',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]));
  }

}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
*/
