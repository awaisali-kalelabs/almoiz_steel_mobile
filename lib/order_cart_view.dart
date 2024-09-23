/*import 'package:camera/camera.dart';*/
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
import 'package:order_booker/com/pbc/model/outlet_orders.dart';
import 'package:order_booker/gauge_segment.dart';
import 'package:order_booker/shopAction.dart';
import 'package:async/async.dart';
import 'globals.dart' as globals;
import 'globals.dart';
import 'orders.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  double discounttotalamount = 0.0;
  List<Map<String, dynamic>> AllOrders;
  List<Map<String, dynamic>> AllOrdersItems;
  List<Map<String, dynamic>> AllOrdersItemsPromotion;
  List<Map<String, dynamic>> AllBrandId;
  List<Map<String, dynamic>> AllBrandDiscount;
  List<Map<String, dynamic>> DiscountCalculation;
  List<Map<String, dynamic>> brandidforBrandsku;
  List<Map<String, dynamic>> BrandOnly;
  List<Map<String, dynamic>> DiscountSKUWise;
  List<Map<String, dynamic>> unitpercarton;
  List<Map<String, dynamic>> QuantityForSKUDis;
  List<Map<String, dynamic>> LRBName;
  List<Map<String, dynamic>> discountedList = [];
  List<Map<String, dynamic>> discountedListBrandsProducts = [];
  List<Map<String, dynamic>> AllProductsBrandwise;
  List<Map<String, dynamic>> AllOrdersItemsforBrandDisc;
  List<String> freeProductsQuantity;
  Repository repo = new Repository();
  bool isLocationTimedOut = false;
  bool isSpotSale = false;
  double Total_amount = 0.0;
 // int cal1 = 0;
  String Quantityof8="";
  String Quantityof9="";
  String Quantityof8Name="";
  String Quantityof9Name="";
  String MinimumQuantity8 = "";
  String MinimumQuantity9 = "";
  int total_qty_brandwisw =0 ;
  double singleproductCartons =0.0;
  _OrderCartView(int OrderId) {
    this.OrderId = OrderId;
  }
  Timer timer;
  double Newdistance1;
  double Newdistance = 0.0;
  double lat1 = globals.Lat; // Latitude of the first location
  double lon1 = globals.Lng; // Longitude of the first location

  double lat2 = double.tryParse(globals.IsGeoFenceLat); // Latitude of the second location
  double lon2 = double.tryParse(globals.IsGeoFenceLng);
  void fetchData() async {
    Future<List<Map<String, dynamic>>> outlet = repo.SelectOutletByID(globals.OutletID);

    List<Map<String, dynamic>> outletData = await outlet;

    // Now you can access the data from the List.
    if (outletData.isNotEmpty) {
      globals.IsGeoFenceLat = outletData[0]["lat"];
      globals.IsGeoFenceLng = outletData[0]["lng"];

    } else {
      // Handle the case where the list is empty or outletData[0] doesn't exist.
    }
  }
  @override
  void initState() {

   /* timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {

      fetchData();
      Future _calculateDistance3() async{
        double lat1122 = 0.0;double lng1122 = 0.0;
        double latDouble = double.parse(globals.IsGeoFenceLat);
        double lngDouble = double.parse(globals.IsGeoFenceLng);
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          setState(() {
          lat1122 = position.latitude;
          lng1122 = position.longitude;
           });
        } catch (e) {
          print("Error: $e");
        }
        double distanceInMeters =  await Geolocator.distanceBetween(

          lat1122,
          lng1122,
          latDouble,
          lngDouble,
        );

        // Convert the distance to other units if needed
        // For example, to kilometers: distanceInKm = distanceInMeters / 1000;

        return distanceInMeters;
      }
      // Update the coordinates here (for demonstration purposes, we're just changing them randomly)
      lat2 = Random().nextDouble() * 90; // Random latitude between -90 and 90
      lon2 = Random().nextDouble() * 180; // Random longitude between -180 and 180

      //Newdistance = calculateDistance(lat1, lon1, lat2, lon2);
      setState(()  {
        Newdistance =  _calculateDistance3();
      });
     // print('Updated Distance: $Newdistance meters');
    });*/

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
              discounttotalamount += AllOrdersItems[i]['amount'];
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
        calculateDiscount();
        //calculateDiscountforBrandsProduct();
      }

    });

    // Longitude of the second location
    _getLocation();
    setState(()  {

    });
  }
  void dispose() {
    //timer.cancel();
    super.dispose();
  }


    Future<void> calculateDiscount() async {
      int totalCartons = 0;
      List<Map<String, dynamic>> updatedDiscountedList = []; // Updated list to hold the new items


    await repo.getAllBrandID(globals.orderId).then((val) async {
      setState(() {
        AllBrandId = val;
      });
    });
   print("Brand :: "+AllBrandId.toString());


      for (int i = 0; i < AllBrandId.length; i++) {
        print(AllBrandId[i]["brand_id"]);
        await repo.getBrandDiscountBrandsProduct(
            AllBrandId[i]["brand_id"], globals.orderId).then((val) async {
          List<Map<String, dynamic>> brandDiscountList = val;
       //   print("brandProductList :: "+brandDiscountList.toString());

          for (int j = 0; j < brandDiscountList.length; j++) {
            await   repo.getUnitpercarton(brandDiscountList[j]['product_id']).then((
                unitpercarton){

             // print("unitpercarton :"+unitpercarton[0]["unitcarton"].toString());
                       total_qty_brandwisw = brandDiscountList[j]["total_quantity"];
                       singleproductCartons = total_qty_brandwisw / unitpercarton[0]["unitcarton"];
            //  print("total_qty_brandwisw :"+total_qty_brandwisw.toString());
              print("singleproductCartons :"+singleproductCartons.toString());

                       if (singleproductCartons % 1 == 0) {

                         totalCartons+=singleproductCartons.toInt();
                       //  print("totalCartons"+totalCartons.toString());
                       //  print("inside main if");
                         print("totalCartons :"+totalCartons.toString());
                       }



            });
            //totalCartons = 0;

          }

        });
        print("Cartons Against Brand :"+AllBrandId[i]["brand_id"].toString()+" "+totalCartons.toString());
        print(" globals.PciChannelID :" + globals.PciChannelID.toString());
        await repo.getDiscountSKU(AllBrandId[i]["brand_id"], totalCartons ,  globals.PciChannelID).then((discountVal) async {
          if(discountVal.length>0){
            await   repo.GetLRBName(AllBrandId[i]["brand_id"]).then((lrVal) {
              setState(() {
                LRBName = lrVal;
              });
              for (int l = 0; l < lrVal.length; l++) {
                double DiscountAmount = discountVal[l]["discount_percentage"]*totalCartons;
                setState(() {
                  discounttotalamount = discounttotalamount - DiscountAmount;
                });
                String LRB_Name = LRBName[l]["label"];
                updatedDiscountedList.add({
                  "LRB_Name": LRB_Name,
                  "discountAmount": DiscountAmount,
                  "afterDiscountAmount": discounttotalamount ,
                  "DiscountId": discountVal[0]["discount_id"],
                  "Brand_Id": AllBrandId[i]["brand_id"],
                  "Total_cartoon" : totalCartons
                });
              }
            });
          }

        });

        totalCartons = 0;

      }
    setState(() {
      //discountedList=[];
      discountedList = updatedDiscountedList;
    });
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
  double _latitude = 0.0;
  double _longitude = 0.0;


  bool visibility = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(globals.Lat, globals.Lng),
    zoom: 14.4746,
  );





  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.grey, // Background color
            ),
            child: Text('Save',
                style: TextStyle(
                  color: Colors.white,
                )),
            onPressed: AllOrdersItems == null || AllOrdersItems.isEmpty
                ? null
                : () async {
              print("======globals.productId============" +
                  globals.productId.toString());
              await repo.getAllOrdersforminQuantityfor8(globals.orderId).then((val){
                Quantityof8 = val[0]['quantity8'].toString();
              });
              await repo.getLRbName8().then((val){
                Quantityof8Name =val[0]['label'].toString();
              });
              await repo.getLRbName9().then((val){
                Quantityof9Name =val[0]['label'].toString();
              });
              await repo.getAllOrdersforminQuantityfor9(globals.orderId).then((val){
                Quantityof9 = val[0]['quantity9'].toString();
              });
              await repo.getminQuantityfor8().then((value) {
                setState(() {
                  MinimumQuantity8 = value[0]['MinimumQuantity'].toString();
                  print("MinimumQuantity8" + MinimumQuantity8);
                });
              });
              await repo.getminQuantityfor9().then((value) {
                setState(() {
                  MinimumQuantity9 = value[0]['MinimumQuantity'].toString();
                  print("MinimumQuantity9" + MinimumQuantity9);
                });
              });
              String qty8Error = "";
              String qty9Error= "";
              int qty8 = int.tryParse(Quantityof8);
              int minQty8 = int.tryParse(MinimumQuantity8);
              int qty9 = int.tryParse(Quantityof9);
              int minQty9 = int.tryParse(MinimumQuantity9);
              print("qty8 :"+qty8.toString());
              print("minQty8 :"+minQty8.toString());
              print("qty9 :"+qty9.toString());
              print("minQty9 :"+minQty9.toString());
              if (((qty8 != null  && qty8 >= minQty8) || qty8 == null) && ((qty9 != null  && qty9 >= minQty9) || qty9 == null)) {
                await completeOrder(context);
              }    else {
                // Quantity conditions not met, save error message and values
                if (qty8 != null && qty8 < minQty8) {
                  qty8Error =Quantityof8Name +"\n" +"Minimum QTY for $Quantityof8Name : $MinimumQuantity8" ;
                }
                if (qty9 != null && qty9 < minQty9) {
                  qty9Error = Quantityof9Name +"\n" +"Minimum QTY for $Quantityof9Name : $MinimumQuantity9";
                }
                // Quantity conditions not met, show error message
                _showDialog1("Error", "Quantity conditions not met for \n  $qty8Error \n  $qty9Error", 0);
              }
            },
          ),
        ],
      ),
      body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Column(
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
                                          BorderRadius.circular(0.0),
                                        ),
                                        color: HexColor("#006400"),
                                        elevation: 2,
                                        child: Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  totalAddedProducts
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color:
                                                      Colors.white),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                                Text(
                                                  "Total Items",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                      Colors.white),
                                                  textAlign:
                                                  TextAlign.center,
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
                                          BorderRadius.circular(0.0),
                                        ),
                                        color: HexColor("#006400"),
                                        elevation: 2,
                                        child: Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  globals
                                                      .getDisplayCurrencyFormat(
                                                      dp(totalAmount,
                                                          0))
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color:
                                                      Colors.white),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                                Text(
                                                  'Total Amount',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                      Colors.white),
                                                  textAlign:
                                                  TextAlign.center,
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
                                              Container(
                                                padding:
                                                EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "Products",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Rate",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Disc",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Qty",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Amount",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                        textAlign:
                                                        TextAlign
                                                            .right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                    const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                    AllOrdersItems != null
                                                        ? AllOrdersItems
                                                        .length
                                                        : 0,
                                                    itemBuilder: itemsList,
                                                  ))
                                            ],
                                          )),
                                    )
                                  ]),
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
                                              Container(
                                                padding:
                                                EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "Brand Discount",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Disc",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Amount After Disc",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white),
                                                        textAlign:
                                                        TextAlign
                                                            .right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                    const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                    AllOrdersItems != null
                                                        ? AllOrdersItems
                                                        .length
                                                        : 0,
                                                    itemBuilder: itemsList1,
                                                  ))
                                            ],
                                          )),
                                    )
                                  ]),
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
                                              Container(
                                                padding:
                                                EdgeInsets.all(10),
                                                child: Text(
                                                  "Promotions",
                                                  style: TextStyle(
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color:
                                                      Colors.white),
                                                ),
                                                alignment:
                                                Alignment.centerLeft,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                padding:
                                                EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "Products",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "Qty",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .black),
                                                        textAlign:
                                                        TextAlign
                                                            .right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                color: Colors.black12,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                    const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                    AllOrdersItemsPromotion !=
                                                        null
                                                        ? AllOrdersItemsPromotion
                                                        .length
                                                        : 0,
                                                    itemBuilder:
                                                    itemsListPromotion,
                                                  ))
                                            ],
                                          )))
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Switch(
                                      value: isSpotSale,
                                      onChanged: (bool newValue) {
                                        setState(() {
                                          isSpotSale = newValue;
                                        });
                                        if (newValue) {
                                          setState(() {
                                            globals.isSpotSale = 1;
                                          });
                                        } else {
                                          setState(() {
                                            globals.isSpotSale = 0;
                                          });
                                        }
                                      },
                                    ),
                                    Text(
                                      'Spot Sale',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ]),
                            ],
                          )
                      ),
                    ),

                  ],
                ),

              ],
            ),
          /*  Container(
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
/*            Container(
              height: 200,
              child :Text(
                'You are ${Newdistance.toStringAsFixed(2)} m away from the Outlet',
                style: TextStyle(fontSize: 20.0),
              ),
            )*/
          ]),

      //child: MapScreen()
    );
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
      splashColor: Colors.green,
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
                  child: Text(
                    AllOrdersItems[index]['product_label'].toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    globals
                        .getDisplayCurrencyFormatTwoDecimal(
                        AllOrdersItems[index]['rate'])
                        .toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                    globals
                        .getDisplayCurrencyFormatTwoDecimal(
                        AllOrdersItems[index]['discount'])
                        .toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12)),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  AllOrdersItems[index]['quantity'].toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  globals
                      .getDisplayCurrencyFormat(AllOrdersItems[index]['amount'])
                      .toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget itemsList1(BuildContext context, int index) {
    if (index >= discountedList.length) {
      // Return an empty container if index is out of bounds
      return Container();
    }
    return InkWell(

      splashColor: Colors.green,
      onDoubleTap: () {
      },
      child: Column(
        children: <Widget>[
          index == 0 ? Container() : Divider(),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child: Text(
                    discountedList.isNotEmpty
                        ? discountedList[index]['LRB_Name'].toString()
                        : '',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                    discountedList.isNotEmpty
                        ? discountedList[index]['discountAmount'].toStringAsFixed(0)
                        : '',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12)),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  discountedList.isNotEmpty
                      ? discountedList[index]['afterDiscountAmount'].toStringAsFixed(0)
                      : '',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12),
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

  Future completeOrder(context) async {
    print("inside if2");
    Position position = globals.currentPosition;
    await repo.completeOrder(globals.channellat, globals.channellat,
        globals.channelacc, globals.OutletID,globals.isSpotSale);
    await repo.setVisitType(globals.OutletID, 1);
    _UploadOrder(context);
    _UploadDocuments();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ShopAction()),
        ModalRoute.withName("/ShopAction"));


   /* List OutletData = new List();
    OutletData = await repo.SelectOutletByID(globals.OutletID);
    globals.IsGeoFence = OutletData[0]["IsGeoFence"];
    globals.IsGeoFenceLat = OutletData[0]["lat"];
    globals.IsGeoFenceLng = OutletData[0]["lng"];
    globals.Radius = OutletData[0]["Radius"];
    print("_latitude===>"+_latitude.toString());
    print("IsGeoFence"+globals.IsGeoFence.toString());
    print("IsGeoFenceLat"+globals.IsGeoFenceLat.toString());
    print("IsGeoFvenceLng"+globals.IsGeoFenceLng.toString());
    print("Radius================="+globals.Radius.toString());
*//*
     Future _calculateDistance() async{
      double latDouble = double.parse(globals.IsGeoFenceLat);
      double lngDouble = double.parse(globals.IsGeoFenceLng);

      double distanceInMeters =  await Geolocator.distanceBetween(
        _latitude,
        _longitude,
        latDouble,
        lngDouble,
      );

      // Convert the distance to other units if needed
      // For example, to kilometers: distanceInKm = distanceInMeters / 1000;

      return distanceInMeters;
    }
*//*

    Future _calculateDistance2() async{
       double lat1122 = 0.0;double lng1122 = 0.0;
      double latDouble = double.parse(globals.IsGeoFenceLat);
      double lngDouble = double.parse(globals.IsGeoFenceLng);
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        //setState(() {
          lat1122 = position.latitude;
          lng1122 = position.longitude;
       // });
      } catch (e) {
        print("Error: $e");
      }
      double distanceInMeters =  await Geolocator.distanceBetween(

        lat1122,
        lng1122,
        latDouble,
        lngDouble,
      );

      // Convert the distance to other units if needed
      // For example, to kilometers: distanceInKm = distanceInMeters / 1000;

      return distanceInMeters;
    }

    int Distance2 = globals.Radius;
    print("Distance 2 :" + Distance2.toString());
    double distance = await _calculateDistance2();
    print(""
        ""+distance.toString());
    if ( globals.IsGeoFence == 0  ) {
      print("inside if");
      // Position position = globals.currentPosition;
      await repo.completeOrder(globals.channellat, globals.channellat,
          globals.channelacc, globals.OutletID , globals.isSpotSale);
      await repo.setVisitType(globals.OutletID, 1);
     // Navigator.of(context, rootNavigator: true).pop('dialog');
      _UploadOrder(context);
      _UploadDocuments();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShopAction()),
          ModalRoute.withName("/ShopAction"));
      print("===>>>>>>"+ModalRoute.of(context)?.settings?.name);
*//*      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShopAction()),
      ); *//*   // Navigator.pushAndRemoveUntil(
    } else {
      // 10 <= 5
      print("distance Main"+distance.toString());
      print("Distance2 Main"+Distance2.toString());
      if(distance <= Distance2){
        print("inside if2");
        Position position = globals.currentPosition;
        await repo.completeOrder(globals.channellat, globals.channellat,
            globals.channelacc, globals.OutletID,globals.isSpotSale);
        await repo.setVisitType(globals.OutletID, 1);
        _UploadOrder(context);
        _UploadDocuments();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ShopAction()),
            ModalRoute.withName("/ShopAction"));
      }else {
        print("distance Main"+distance.toString());
        print("Distance2 Main"+Distance2.toString());
        print("inside Else");
        repo.deletePastOrders(globals.OutletID);
        repo.deleteOutletImage();
        print("Delete Order");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error"),
              content: new Text(
                  'Can\'t place order, you are ${distance
                      .toInt()} meters away from the shop.'),
              actions: <Widget>[
                new ElevatedButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShopAction()),
                    );
   *//*                 Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => ShopAction()),
                        ModalRoute.withName("/ShopAction"));*//*
                  },
                ),
              ],
            );
          },
        );
      }
    }*/
  }

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
            AllNoOrders[i]['lat'] +
            "&Lng=" +
            AllNoOrders[i]['lng'] +
            "&accuracy=" +
            AllNoOrders[i]['accuracy'] +
            "";
        ORDERIDToDelete = AllNoOrders[i]['id'];
        var QueryParameters = <String, String>{
          "SessionID": globals.EncryptSessionID(orderParam),
        };
        var url =
        Uri.https(globals.ServerURL, '/portal/mobile/MobileSyncNoOrdersV2');
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
              _showDialog("Error", responseBody["error_code"], 0);
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
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    String currDateTime = dateFormat.format(DateTime.now());
    var str = currDateTime.split(".");
    int ORDERIDToDelete = 0;

    String TimeStamp = str[0];

    print("currDateTime" + TimeStamp);

      await repo.getAllOrdersByIsUploaded(0).then((val) async {
        AllOrders = val;
        AllOrdersItems = new List();
        print(AllOrders.toString());

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
              "&version=" +
              appVersion;

          ORDERIDToDelete = AllOrders[i]['id'];
          print(ORDERIDToDelete);
          await repo.getAllAddedItemsOfOrder(AllOrders[i]['id']).then((val) async {
            AllOrdersItems = val;
            /*
        setState(() {
          AllOrdersItems = val;
          print("ITEMS" + AllOrdersItems.toString());
        });
        */
            String orderItemParam = "";
            print("Product Total" + AllOrdersItems.length.toString());
            for (int j = 0; j < AllOrdersItems.length; j++) {
              print(AllOrdersItems[j]['quantity'].toString());
              print(AllOrdersItems[j]['unit_quantity'].toString());
              print(AllOrdersItems[j]['discount'].toString());

              print("==============" + AllOrdersItems[j]['product_id'].toString());
              orderParam += "&product_id=" +
                  AllOrdersItems[j]['product_id'].toString() +
                  "&quantity=" +
                  AllOrdersItems[j]['quantity'].toString() +
                  "&discount=" +
                  AllOrdersItems[j]['discount'].toString() +
                  "&unit_quantity=" +
                  AllOrdersItems[j]['unit_quantity'].toString() +
                  "&is_promotion=" +
                  AllOrdersItems[j]['is_promotion'].toString() +
                  "&promotion_id=" +
                  AllOrdersItems[j]['promotion_id'].toString() +
                  "";
            }

            print("discountedList====>" + discountedList.toString());
            for (int j = 0; j < discountedList.length; j++) {
              orderParam +=
                  "&discount_brand_cartons=" +
                      discountedList[j]['Total_cartoon'].toString() +
                      "&discount_brand_amount=" +
                      discountedList[j]['discountAmount'].toStringAsFixed(2) +
                      "&discount_brand_id=" +
                      discountedList[j]["DiscountId"].toString() +
                      "&d_brand_id=" +
                      discountedList[j]['Brand_Id'].toString() +
                      "";
            }
            //Total_cartoon
          });
          print("orderParam: " + orderParam.toString());
          print("orderParam==========================: " + orderParam);
          var QueryParameters = <String, String>{
            "SessionID": EncryptSessionID(orderParam),
          };
          print("QueryParameters ===================: " + QueryParameters.toString());
          var url = Uri.https(globals.ServerURL, '/portal/mobile/MobileSyncOrdersV11');
          print(url);

          try {
            var response = await http.post(url, headers: {
              HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
            }, body: QueryParameters);
            var responseBody = json.decode(response.body);
            print('called4');
            if (response.statusCode == 200) {
              ///  final data = json.decode(response.body);
              //  print("Inside 200");
              if (responseBody["success"] == "true") {
                // print("Inside True");
                await repo.markOrderUploaded(ORDERIDToDelete);
                // await repo.deleteUploadedOrder(ORDERIDToDelete);
                _UploadDocuments();

                //_showDialog("Success","order uploaded. ",1);
              } else if (responseBody["success"] == "false") {
                print("In Geo ssssss");
                print(
                    "=================1111111=========================" + responseBody["error_code"]);
                _showDialog("Error", responseBody["error_code"], 0);
              } else {
                print("============2==============" + responseBody["error_code"]);

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
  Future _UploadDocuments() async {
    print("_UploadDocuments called");
    List AllDocuments = [];
    await repo.getAllOutletImages(globals.orderId).then((val) async {
      //setState(() {
        AllDocuments = val;
     // });

      for (int i = 0; i < AllDocuments.length; i++) {
        int MobileRequestID = int.parse(AllDocuments[i]['id'].toString());
        try {
          print("AllDocuments.length" + AllDocuments.length.toString());
          File photoFile = File(AllDocuments[i]['file']);
          var stream =
          new http.ByteStream(DelegatingStream.typed(photoFile.openRead()));
          var length = await photoFile.length();
          var url = Uri.https(
              globals.ServerURL, '/portal/mobile/MobileUploadOrdersImage');
          print(url.toString());
          String fileName = photoFile.path.split('/').last;

          var request = new http.MultipartRequest("POST", url);
          request.fields['value1'] = MobileRequestID.toString();

          var multipartFile = new http.MultipartFile('file', stream, length,
              filename: "Outlet_" + fileName);

          request.files.add(multipartFile);
          var response = await request.send();
          print(response.statusCode);

          print("response.toString()");
          print(response.toString());
          if (response.statusCode == 200) {
            print("markMerchandisingPhotoUploaded SUCCESS");
            await repo.markPhotoUploaded(MobileRequestID);
          }
        } catch (e) {
          print("e.toString()  " + e.toString());
        }
      }
    });
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
  void _showDialog1(String Title, String Message, int isSuccess) {
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
                  Navigator.of(context).pop();

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
              onPressed: ()  {
                print("bhai");
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

                setState(() {
                  calculateDiscount();
                  print("after calculateDiscount");
                });
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

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(37.7749, -122.4194);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Flutter'),
        backgroundColor: Colors.blue[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
      ),
    );
  }
}
