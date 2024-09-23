import 'package:another_flushbar/flushbar.dart';import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:order_booker/channel_tagging_list.dart';
import 'package:order_booker/shopAction.dart';
import 'channel_tagging_image.dart';
import 'com/pbc/dao/repository.dart';
import 'com/pbc/model/pci_sub_channel.dart';
import 'globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class ChannelTagging extends StatefulWidget {
  ChannelTagging({Key key}) : super(key: key);

  @override
  _ChannelTagging createState() => _ChannelTagging();
}

class _ChannelTagging extends State<ChannelTagging> {

  double _lat = globals.channellat != 0.0 ? globals.channellat : globals.Lat;
  double _lng = globals.channellng != 0.0 ? globals.channellng : globals.Lng;
  double _acc = globals.channelacc != 0.0 ? globals.channelacc : globals.Accuracy;

  void setStateGeo() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    globals.channellat = position.latitude;
    globals.channellng = position.longitude;
    globals.channelacc = position.accuracy;
    setState(() => {
      _lat = globals.channellat,
      _lng = globals.channellng,
      _acc = globals.channelacc
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.red[800],
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  globals.channelTag='';
                  globals.channelTagId=0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShopAction()),
                  );
                }),
            title: Text(
              globals.OutletName,
              style: TextStyle(
                  fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Next",
                  style: TextStyle(
                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if(globals.channelTag == ''){
                    Flushbar(
                      messageText: Column(
                        children: <Widget>[
                          Text(
                            "Please Select Channel Tag",
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
                    )..show(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Please Select Channel Tag')));
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChannelTaggingImage()),
                    );

                  }

                },
              ),
            ]
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
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Outlet Information",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18),
                                ))),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Container(

                                  // height: 235,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 0, 5.0),
                                                child: Text(
                                                  "Outlet : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 0, 5.0),
                                                child: Text(
                                                  globals.OutletID.toString() +
                                                      "-" +
                                                      globals.OutletName,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Location",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18),
                                                ))),
                                        Divider(
                                          height: 1,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        5.0, 10.0, 0, 5.0),
                                                    child: Text(
                                                      "Sub Channel ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.bold),
                                                    )),
                                                Container(
                                                  child: Center(
                                                    child: (globals.channelTag == "")
                                                        ? ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ChannelTaggingList()),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        minimumSize:
                                                        Size(100.0, 40.0),
                                                        padding:
                                                        EdgeInsets.fromLTRB(
                                                            5.0,
                                                            5.0,
                                                            5.0,
                                                            5.0),
                                                        //<-- SEE HERE
                                                        // side: BorderSide(
                                                        //   width: 1.0,
                                                        // ),
                                                      ),
                                                      child: Text(
                                                        'Select Channel Tagging',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                        ),
                                                      ),
                                                    )
                                                        :
                                                    Row(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(
                                                                5.0, 10.0, 0, 5.0),
                                                            child: Text(
                                                              globals.channelTag ,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.black54,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ]
                                                    ),



                                                  ),

                                                ),


                                                // color: Colors.greenAccent,
                                              ]),
                                        ),

                                        Row(
                                            children: [
                                              Center(
                                                  child: (globals.channelTag != "")
                                                      ? ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChannelTaggingList()),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                      Size(100.0, 40.0),
                                                      padding:
                                                      EdgeInsets.fromLTRB(
                                                          5.0,
                                                          5.0,
                                                          5.0,
                                                          5.0),
                                                      //<-- SEE HERE
                                                      // side: BorderSide(
                                                      //   width: 1.0,
                                                      // ),
                                                    ),
                                                    child: Text(
                                                      'Change Channel Tagging',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  )
                                                      : Container()



                                              ),
                                            ]
                                        ),

                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 15.0, 0, 5.0),
                                                width: 110.0,
                                                child: Text(
                                                  "Existing Sub Channel ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 15.0, 0, 5.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Row(children: [
                                                  Text(
                                                    globals.PCI_Channel_Lable,
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ]),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 15.0, 0, 5.0),
                                                width: 110.0,
                                                child: Text(
                                                  "Latitude ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 15.0, 0, 5.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Row(children: [
                                                  Text(
                                                    _lat.toString(),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ]),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 15.0, 0, 5.0),
                                                width: 110.0,
                                                child: Text(
                                                  "Longitude ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 15.0, 0, 5.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Row(children: [
                                                  Text(
                                                    _lng.toString(),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ]),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 15.0, 0, 5.0),
                                                width: 110.0,
                                                child: Text(
                                                  "Accuracy ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 15.0, 0, 5.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Row(children: [
                                                  Text(
                                                    _acc.toString(),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ]),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ))),
                          ],
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setStateGeo();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200.0, 40.0),
                              padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              //<-- SEE HERE
                              // side: BorderSide(
                              //   width: 1.0,
                              // ),
                            ),
                            child: Text(
                              'Get Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        )
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

final ButtonStyle flatButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
