import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:order_booker/com/pbc/dao/repository.dart';
import 'package:order_booker/gauge_segment.dart';
import 'package:order_booker/marketvistit/shopActionMarketVisit.dart';
import 'MarketVisitStart.dart';
import '../globals.dart' as globals;


// This app is a stateful, it tracks the user's current choice.
class OrderCartView extends StatefulWidget {
  int OrderId = 0;

  OrderCartView({int OrderId}) {
    this.OrderId = OrderId;
  }

  @override
  _OrderCartView createState() => _OrderCartView(OrderId);
}

class _OrderCartView extends State<OrderCartView> {
  bool _isLoading = false;
  int OrderId = 0;
  int totalAddedProducts = 0;
  double totalAmount = 0.0;
  List<Map<String, dynamic>> AllOrders;
  List<Map<String, dynamic>> AllOrdersItems;
  List<Map<String, dynamic>> AllOrdersItemsPromotion;
  List<String> freeProductsQuantity;
  Repository repo = new Repository();
  bool isLocationTimedOut = false;
  bool isSpotSale = false;
  Timer timer;
  double Newdistance1;
  double Newdistance = 0.0;
  double lat1 = globals.Lat; // Latitude of the first location
  double lon1 = globals.Lng; // Longitude of the first location

  double lat2 = double.tryParse(globals.IsGeoFenceLat); // Latitude of the second location
  double lon2 = double.tryParse(globals.IsGeoFenceLng);
  _OrderCartView(int OrderId) {
    this.OrderId = OrderId;
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      // Update the coordinates here (for demonstration purposes, we're just changing them randomly)
      lat2 = Random().nextDouble() * 90; // Random latitude between -90 and 90
      lon2 = Random().nextDouble() * 180; // Random longitude between -180 and 180

      //Newdistance = calculateDistance(lat1, lon1, lat2, lon2);
      setState(() {
        Newdistance = _calculateDistance();
      });
      print('Updated Distance: $Newdistance meters');
    });
    AllOrders = new List();
    freeProductsQuantity = new List();
    repo.getAllOrders(globals.OutletID, 0).then((val) async {
      setState(() {
        AllOrders = val;
      });

      AllOrdersItems = new List();
      for (int i = 0; i < AllOrders.length; i++) {
        repo
            .getAllAddedItemsOfOrderByIsPromotion(AllOrders[i]['id'], 0)
            .then((val) async {
          setState(() {
            AllOrdersItems = val;
            totalAddedProducts = AllOrdersItems.length;
            for (int i = 0; i < AllOrdersItems.length; i++) {
              totalAmount += AllOrdersItems[i]['amount'];
            }
          });
        });

        repo
            .getAllAddedItemsOfOrderByIsPromotion(AllOrders[i]['id'], 1)
            .then((val) async {
          setState(() {
            AllOrdersItemsPromotion = val;
            for (int i = 0; i < val.length; i++) {
              int unitQuantity = val[i]['unit_quantity'];
              freeProductsQuantity.add(unitQuantity.toString());
            }
          });
        });
      }
    });


    _getLocation();
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
  Future _UploadDocuments() async {
    print("_UploadDocuments called");
    List AllDocuments = new List();
    repo.getAllOutletImages(globals.orderId).then((val) async {
      setState(() {
        AllDocuments = val;
      });
    });
  }
//  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
/*  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(globals.Lat, globals.Lng),
    zoom: 14.4746,
  );*/
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
//    timer.cancel();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String selected;
    return Scaffold(
      //backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Orders(
                        outletId: globals.OutletID,
                      )),
                );
              }),
          actions: [

          ],
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5.0, 10.0, 2.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: <Widget>[
                                                    TextField(
                                                      decoration: InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        hintText: 'Comments',
                                                        //contentPadding: EdgeInsets.symmetric(vertical: 40),
                                                      ),
                                                      controller: _controller,
                                                    ),
                                                  ],
                                                )),
                                          )  
                                        ]),
                                   /* SizedBox(height: 10,),
                                    Container(
                                      height: 200,
                                      child : Stack(
                                          children: [
                                           GoogleMap(
                                              initialCameraPosition: _kGooglePlex,
                                              markers: {
                                                Marker(
                                                  markerId: MarkerId('Sydney'),
                                                  position: LatLng(globals.Lat, globals.Lng),
                                                )
                                              },
                                              // markers: markers.values.toSet(),
                                            ),
                                          ]
                                      ),
                                    ),*/
                                  /*  Container(
                                      height: 200,
                                      child :Text(
                                        'You are ${Newdistance.toStringAsFixed(2)} m away from the Outlet',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),*/
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5.0, 10.0, 2.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.grey, // Background color
                                                      ),
                                                      child: Text('End Visit',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                      onPressed:
                                                          () {
                                                        print("hye");
                                                        /* _UploadOrder();*/
                                                        //  _showIndicator();
                                                        completeOrder(context);

                                                      },
                                                    ),
                                                  ],
                                                )))
                                      ],
                                    ),

                                  ],
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            ]));
  }

  Widget itemsListPromotion(BuildContext context, int index) {
    return InkWell(
      splashColor: Colors.green,
      onDoubleTap: () {
        print("M tapped");
        _confirmItemDelete(
            AllOrdersItemsPromotion[index]['product_label'].toString(),
            "Do you want to delete this product?",
            AllOrdersItemsPromotion[index]['product_id'],
            AllOrdersItemsPromotion[index]['order_id'],
            -1);
      },
      child: Column(
        children: <Widget>[
          index == 0 ? Container() : Divider(),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  //padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    AllOrdersItemsPromotion[index]['product_label'].toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  //AllOrdersItemsPromotion[index]['unit_quantity'].toString(),
                  freeProductsQuantity[index],
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget itemsList(BuildContext context, int index) {
    return InkWell(
      splashColor: Colors.red,
      onDoubleTap: () {
        print("M tapped");
        _confirmItemDelete(
            AllOrdersItems[index]['product_label'].toString(),
            "Do you want to delete this product?",
            AllOrdersItems[index]['product_id'],
            AllOrdersItems[index]['order_id'],
            AllOrdersItems[index]['id']);
      },
      child: Column(
        children: <Widget>[
          index == 0 ? Container() : Divider(),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child:
                  Text(
                    AllOrdersItems[index]['product_label'].toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
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
  Future completeOrder(context) async {
    await repo.completeOrder(globals.channellat, globals.channellat,
        globals.channelacc, globals.OutletID , globals.isSpotSale);
    await repo.setVisitType(globals.OutletID, 1);
   // Navigator.of(context, rootNavigator: true).pop('dialog');
    _UploadOrder(context);
    _UploadDocuments();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShopAction()),
    );
      //  ModalRoute.withName("/PreSellRoute"));
  /*  List OutletDataMV = new List();
    OutletDataMV = await repo.SelectOutletByIDMV(globals.OutletID);
    String isGeoFenceString = OutletDataMV[0]["IsGeoFence"];

    globals.IsGeoFence = int.parse(isGeoFenceString);
    globals.IsGeoFenceLat = OutletDataMV[0]["lat"];
    globals.IsGeoFenceLng = OutletDataMV[0]["lng"];
    globals.Radius = OutletDataMV[0]["Radius"];
    print("_latitude===>"+_latitude.toString());
    //print("IsGeoFence"+globals.IsGeoFence);
    print("IsGeoFenceLat"+globals.IsGeoFenceLat.toString());
    print("IsGeoFenceLng"+globals.IsGeoFenceLng.toString());
    print("Radius===================="+globals.Radius.toString());

    int Distance2 = globals.Radius;
    print("Distance 2" + Distance2.toString());
    double distance = _calculateDistance();
    print("distance"+distance.toString());
    print("IsGeoFence"+globals.IsGeoFence.toString());
    if ( globals.IsGeoFence == 0 ) {
      print("inside if");
      Position position = globals.currentPosition;
      await repo.completeOrder(globals.channellat, globals.channellat,
          globals.channelacc, globals.OutletID , globals.isSpotSale);
      await repo.setVisitType(globals.OutletID, 1);
      Navigator.of(context, rootNavigator: true).pop('dialog');
      _UploadOrder(context);
      _UploadDocuments();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
          ModalRoute.withName("/PreSellRoute"));
    } else {
      if(distance <= Distance2){
        print("inside if");
        Position position = globals.currentPosition;
        await repo.completeOrder(globals.channellat, globals.channellat,
            globals.channelacc, globals.OutletID,globals.isSpotSale);
        await repo.setVisitType(globals.OutletID, 1);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _UploadOrder(context);
        _UploadDocuments();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
            ModalRoute.withName("/PreSellRoute"));
      }else {

        print("inside Else");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Error"),
              content: new Text(
                  'Can\'t place order, you are ${distance
                      .toInt()} meters away from the shop.'),
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
  }
        //    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();


  Future _UploadNoOrder(context) async {
    String TimeStamp = globals.getCurrentTimestamp();
    print("currDateTime" + TimeStamp);
    int ORDERIDToDelete = 0;
    List AllNoOrders = new List();
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
            globals.currentPosition.latitude.toString() +
            "&Lng=" +
            globals.currentPosition.longitude.toString() +
            "&accuracy=" +
            globals.currentPosition.accuracy.toString() +
            "";
            "";
        ORDERIDToDelete = AllNoOrders[i]['id'];
        var QueryParameters = <String, String>{
          "SessionID": globals.EncryptSessionID(orderParam),
        };
        print('called99999');
        var url =
        Uri.https(globals.ServerURL, '/portal/mobile/MobileSyncNoOrdersSMV4');
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
          if (response.statusCode == 200) {
            if (responseBody["success"] == "true") {
              await repo.markNoOrderUploaded(ORDERIDToDelete);
            } else {
              _showDialog("Error", responseBody["error"], 0);
            }
          } else {
            // If that response was not OK, throw an error.

            //await _showDialog("Error Uploading No Order", "An error has occured " + responseBody.statusCode);
          }
        } catch (e) {
          //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          //await _showDialog("Error Uploading No Order", "An error has occured " + e.toString());
        }
        //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);

      }
    });
  }

  Future _UploadOrder(context) async {
/*
    DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());
    var str = currDateTime.split(".");

    String TimeStamp = str[0];

    print("currDateTime" + TimeStamp);
*/
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());
    var str = currDateTime.split(".");
    String TimeStamp =str[0];

    int ORDERIDToDelete = 0;
    AllOrders = new List();
    await repo.getAllOrdersByIsUploaded(0).then((val) async {
      AllOrders = val;
      /*
      setState(() {
        AllOrders = val;

        print("MAIN ORDER" + AllOrders.toString());
      });
      */
      AllOrdersItems = new List();
      print("AllOrders"+AllOrders.toString());
      for (int i = 0; i < AllOrders.length; i++) {
        String orderParam = "timestamp=" +
            TimeStamp +
            "&order_no=" +
            AllOrders[i]['id'].toString() +
            "&outlet_id=" +
            AllOrders[i]['outlet_id'].toString() +
            "&created_on=" +
            AllOrders[i]['created_on'].toString() +
            "&created_by=" +
            globals.UserID.toString() +
            "&uuid=" +
            globals.DeviceID +
            "&platform=android&lat=" +
            AllOrders[i]['lat'] +
            "&lng=" +
            AllOrders[i]['lng'] +
            "&accuracy=" +
            AllOrders[i]['accuracy'] +
            "&is_spot_sale=" +
            AllOrders[i]['is_spot_sale'].toString() +
            "&order_comments=" +
            _controller.text.toString() +
            "&PJPID=" +
            globals.PJPID;

        ORDERIDToDelete = AllOrders[i]['id'];
        await repo
            .getAllAddedItemsOfOrders(AllOrders[i]['id'])
            .then((val) async {
          AllOrdersItems = val;
          /*
          setState(() {
            AllOrdersItems = val;
            print("ITEMS" + AllOrdersItems.toString());
          });
          */
          String orderItemParam = "";
          for (int j = 0; j < AllOrdersItems.length; j++) {
            orderParam += "&product_id=" +
                AllOrdersItems[j]['product_id'].toString() +
                "&quantity=" +
                1.toString() +
                "&unit_quantity=" +
                0.toString() +
                "&is_promotion=" +
                AllOrdersItems[j]['is_promotion'].toString() +
                "&promotion_id=" +
                AllOrdersItems[j]['promotion_id'].toString() +
                "";
          }
        });
        print("orderParam: " + orderParam.toString());
        var QueryParameters = <String, String>{
          "SessionID": EncryptSessionID(orderParam),
        };

        var url =
        Uri.https(globals.ServerURL, '/portal/mobile/MobileSyncNoOrdersSMV4');
        print(url);

        try {
          var response = await http.post(url,
              headers: {
                HttpHeaders.contentTypeHeader:
                'application/x-www-form-urlencoded'

              },
              body: QueryParameters);
          // print("response body : "+response.body);
          // print("response bodyBytes : "+response.bodyBytes.toString());
          // print("response decode : "+json.decode(response.body).toString());
          // print("response.statusCode : "+response.statusCode.toString());
          //  var responseBody = json.decode(utf8.decode(response.bodyBytes));
          var responseBody = json.decode(response.body);
          //    print("responseBody ==> success "+responseBody["success"] );
          // print("responseBody ==> error_code "+responseBody["error_code"] );
          print('called4');
          if (response.statusCode == 200) {
            ///  final data = json.decode(response.body);
            //  print("Inside 200");
            if (responseBody["success"] == "true") {
               print("Inside True");
              await repo.markOrderUploaded(ORDERIDToDelete);
              _UploadDocuments();

              //_showDialog("Success","order uploaded. ",1);
            } else if (responseBody["success"] == "false") {
              print("In false");
              _showDialog("Error", responseBody["error_code"], 0);
            } else {
              print("In false 2");

              _showDialog("Error", responseBody["error_code"], 0);
            }
          } else {
            // If that response was not OK, throw an error.

            //_showDialog("Error", "An error has occured " + responseBody.statusCode, 0);
          }
        } catch (e) {

          //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop(); print(e.toString());
          //  print("In Exception");

          //   print(e.toString());
          //    _showDialog("Error", "An error has occured " + e.toString(), 1);
        }
        //var response = await http.post(localUrl, headers: {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},body: QueryParameters);

      }
    });
  }

//Awais Working


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
            new TextButton(
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

  void _confirmItemDelete(
      String Title, String Message, int itemId, int orderId, int sourceId) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm"),
          content: new Text(Title, style: new TextStyle(fontSize: 16)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("Delete"),
              onPressed: () {
                repo.deleteOrderItem(orderId, itemId);
                repo.deleteOrderItemBySourceId(orderId, sourceId);
                AllOrdersItems = new List();
                totalAmount = 0.0;
                for (int i = 0; i < AllOrders.length; i++) {
                  repo
                      .getAllAddedItemsOfOrderByIsPromotion(
                      AllOrders[i]['id'], 0)
                      .then((val) async {
                    setState(() {
                      AllOrdersItems = val;
                      totalAddedProducts = AllOrdersItems.length;
                      for (int i = 0; i < AllOrdersItems.length; i++) {
                        totalAmount += AllOrdersItems[i]['amount'];
                      }
                    });
                  });

                  repo
                      .getAllAddedItemsOfOrderByIsPromotion(
                      AllOrders[i]['id'], 1)
                      .then((val) async {
                    setState(() {
                      AllOrdersItemsPromotion = val;
                    });
                  });
                }
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showIndicator() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: new Text("Title"),
          content: new Text("Message"),
          actions: <Widget>[],
        );
      },
    );
  }
}

//old working function
Future<void> uploadOrder222(String orderParam) async {
  print("orderParam:" + orderParam);
  var QueryParameters = <String, String>{
    "SessionID": EncryptSessionID(orderParam),
  };
  //globals.ServerURL = "192.168.201.152:8080";

  var url =   Uri.https(globals.ServerURL, '/portal/mobile/MobileSyncNoOrdersSMV4');
//      Wave/grain/sales/MobileVFSalesContractExecute
  print(url);
  var response = await http.get(url, headers: {
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
  });
  print(response);
  var responseBody = json.decode(utf8.decode(response.bodyBytes));
  print('called4');
  //  print(responseBody);
  if (responseBody["success"] == "true") {
    print("done");
  }else{
    print("Error");
  }
}

String EncryptSessionID(String qry) {
  String ret = "";
  print(qry.length);
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

List<charts.Series<GaugeSegment, String>> _createSampleData(data) {
  return [
    new charts.Series<GaugeSegment, String>(
      id: 'Segments',
      domainFn: (GaugeSegment segment, _) => segment.segment,
      measureFn: (GaugeSegment segment, _) => segment.size,
      data: data,
    )
  ];
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
