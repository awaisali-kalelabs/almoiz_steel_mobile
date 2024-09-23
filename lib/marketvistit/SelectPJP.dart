/*import 'package:camera/camera.dart';*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:order_booker/com/pbc/dao/repository.dart';

import 'MarketVistOutlets.dart';
import '../globals.dart' as globals;
import '../home.dart';
import '../home_user.dart';
import '../home_user.dart';

class BeatPlan extends StatefulWidget {
  BeatPlan() {}

  @override
  _BeatPlan createState() => _BeatPlan();
}

class _BeatPlan extends State<BeatPlan> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  int _selectedArea;
  int _selectedSubArea;
  String PJPID;

/*  final TextEditingController PJP =
  TextEditingController();*/


  Repository repo = new Repository();
  List<Map<String, dynamic>> PJP_MarketVisit;
  List<Map<String, dynamic>> OutletAreas;
  List<Map<String, dynamic>> ProductsCatgories;
  List<Map<String, dynamic>> ProductsPrice;
  List<DropdownMenuItem> PJPList = new List();
  List<Map<String, dynamic>> allRequests;
  int currentPJP ;
  List<String> text = ["Owner is Purchaser"];
  bool _isChecked = false;
  String _currText = '';
  _OutletRegisteration() {}

 void GetPJPS()  async {

   print("globals.PJPID:::>"+globals.PJPID);
   if(globals.PJPID != null){
     currentPJP=int.tryParse(globals.PJPID);
     print(currentPJP);

   }

    print("Current Pjp:::>"+currentPJP.toString());

  await repo.getpjp(
  globals.Cities).then((val) {
  setState(() {
  allRequests = val.cast<Map<String, dynamic>>();
  });
  print('allRequests: '+allRequests.toString());
  });



    for(int i=0; i < allRequests.length; i++){
      if (allRequests[i]["id"].toString() != "0") {
        print("Pjp is been added");
        // allRequests[i]["id"];
        PJPList.add(DropdownMenuItem(
            value: int.parse(allRequests[i]["id"].toString()),
            child: Text(allRequests[i]["label"])));
      }
    }
    print('allRequests=====>'+allRequests.toString());
    print('PJPList"::::::::>'+PJPList.toString());

  }



  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    PJP_MarketVisit = new List();

    repo.getPJPforMarketVisit().then((val) {
      setState(() {
        PJP_MarketVisit = val.cast<Map<String, dynamic>>();
      });
    });

    GetPJPS();
    // allRequests =  repo.getpjp(
    //     globals.Cities ) as List<Map<String, dynamic>> ;


   /* if(globals.PJPLabel != null){
      setState(() {
        PJP.text = globals.PJPLabel;

      });

    }*/

    repo.getOutletAreas().then((val) {
      setState(() {
        OutletAreas = val;
      });
    });

    myFocusNode = FocusNode();

    globals.startContinuousLocations(context);
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.


    return true;
  }


  FocusNode myFocusNode;

  bool isLocationTimedOut = false;


  final focus = FocusNode();
  double dynamicheight = 1.6;

  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    String selected;
    return Scaffold(
        backgroundColor: Colors.white,
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
          actions: [

          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: (Column(
                            children: [

                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                                  child: DropdownButtonFormField(
                                       value: currentPJP != null ? currentPJP : null,
                                      decoration: InputDecoration(
                                        labelText: 'PJP',
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          currentPJP = newValue;
                                          globals.PJPID =newValue.toString();
                                          print("newValue:----->"+newValue.toString());
                                          // allRequests = allRequests;
                                        });
                                        // GetPJPs();
                                      },
                                      items: PJPList,
                                      )),
                              /*Container(
                                // width: cardWidth,
                                  padding: EdgeInsets.all(5.0),
                                  child: TypeAheadFormField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      decoration: InputDecoration(
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black12, width: 0.0),
                                        ),
                                        labelText: 'Select PJP',
                                      ),
                                      controller: this.PJP,
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return await repo.getpjp(
                                          "%" + pattern + "%" ,   globals.Cities );
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        leading: Text(
                                          '${suggestion['id'] + "" +suggestion['label']}',
                                        ),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      this.PJP.text = suggestion['label'];
                                      this.PJPID = suggestion['id'];
                                      FocusScope.of(context).requestFocus(focus);
                                    },
                                    validator: (value) => value.isEmpty
                                        ? 'Please select PJP'
                                        : null,
                                    onSaved: (value) => () {},
                                  )),*/
                              ElevatedButton(
                                child: Text('Show Outlets',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  //print("id===>"+PJPID);
                                  //print(PJP);
                                 // globals.PJPID = PJPID;
                                 // globals.PJPLabel = PJP.text;
                                //  globals.stopContinuousLocation();
                                   if (_formKey.currentState.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
                                    );
                                  }else{
                                     print("aaa");
                                  }


                                  // if (_formKey.currentState.validate()) {
                                  //   int isOwnerPurchaser = 0;
                                  //   if (_isChecked) {
                                  //     isOwnerPurchaser = 1;
                                  //   }
                                  //   List args = new List();
                                  //
                                  //   args.add({
                                  //     'outlet_name': outletNameController.text,
                                  //     'mobile_request_id': globals.getUniqueMobileId(),
                                  //     'mobile_timestamp': globals.getCurrentTimestamp(),
                                  //     'channel_id': this._selectedChannelArea,
                                  //     'area_label': _AreatypeAheadController.text,
                                  //     'sub_area_label': _SubAreatypeAheadController.text,
                                  //     'address': addressController.text,
                                  //     'owner_name': ownerNameController.text,
                                  //     'owner_cnic': cnicController.text,
                                  //     'owner_mobile_no': mobileNoController.text,
                                  //     'purchaser_name': ownerPurchaseController.text,
                                  //     'purchaser_mobile_no': mobileNumberPurchaserController.text,
                                  //     'is_owner_purchaser': isOwnerPurchaser,
                                  //     'lat': LatController.text,
                                  //     'lng': LongController.text,
                                  //     'accuracy': AccuracyController.text,
                                  //     'created_on': globals.getCurrentTimestamp(),
                                  //     'created_by': globals.UserID,
                                  //     'is_uploaded': 0
                                  //   });
                                  //
                                  //   _registerOutlet(context, args);
                                  // } else {}
                                },
                              ),




                              // Expanded(
                              //alignment: Alignment.bottomRight,
                              //  flex: 1,
                              //   child:





                            ],
                          ))),
                    ],
                  ),
                ),
              ],
            )));
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
                      MaterialPageRoute(builder: (context) => HomeUser()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeUser()));
                }
              },
            ),
          ],
        );
      },
    );
  }
}


