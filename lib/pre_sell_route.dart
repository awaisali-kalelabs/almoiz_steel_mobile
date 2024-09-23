/*import 'package:camera/camera.dart';*/
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:order_booker/com/pbc/dao/repository.dart';
/*import 'package:order_booker/delivery.dart';*/
import 'package:order_booker/gauge_segment.dart';
import 'package:order_booker/outlet_location.dart';
import 'package:order_booker/shopAction.dart';
/*import 'package:order_booker/take_images.dart';*/
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart' as globals;
import 'globals.dart';
import 'home.dart';
import 'merchandising.dart';

// This app is a stateful, it tracks the user's current choice.
class PreSellRoute extends StatefulWidget {
  int DispatchID;

  PreSellRoute(DispatchID) {
    this.DispatchID = DispatchID;

    print(DispatchID);
  }
  @override
  _PreSellRoute createState() => _PreSellRoute(DispatchID);
}

class _PreSellRoute extends State<PreSellRoute> {
  int DispatchID;

  String selected;
  int weekday;
  int today;
  int isVisible;

  final searchController = TextEditingController();
  String _SelectFerightTerms;
  _PreSellRoute(DispatchID) {
    this.DispatchID = DispatchID;
  }
  Repository repo = new Repository();
  List Days = new List();

  List<bool> isSelected = [false, false, false, false, false, false, false];

  List<Map<String, dynamic>> PreSellOutlets;
  int navigate = 0;

  String radioButtonItem = 'ONE';

  // Group Value for Radio Button.
  //int globals.isAlternative = 1;

  bool isOutletIdInList(int outletId) {
    List<int> outletIdsList = [
      103101572,
      103101634,
      103100646,
      103100582,
      103101853,
      103102164,
      103103002,
      103102060,
      103101022,
      103103026,
      103100197,
      103101014,
      103101193,
      103101984,
      103100723,
      103100309,
      103102319,
      103103117,
      103100918,
      103103033,
      103101692,
      103102679,
      103102400,
      111100095,
      111101077,
      111101086,
      111100392,
      111100105,
      111100853,
      111101395,
      111101359,
      111101002,
      111101003,
      111100952,
      111100715,
      107100204,
      107101452,
      107100942,
      107101111,
      107100842,
      107101241,
      107101256,
      107100939,
      107100886,
      107100063,
      107100061,
      140102959,
      140102960,
      140100279,
      140100137,
      140102660,
      140102545,
      140105476,
      140102991,
      140102702,
      140102970,
      140104893,
      140100499,
      140104846,
      140100553,
      140100555,
      140104573,
      140100592,
      140100501,
      140104361,
      140102646,
      140101582,
      127111358,
      127112803,
      127113667,
      127111345,
      127112660,
      127111280,
      127113732,
      127111268,
      127113779,
      127111378,
      127111377,
      127113275,
      127112418,
      127111368,
      127111374,
      127111369,
      127112637,
      127112636,
      127112700,
      127111504,
      127112670,
      127112699,
      127112648,
      127111545,
      127112404,
      127111720,
      140100431,
      140102037,
      127111538,
      127112413,
      127109858,
      127112402,
      127111543,
      137105482,
      137102642,
      137105758,
      137100015,
      137104852,
      137101369,
      137100331,
      137102016,
      137105243,
      137105593,
      137106305,
      137105239,
      137104941,
      137103320,
      137104759,
      138101359,
      138100992,
      138101145,
      138101206,
      138101276,
      138101286,
      138101071,
      138101163,
      122104906,
      122104489,
      122104528,
      122104746,
      122104884,
      122103485,
      122104433,
      122104806,
      122105074,
      122104491,
      122104547,
      122103656,
      137104869,
      137105705,
      137102284,
      137102044,
      142100614,
      142100780,
      137104278,
      137106996,
      137104417,
      137104508,
      137104297,
      137104381,
      137103160,
      137102888,
      137104688,
      128109004,
      128108693,
      128108864,
      128108114,
      128107463,
      128108055,
      128108054,
      128107505,
      128108052,
      128112111,
      128112304,
      128112071,
      128112099,
      128112119,
      128107212,
      128107145,
      128109451,
      128100734,
      128107137,
      128111226,
      128110224,
      128110608,
      128107119,
      128107118,
      128100365,
      128102363,
      128101943,
      128111881,
      128111968,
      128111689,
      128111828,
      128106867,
      128107658,
      128110161,
      128110079,
      128110878,
      128106967,
      128107983,
      128107014,
      128105543,
      128105545,
      128109037,
      128107999,
      128110284,
      128110903,
      128111011,
      128111516,
      128108124,
      128101740,
      128105471,
      105100194,
      105100058,
      105100591,
      105100729,
      105100560,
      105100500,
      105100806,
      105100802,
      105100006,
      105100809,
      105101112,
      121100357,
      121100508,
      121100465,
      121100180,
      121100481,
      101101246,
      101101303,
      100106710,
      101101214,
      100100176,
      101101274,
      100100343,
      101101222,
      100104238,
      100105753,
      100106686,
      101101397,
      100105208,
      100106684,
      102101203,
      102101209,
      102101498,
      102101143,
      102101140,
      102101141,
      102101805,
      102101890,
      102101799,
      102101799,
      118118777,
      118117940,
      118122783,
      118117922,
      118101930,
      118123447,
      118123686,
      118123443,
      118119141,
      118120142,
      118121909,
      118121570,
      118124515,
      118105850,
      118124795,
      118105055,
      118124793,
      118105141,
      118116209,
      118116210,
      118124067,
      118120589,
      118120049,
      105100494,
      121100599
    ];

    return outletIdsList.contains(outletId);
  }

  @override
  void initState() {
    super.initState();
    if(globals.Is_Daily == 1){
      globals.IsDaily = false;
    }else{
      globals.IsDaily = true;
    }
    BackButtonInterceptor.add(myInterceptor);
    globals.stopContinuousLocation();
    if (DispatchID == 0) {
      DispatchID = globals.DispatchID;
    }
    //PreSellOutlets=new List();

    Repository repo = new Repository();
    //weeK DAY to be Placed
    weekday = globals.WeekDay;
    isVisible = 1;
    today = globals.getPBCDayNumber(DateTime.now().weekday);

    PreSellOutlets = new List();

    repo
        .getPreSellOutletsByIsVisible(weekday, "%%", globals.isAlternative)
        .then((val) {
      setState(() {
        PreSellOutlets = val;
        _SelectFerightTerms = weekday.toString();
      });
    });

    print("WEEK DAY IS" + weekday.toString());
    if (weekday > 0) {
      isSelected[weekday - 1] = true;
    } else {
      isSelected[0] = true;
    }
    if (navigate == 1) {}
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("not navigating PRESELL"); // Do some stuff.
    //work here
    return true;
  }

//CheckVisit
  Widget _getOutletsList(BuildContext context, int index) {
    var color = Colors.white;
    if (PreSellOutlets[index]['visit_type'] == 1) {
      color = Colors.green[100];
    } else if (PreSellOutlets[index]['visit_type'] == 2) {
      color = Colors.orange[100];
    } else if (PreSellOutlets[index]['visit_type'] == 3) {
      color = Colors.purple[100];
    } else if (PreSellOutlets[index]['visit_type'] == 4) {
      color = Colors.red[100];
    }
    return Column(
      children: <Widget>[
        index == 0 ? Container() : Divider(),
        Container(
          color: color,
          child: ListTile(
            enabled: PreSellOutlets[index]['is_delivered'] == 1 ? false : true,
            onTap: () async {
              showLeadingIcon = true;
              showSecondSection = false;
              ShowDistance = false;
              globals.OutletID = PreSellOutlets[index]['outlet_id'];
              globals.OutletAddress = PreSellOutlets[index]['address'];
              globals.OutletName = PreSellOutlets[index]['outlet_name'];
              globals.OutletNumber = PreSellOutlets[index]['telephone'];
              globals.OutletOwner = PreSellOutlets[index]['owner'];
              globals.Lat = double.parse(PreSellOutlets[index]['lat']);
              globals.Lng = double.parse(PreSellOutlets[index]['lng']);
              globals.VisitType =
                  int.parse(PreSellOutlets[index]['visit_type'].toString());
              globals.PciChannelID =
                  int.parse(PreSellOutlets[index]['pci_channel_id'].toString());
              globals.PCI_Channel_Lable =
                  PreSellOutlets[index]['channel_label'].toString();
              globals.order_created_on_date =
                  PreSellOutlets[index]['order_created_on_date'];
              await repo
                  .deleteAllIncompleteOrder(PreSellOutlets[index]['outlet_id']);

              Navigator.push(
                context,
                //
                MaterialPageRoute(builder: (context) => ShopAction()
                    // MaterialPageRoute(builder: (context) => Merchandising()
                    //  MaterialPageRoute(builder: (context) =>ShopAction_test()

                    ),
              );
            },
            trailing: Container(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.directions, color: Colors.green),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OutletLocation(
                                    address: PreSellOutlets[index]['address']
                                        .toString(),
                                    name: PreSellOutlets[index]['outlet_name']
                                        .toString(),
                                    lat: double.parse(
                                        PreSellOutlets[index]['lat']),
                                    lng: double.parse(
                                        PreSellOutlets[index]['lng']),
                                  )),
                        );
                      }),
                  IconButton(
                      icon: Icon(Icons.phone, color: Colors.green),
                      onPressed: () async {
                        var url = "tel:" +
                            PreSellOutlets[index]['telephone'].toString();
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }),
                ],
              ),
            ),
            title: Text(
              PreSellOutlets[index]['outlet_id'].toString() +
                  " - " +
                  PreSellOutlets[index]['outlet_name'],
              style: TextStyle(
                fontSize: 16,
                color: isOutletIdInList(PreSellOutlets[index]['outlet_id'])
                    ? Colors.green
                    : Colors.black,
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(PreSellOutlets[index]['address'],
                    style: new TextStyle(fontSize: 16)),
                PreSellOutlets[index]['area_label'] != null
                    ? Text(
                        PreSellOutlets[index]['area_label'] +
                            ", " +
                            PreSellOutlets[index]['sub_area_label'],
                        style: new TextStyle(fontSize: 16))
                    : Container(),
                /*Text('Rs. '+
                    PreSellOutlets[index]['net_amount'].toString() + "",
                    style: new TextStyle(fontSize: 16))*/
              ],
            ),
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
    return WillPopScope(
        onWillPop: () async => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            ),
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[800],
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    }),
                actions: [
                  Visibility(
                    visible : IsDaily,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: globals.isAlternative,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            setState(() {
                              globals.isAlternative = 1;
                            });
                            repo
                                .getPreSellOutletsByIsVisible(weekday,
                                    searchController.text, globals.isAlternative)
                                .then((value) {
                              setState(() {
                                PreSellOutlets = value;
                                print(PreSellOutlets);
                              });
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              globals.isAlternative = 1;
                            });
                            repo
                                .getPreSellOutletsByIsVisible(weekday,
                                    searchController.text, globals.isAlternative)
                                .then((value) {
                              setState(() {
                                PreSellOutlets = value;
                                print(PreSellOutlets);
                              });
                            });
                          },
                          child: Text(
                            'This Week',
                            style: new TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          width: 5,
                        ),
                        Radio(
                          value: 0,
                          groupValue: globals.isAlternative,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            setState(() {
                              globals.isAlternative = 0;
                            });
                            repo
                                .getPreSellOutletsByIsVisible(weekday,
                                    searchController.text, globals.isAlternative)
                                .then((value) {
                              setState(() {
                                PreSellOutlets = value;
                                print(PreSellOutlets);
                              });
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              globals.isAlternative = 0;
                            });
                            repo
                                .getPreSellOutletsByIsVisible(weekday,
                                    searchController.text, globals.isAlternative)
                                .then((value) {
                              setState(() {
                                PreSellOutlets = value;
                                print(PreSellOutlets);
                              });
                            });
                          },
                          child: Text(
                            'Last Week',
                            style: new TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          width: 5,
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
                          Visibility(
                      visible : IsDaily,
                            child: Container(
                              color: Colors.black26,
                              child: ToggleButtons(
                                children: <Widget>[
                                  Text("Su"),
                                  Text("M"),
                                  Text("T"),
                                  Text("W"),
                                  Text("Th"),
                                  Text("F"),
                                  Text("S"),
                                ],
                                color: Colors.white,
                                selectedColor: Colors.white,
                                fillColor: Colors.green,
                                focusColor: Colors.green,
                                splashColor: Colors.lightBlueAccent,
                                highlightColor: Colors.grey,
                                borderColor: Colors.white,
                                borderWidth: 2,
                                selectedBorderColor: Colors.white,
                                onPressed: (int index) {
                                  setState(() {
                                    for (int i = 0; i < 7; i++) {
                                      if (i == index) {
                                        isSelected[i] = true;
                                      } else {
                                        isSelected[i] = false;
                                      }
                                    }
                                    weekday = index + 1;
                                    globals.WeekDay = weekday;
                                    print(weekday.toString() +
                                        ":" +
                                        today.toString());
                                    if (weekday != today) {
                                      setState(() {
                                        isVisible = -1;
                                      });
                                    } else {
                                      setState(() {
                                        isVisible = 1;
                                      });
                                    }
                                    print(weekday);
                                    repo
                                        .getPreSellOutletsByIsVisible(
                                            weekday,
                                            searchController.text,
                                            globals.isAlternative)
                                        .then((value) {
                                      setState(() {
                                        PreSellOutlets = value;
                                        print(PreSellOutlets);
                                      });
                                    });

                                    print("isSelected" + isSelected.toString());
                                    print(isSelected[index]);
                                  });
                                },
                                isSelected: isSelected,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                // width: cardWidth,
                                padding: EdgeInsets.all(5.0),
                                child: TextField(
                                    controller: searchController,
                                    autofocus: false,
                                    onChanged: (val) {
                                      if (val.isEmpty) {
                                        setState(() {
                                          isVisible = 1;
                                        });
                                      } else {
                                        setState(() {
                                          isVisible = -1;
                                        });
                                      }
                                      repo
                                          .getPreSellOutletsByIsVisible(weekday,
                                              val, globals.isAlternative)
                                          .then((val) {
                                        setState(() {
                                          PreSellOutlets = val;
                                        });
                                      });
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black12, width: 0.0),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search_sharp,
                                      ),
                                      labelText: 'Search',
                                    )),
                              ),
                              Container(
                                //  width: cardWidth,
                                child: Card(
                                  child: Container(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Flexible(
                                          child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemCount: PreSellOutlets != null
                                            ? PreSellOutlets.length
                                            : 0,
                                        itemBuilder: _getOutletsList,
                                      )),
                                    ],
                                  )),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ])),
        ));
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

void main() {
  runApp(PreSellRoute(1));
}
