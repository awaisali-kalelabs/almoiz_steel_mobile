/*import 'package:camera/camera.dart';*/
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:order_booker/com/pbc/dao/repository.dart';
/*import 'package:order_booker/delivery.dart';*/
import 'package:order_booker/gauge_segment.dart';



import 'MarketVisitStart.dart';
import '../globals.dart' as globals;
import '../globals.dart';
import '../home_user.dart';
import 'shopActionMarketVisit.dart';

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

  List<Map<String, dynamic>> MV_Outlets;
  int navigate = 0;

  String radioButtonItem = 'ONE';

  // Group Value for Radio Button.
  //int globals.isAlternative = 1;

  @override
  Future<void> initState()  {
    super.initState();

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

    MV_Outlets = new List();

     repo
        .getPreSellOutletsByIsVisible1(weekday , globals.PJPID)
        .then((val) {
      setState(() {
        MV_Outlets = val;
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

/*
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
*/

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("not navigating PRESELL"); // Do some stuff.
    //work here
    return true;
  }

  Widget _getOutletsList(BuildContext context, int index) {
    var color = Colors.white;
    if (MV_Outlets[index]['visit_type'] == 1) {
      color = Colors.green[100];
    } else if (MV_Outlets[index]['visit_type'] == 2) {
      color = Colors.orange[100];
    }
    return Column(
      children: <Widget>[
        index == 0 ? Container() : Divider(),
        Container(
          color: color,
          child: ListTile(
            enabled: MV_Outlets[index]['is_delivered'] == 1 ? false : true,
            onTap: () async {
              showLeadingIcon = true;
              showSecondSection = false;
              print( "outlet_id====>>>>>>"+MV_Outlets[index]['outlet_id']);
              print( "Lat====>>>>>>"+Lat.toString());
              globals.OutletID = int.parse(MV_Outlets[index]['outlet_id']);
              globals.OutletAddress = MV_Outlets[index]['outlet_name'];
              globals.OutletName = MV_Outlets[index]['outlet_address'];
              globals.OutletNumber = MV_Outlets[index]['pjp_label'];
              globals.OutletOwner = MV_Outlets[index]['owner_name'];
              globals.Lat = double.parse(MV_Outlets[index]['lat']);
              globals.Lng = double.parse(MV_Outlets[index]['lng']);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShopAction()),
              );

              // await repo
              //     .deleteAllIncompleteOrder(MV_Outlets[index]['outlet_id']);


            },
            trailing: Container(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                ],
              ),
            ),
            title: Text(
                MV_Outlets[index]['outlet_id'].toString() +
                    " - " +
                    MV_Outlets[index]['outlet_name'],
                style: new TextStyle(fontSize: 16)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(MV_Outlets[index]['outlet_address'],
                    style: new TextStyle(fontSize: 16)),


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
          MaterialPageRoute(builder: (context) => HomeUser()),
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
                        MaterialPageRoute(builder: (context) => HomeUser()),
                      );
                    }),
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
                          Container(
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
                                      .getPreSellOutletsByIsVisible1(
                                      weekday,
                                    PJPID
                                     )
                                      .then((value) {
                                    setState(() {
                                      MV_Outlets = value;
                                      print(MV_Outlets);
                                    });
                                  });

                                  print("isSelected" + isSelected.toString());
                                  print(isSelected[index]);
                                });
                              },
                              isSelected: isSelected,
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
                                          .getPreSellOutletsByIsVisible1(weekday,
                                          PJPID,)
                                          .then((val) {
                                        setState(() {
                                          MV_Outlets = val;
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
                                                itemCount: MV_Outlets != null
                                                    ? MV_Outlets.length
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

