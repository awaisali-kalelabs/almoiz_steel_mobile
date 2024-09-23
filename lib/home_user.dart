import 'dart:convert';
import 'dart:io';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:order_booker/attendance.dart';
import 'package:order_booker/attendance_sync_report_view.dart';
import 'package:order_booker/com/pbc/dao/repository.dart';
import 'package:order_booker/gauge_segment.dart';
import 'package:order_booker/main.dart';
import 'package:order_booker/order_report_select_date.dart';
import 'package:order_booker/outlet_registration.dart';
import 'package:order_booker/pre_sell_route.dart';

import 'package:async/async.dart';
import 'package:order_booker/sales_report_select_date.dart';
import 'package:order_booker/sales_report_view.dart';
import 'package:order_booker/stock_report_view.dart';
import 'package:order_booker/order_sync_report_view.dart';
import 'package:order_booker/user_attendance.dart';

/*import 'package:order_booker/pre_sell_route_offline_deliveries.dart';
import 'package:order_booker/spot_sell_route.dart';
import 'pre_sell_chart.dart';
import 'pre_sell_route.dart';
import 'spot_sell_chart.dart';*/
import 'marketvistit/Cities.dart';
import 'marketvistit/SelectPJP.dart';
import 'globals.dart' as globals;

// This app is a stateful, it tracks the user's current choice.
class HomeUser extends StatefulWidget {
  @override
  _HomeUser createState() => _HomeUser();
}

class _HomeUser extends State<HomeUser> {
  /*Repository repo=new Repository();*/
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  List<String> Routes;
  double delivered = 0;

  List<Map<String, dynamic>> AllOrders;
  List<Map<String, dynamic>> AllOrdersItems;
  Repository repo = new Repository();



  @override
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to logout?'),
        actions: <Widget>[
          new ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _scaffoldKey1,
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            height: 91.0,
                            child: new DrawerHeader(
                              decoration: BoxDecoration(
                                color: Colors.green[800],
                              ),
                              child: Text(
                                'Almoiz',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ))),
                  ],
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.green),
                  title: Text('Logout'),
                  onTap: () {
                    globals.Reset();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                Expanded(
                    child: Align(
                        alignment: FractionalOffset.bottomRight,
                        child: Container(
                            height: 57,
                            //  color: Colors.red,
                            child: Container(
                                padding: EdgeInsets.all(10),
                                height: 100,
                                child: Text(
                                  "Attendance App "+
                                      globals.appVersion,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))))),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.green[800],
            actions: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                /*  child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/avatar.jpg"),
              ),*/
              )
            ],
            title: Text(
              globals.DisplayName,
              style: TextStyle(fontSize: 16),
            ), /*
            leading:
              // action biutton
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () async {
                  _scaffoldKey.currentState.openDrawer();
                  /*
                  _showLoader();
                  Map<String,dynamic> Response =await globals.makeDelivery();
                  _showDialog(Response['success']==1?"Success":"Error",""+ Response['message']);
                  */
                },
              ),
*/
          ),
          body: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Card(
                          child: Column(
                            children: [

                              Column(
                                children: [
                                  SizedBox(
                                    height: 12.0,
                                  ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Market Visit",
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                ),
              ),

              Container(
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Cities()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/building.png",
                              width: 55,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                              child: Text(
                                'Market Visit',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

        Container(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Attendance",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 17),
                                                )),
                                          ),

                                          Container(
                                            child: Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   children: [
                                          //     Expanded(
                                          //         child: Container(
                                          //           padding: EdgeInsets.all(10),
                                          //           child: Column(
                                          //             children: <Widget>[
                                          //               Center(
                                          //                 child: Text("Attendance Application",  style: TextStyle(
                                          //                     color: Colors.redAccent,
                                          //                     fontSize: 21,
                                          //                     fontWeight: FontWeight.bold
                                          //                 ),),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         )),
                                          //
                                          //   ],
                                          // ),
                                         Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap:  () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserAttendance()),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Image.asset(
                                                              "assets/images/calendar.png",
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
                                                                'Attendance',
                                                                style: TextStyle(
                                                                    color:
                                                                    Colors.black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  )
                                              ),
                                            ],
                                          )

                                        ],
                                      )),

                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ])),
    );
  }

  _showDialogFinalMessage(String Title, String Message) async {
    Navigator.of(context, rootNavigator: true).pop('dialog');

    if (Title == null) {
      Title = " ";
    }
    if (Message == null) {
      Message = " ";
    }


    // flutter defined function

    return showDialog(
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
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeUser()),
                    ModalRoute.withName("/home"));
              },
            ),
          ],
        );
      },
    );
  }




}

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeUser(),
    ),
  );
}
