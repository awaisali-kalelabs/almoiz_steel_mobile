/*import 'package:camera/camera.dart';*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:order_booker/com/pbc/dao/repository.dart';

import 'globals.dart' as globals;
import 'home.dart';
import 'outlet_registration_image.dart';

class OutletRegisteration extends StatefulWidget {
  OutletRegisteration() {}

  @override
  _OutletRegisteration createState() => _OutletRegisteration();
}

class _OutletRegisteration extends State<OutletRegisteration> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  int _selectedArea;
  int _selectedSubArea;
  int _selectedChannelArea;

  final TextEditingController _ChanneltypeAheadController =
      TextEditingController();
  final TextEditingController _AreatypeAheadController =
      TextEditingController();

  final TextEditingController _SubAreatypeAheadController =
      TextEditingController();

  Repository repo = new Repository();
  List<Map<String, dynamic>> PCIChannels;
  List<Map<String, dynamic>> OutletAreas;
  List<Map<String, dynamic>> ProductsCatgories;
  List<Map<String, dynamic>> ProductsPrice;

  List<String> text = ["Owner is Purchaser"];
  bool _isChecked = false;
  String _currText = '';
  _OutletRegisteration() {}

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    PCIChannels = new List();
    repo.getPCIChannels().then((val) {
      setState(() {
        PCIChannels = val;
      });
    });

    repo.getOutletAreas().then((val) {
      setState(() {
        OutletAreas = val;
      });
    });

    myFocusNode = FocusNode();

     globals.startContinuousLocation(context);
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
  TextEditingController outletNameController = TextEditingController();
  TextEditingController channelController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController subAreaController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController ownerPurchaseController = TextEditingController();
  TextEditingController mobileNumberPurchaserController =
      TextEditingController();

  TextEditingController LatController = TextEditingController();
  TextEditingController LongController = TextEditingController();
  TextEditingController AccuracyController = TextEditingController();

  FocusNode myFocusNode;

  bool islocationGet = false;
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
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }),
          actions: [
            ElevatedButton(
              child: Text('Next',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                globals.stopContinuousLocation();
                if (islocationGet == false) {
                  _showDialog("Error", "Please get GPS Location", 0);
                  return false;
                }

                if (_formKey.currentState.validate()) {
                  int isOwnerPurchaser = 0;
                  if (_isChecked) {
                    isOwnerPurchaser = 1;
                  }
                  List args = new List();

                  args.add({
                    'outlet_name': outletNameController.text,
                    'mobile_request_id': globals.getUniqueMobileId(),
                    'mobile_timestamp': globals.getCurrentTimestamp(),
                    'channel_id': this._selectedChannelArea,
                    'area_label': _AreatypeAheadController.text,
                    'sub_area_label': _SubAreatypeAheadController.text,
                    'address': addressController.text,
                    'owner_name': ownerNameController.text,
                    'owner_cnic': cnicController.text,
                    'owner_mobile_no': mobileNoController.text,
                    'purchaser_name': ownerPurchaseController.text,
                    'purchaser_mobile_no': mobileNumberPurchaserController.text,
                    'is_owner_purchaser': isOwnerPurchaser,
                    'lat': LatController.text,
                    'lng': LongController.text,
                    'accuracy': AccuracyController.text,
                    'created_on': globals.getCurrentTimestamp(),
                    'created_by': globals.UserID,
                    'is_uploaded': 0
                  });

                  _registerOutlet(context, args);
                } else {}
              },
            ),
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
                            // width: cardWidth,
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              controller: outletNameController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              //readOnly: true,
                              autofocus: true,
                              onChanged: (val) {},
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 0.0),
                                ),
                                labelText: 'Outlet Name',
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter a outlet name. ';
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                              // width: cardWidth,
                              padding: EdgeInsets.all(5.0),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black12, width: 0.0),
                                    ),
                                    labelText: 'Channel',
                                  ),
                                  controller: this._ChanneltypeAheadController,
                                ),
                                suggestionsCallback: (pattern) async {
                                  return await repo.getChannelSuggestions(
                                      "%" + pattern + "%");
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    leading: Text(
                                      '${suggestion['label']}',
                                    ),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  this._ChanneltypeAheadController.text =
                                      suggestion['label'];
                                  this._selectedChannelArea = suggestion['id'];
                                  FocusScope.of(context).requestFocus(focus);
                                },
                                validator: (value) => value.isEmpty
                                    ? 'Please select a channel'
                                    : null,
                                onSaved: (value) => () {},
                              )),
                          Container(
                              // width: cardWidth,
                              padding: EdgeInsets.all(5.0),
                              child: TextFormField(
                                focusNode: focus,
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 0.0),
                                  ),
                                  labelText: 'Area',
                                ),
                                autofocus: false,
                                onChanged: (val) {},
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: this._AreatypeAheadController,
                                validator: (value) => value.isEmpty
                                    ? 'Please enter an area'
                                    : null,
                              )),
                          Container(
                              // width: cardWidth,
                              padding: EdgeInsets.all(5.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 0.0),
                                  ),
                                  labelText: 'Sub Area',
                                ),
                                autofocus: false,
                                onChanged: (val) {},
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: this._SubAreatypeAheadController,
                                validator: (value) => value.isEmpty
                                    ? 'Please enter a sub area'
                                    : null,
                              )),
                          Container(
                            // width: cardWidth,
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              autofocus: false,
                              onChanged: (val) {},
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              controller: addressController,
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 0.0),
                                ),
                                labelText: 'Address',
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter address.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            // width: cardWidth,
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              autofocus: false,
                              //   readOnly: true,
                              onChanged: (val) {},
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              controller: ownerNameController,
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 0.0),
                                ),
                                labelText: 'Owner Name',
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter owner name.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            // width: cardWidth,
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              autofocus: false,
                              maxLength: 11,
                              onChanged: (val) {},
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: mobileNoController,
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 0.0),
                                ),
                                labelText: 'Mobile No',
                              ),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter mobile number.';
                                } else if (val.length < 8 || val.length > 11) {
                                  return 'Please enter a valid mobile number.';
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            // width: cardWidth,
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              autofocus: false,
                              maxLength: 13,
                              //  readOnly: true,
                              onChanged: (val) {},
                              //keyboardType: Text  InputType.number,
                              textInputAction: TextInputAction.next,
                              controller: cnicController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 0.0),
                                ),
                                labelText: 'CNIC No',
                              ),
                              validator: (val) {
                                if (!val.isEmpty && val.length < 13) {
                                  return 'Please enter a valid mobile number.';
                                }

                                return null;
                              },
                            ),
                          ),
                          Container(
                              color: Colors.grey[100],
                              // height: 350.0,
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  "Owner is Purchaser",
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: _isChecked,
                                onChanged: (val) {
                                  setState(() {
                                    _isChecked = val;

                                    if (_isChecked) {
                                      ownerPurchaseController.text =
                                          ownerNameController.text;
                                      mobileNumberPurchaserController.text =
                                          mobileNoController.text;
                                    } else {
                                      ownerPurchaseController.clear();
                                      mobileNumberPurchaserController.clear();
                                    }
                                  });
                                },
                              )),
                          Container(
                            // width: cardWidth,
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              autofocus: false,
                              //   readOnly: true,
                              onChanged: (val) {},
                              keyboardType: TextInputType.text,
                              controller: ownerPurchaseController,
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 0.0),
                                ),
                                labelText: 'Purchaser Name',
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter purchaser name.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            // width: cardWidth,
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              autofocus: false,
                              //  readOnly: true,
                              maxLength: 11,
                              onChanged: (val) {},
                              keyboardType: TextInputType.number,
                              controller: mobileNumberPurchaserController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12, width: 0.0),
                                ),
                                labelText: 'Purchaser Mobile No',
                              ),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter purchaser mobile number.';
                                } else if (val.length < 11) {
                                  return 'Please enter a valid purchaser mobile number.';
                                }

                                return null;
                              },
                            ),
                          ),
                          // Expanded(
                          //alignment: Alignment.bottomRight,
                          //  flex: 1,
                          //   child:
                          MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.green,
                              child: Text(
                                'Get GPS Location',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {


                                print("globals.currentPosition:"+globals.currentPosition.toString());
                                if(globals.currentPosition==null){
                                  Dialogs.showLoadingDialog(context, _keyLoader);
                                  globals
                                      .getCurrentLocation(context)
                                      .then((position1) {
                                    globals.currentPosition = position1;
                                    print(position1);
                                  })
                                      .timeout(Duration(seconds: 7), onTimeout: ((){
                                    print("i am here timedout");

                                    setState(() {
                                      isLocationTimedOut = true;
                                    });

                                  }))
                                      .whenComplete(() {
                                    if(isLocationTimedOut){

                                      LatController.text = "0";
                                      AccuracyController.text = "0";
                                      LongController.text = "0";
                                    }else{

                                      LatController.text = globals.currentPosition.latitude.toString();
                                      AccuracyController.text = globals.currentPosition.accuracy.toString();
                                      LongController.text = globals.currentPosition.longitude.toString();
                                    }

                                    setState(() {
                                      islocationGet = true;
                                      dynamicheight = 1.6;
                                      myFocusNode.requestFocus();
                                    });


                                    Navigator.of(context,
                                        rootNavigator: true)
                                        .pop();


                                  }).catchError((onError) {

                                    Navigator.of(context,
                                        rootNavigator: true)
                                        .pop();


                                    print("ERRROR" + onError.toString());
                                  });
                                }else{

                                  LatController.text = globals.currentPosition.latitude.toString();
                                  AccuracyController.text = globals.currentPosition.accuracy.toString();
                                  LongController.text = globals.currentPosition.longitude.toString();
                                  setState(() {
                                    islocationGet = true;
                                    dynamicheight = 1.6;
                                    myFocusNode.requestFocus();
                                  });
                                }

                              }),



                          Visibility(
                            visible: islocationGet,
                            child: Column(
                              children: [
                                Container(
                                  // width: cardWidth,
                                  padding: EdgeInsets.all(5.0),
                                  child: TextField(
                                      autofocus: false,
                                      readOnly: true,
                                      onChanged: (val) {},
                                      keyboardType: TextInputType.text,
                                      controller: LatController,
                                      decoration: InputDecoration(
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black12,
                                              width: 0.0),
                                        ),
                                        labelText: 'Latitude',
                                      )),
                                ),
                                Container(
                                  // width: cardWidth,
                                  padding: EdgeInsets.all(5.0),
                                  child: TextField(
                                      autofocus: false,
                                      readOnly: true,
                                      onChanged: (val) {},
                                      keyboardType: TextInputType.text,
                                      controller: LongController,
                                      decoration: InputDecoration(
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black12,
                                              width: 0.0),
                                        ),
                                        labelText: 'Longitiude',
                                      )),
                                ),
                                Container(
                                  // width: cardWidth,
                                  padding: EdgeInsets.all(5.0),
                                  child: TextField(
                                      autofocus: false,
                                      focusNode: myFocusNode,
                                      readOnly: true,
                                      onChanged: (val) {},
                                      keyboardType: TextInputType.text,
                                      controller: AccuracyController,
                                      decoration: InputDecoration(
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black12,
                                              width: 0.0),
                                        ),
                                        labelText: 'Accuracy',
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))),
                ],
              ),
            ),
          ],
        )));
  }


  Future _registerOutlet(context, List Items) async {
  //  Dialogs.showLoadingDialog(context, _keyLoader);
    await repo.registerOutlet(Items);
    // print("Items ID "+Items[0]['mobile_request_id'].toString());
    // print("Items LAT"+Items[0]['lat'].toString());
    // print("Items LNG"+Items[0]['lng'].toString());
    // print("Items ACC"+Items[0]['accuracy'].toString());
   // Navigator.of(context,rootNavigator: true).pop();
   // _OutletRegisterationUpload(context);
    globals.newOutletId = Items[0]['mobile_request_id'].toString();
    globals.newOutletLat = Items[0]['lat'].toString();
    globals.newOutletLng = Items[0]['lng'].toString();
    globals.newOutletAcc = Items[0]['accuracy'].toString();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OutletRegistrationImage()
      ),
    );
  //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OutletRegistrationImage()));
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
