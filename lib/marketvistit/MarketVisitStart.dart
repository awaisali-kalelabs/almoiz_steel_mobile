import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:order_booker/com/pbc/dao/repository.dart';
import 'package:order_booker/com/pbc/model/outlet_orders.dart';
import 'package:order_booker/marketvistit/shopActionMarketVisit.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'MVadd_to_cart.dart';
import 'MarketVistOutlets.dart';
import 'OrderMV.dart';
import 'SelectPJP.dart';
import '../globals.dart' as globals;

class Orders extends StatefulWidget {
  int outletId = 0;
  @override
  Orders({int outletId}) {
    this.outletId = outletId;
  }
  _OrdersState createState() => _OrdersState(outletId);
}

class _OrdersState extends State<Orders> {
  int outletId = 0;
  int totalAddedProducts = 0;
  double totalAmount = 0.0;
  bool isLocationTimedOut = false;

  _OrdersState(int outletId) {
    this.outletId = outletId;
  }

  int orderId = 0;
  int currentOrderId = 0;
  List<Map<String, dynamic>> Products;
  List<Map<String, dynamic>> ProductsLrbTypes;
  List<Map<String, dynamic>> ProductsCatgories;
  List<Map<String, dynamic>> ProductsPrice;
  List<Map<String, dynamic>> AllOrders;
  List<Map<String, dynamic>> AllOrdersItems;

  int selectedLRBMenuValue = 0;
  int selectedCategoryMenuValue = 0;
  List<bool> SelectedLRBType = new List();
  List<bool> SelectedCategories = new List();
  Repository repo = new Repository();
  TextEditingController rateController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  double priceRateAfterDiscount = 0.0;
  double priceRate = 0.0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    rateController.dispose();
    super.dispose();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    Products = new List();
    repo
        .getProducts(selectedLRBMenuValue, selectedCategoryMenuValue)
        .then((val) {
      setState(() {
        Products = val;
      });
    });

    repo.getProductsLrbTypes("%%").then((val) {
      setState(() {
        ProductsLrbTypes = val;
        for (int i = 0; i < ProductsLrbTypes.length; i++) {
          SelectedLRBType.add(false);
        }
      });
    });

    ProductsCatgories = new List();
    repo.getProductsSubCategories("%%").then((val) {
      setState(() {
        ProductsCatgories = val;

        for (int i = 0; i < ProductsCatgories.length; i++) {
          SelectedCategories.add(false);
        }
      });
    });

    getOrderNumber(outletId);
    getTotalOrders(outletId);
  }

  int getOrderNumber(int outletId) {
    AllOrders = new List();
    repo.getAllOrders(outletId, 0).then((val) {
      setState(() {
        AllOrders = val;
      });
      Position position = globals.currentPosition;
      print("Currentlocation "+globals.currentPosition.toString());
      if (AllOrders.length < 1) {
        List<OutletOrders> order = new List();
        var currDate = new DateTime.now();
        String currentDat = currDate.toString();
        var str2 = currentDat.split(".");

        var str = currDate.toString();
        str = str.replaceAll("-", "");
        str = str.replaceAll(" ", "");
        str = str.replaceAll(":", "");
        var mobileOrderstr = str.split(".");
        orderId = globals.getUniqueMobileId();
        OutletOrders orderobj = new OutletOrders(
            id: orderId,
            //id: globals.getUniqueMobileId(),
            outlet_id: outletId,
            //created_on: TimeStamp,
            uuid: "abc",
            is_completed: 0,
            is_uploaded: 0,
            total_amount: 0.0,
            lat: position.latitude,
            lng: position.longitude,
            accuracy: position.accuracy);
        order.add(orderobj);
        initiateOrder(order);
      } else {
        orderId = AllOrders[0]['id'];
      }
    });
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    var isOpen = _pc.isPanelOpen;
    if (isOpen) {
      _pc.close();
    }
  }

  int getTotalOrders(int outletId) {
    AllOrders = new List();
    repo.getAllOrders(outletId, 0).then((val) async {
      setState(() {
        AllOrders = val;
      });
      AllOrdersItems = new List();

    });
  }

  int lastSelectedLRBIndex = -1;
  bool lastLRBSelection = false;
  int lastSelectedSubCategoryIndex = -1;
  bool lastSubCategorySelection = false;
  Widget _getLRBTypeList(BuildContext context, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        index == 0 ? Container() : Divider(),
        ListTile(
          selected: SelectedLRBType[index],
          selectedTileColor: SelectedLRBType[index] ? Colors.green : Colors.white,
          focusColor: Colors.lightBlueAccent,
          onTap: () async {
            setState(() {
              //To reset Value
              selectedLRBMenuValue = 0;

              for (int i = 0; i < SelectedLRBType.length; i++) {
                SelectedLRBType[i] = false;
              }
              for (int i = 0; i < SelectedCategories.length; i++) {
                SelectedCategories[i] = false;
              }
              lastSelectedSubCategoryIndex = -1;
              lastSubCategorySelection = false;

              SelectedLRBType[index] = true;

              if (lastSelectedLRBIndex == index) {
                SelectedLRBType[index] = !lastLRBSelection;
                //SelectedLRBType[index]=false;
              }
              selectedLRBMenuValue = ProductsLrbTypes[index]['id'];
              if (SelectedLRBType[index] == false) {
                selectedLRBMenuValue = 0;
                selectedCategoryMenuValue = 0;
              }
            });

            ProductsCatgories = new List();
            //working here
            repo
                .getProductsSubCategoriesByCategoryId(selectedLRBMenuValue)
                .then((val) {
              setState(() {
                ProductsCatgories = val;

                for (int i = 0; i < ProductsCatgories.length; i++) {
                  SelectedCategories.add(false);
                }
              });
            });

            lastSelectedLRBIndex = index;
            lastLRBSelection = SelectedLRBType[index];
          },
          title: Text(ProductsLrbTypes[index]['label'].toString(),
              style: new TextStyle(
                  fontSize: 13,
                  color:
                  SelectedLRBType[index] ? Colors.white : Colors.blueGrey)),
        ),
      ],
    );
  }

  FocusNode _focus = new FocusNode();

  Widget _getLRBTypeList2(BuildContext context, int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        index == 0 ? Container() : Divider(),
        Row(
            children: [
            InkWell(
                focusColor:
                SelectedLRBType[index] ? Colors.lightBlue : Colors.white,
                highlightColor:
                SelectedLRBType[index] ? Colors.lightBlue : Colors.white,
                splashColor: Colors.lightBlue,
                onTap: () {
                  setState(() {
                    //To reset Value
                    selectedLRBMenuValue = 0;

                    for (int i = 0; i < SelectedLRBType.length; i++) {
                      SelectedLRBType[i] = false;
                    }
                    for (int i = 0; i < SelectedCategories.length; i++) {
                      SelectedCategories[i] = false;
                    }
                    lastSelectedSubCategoryIndex = -1;
                    lastSubCategorySelection = false;

                    SelectedLRBType[index] = true;

                    if (lastSelectedLRBIndex == index) {
                      SelectedLRBType[index] = !lastLRBSelection;
                      //SelectedLRBType[index]=false;
                    }
                    selectedLRBMenuValue = ProductsLrbTypes[index]['id'];
                  });

                  ProductsCatgories = new List();
                  //working here
                  repo
                      .getProductsSubCategoriesByCategoryId(
                      selectedLRBMenuValue)
                      .then((val) {
                    setState(() {
                      ProductsCatgories = val;

                      for (int i = 0; i < ProductsCatgories.length; i++) {
                        SelectedCategories.add(false);
                      }
                    });
                  });

                  lastSelectedLRBIndex = index;
                  lastLRBSelection = SelectedLRBType[index];
                },
                child: Text(
                  ProductsLrbTypes[index]['label'].toString(),
                  style: new TextStyle(
                      fontSize: 13,
                      color: SelectedLRBType[index]
                          ? Colors.white
                          : Colors.blueGrey),
                ))
          ],
        ),
      ],
    );
  }
  Future _UploadDocuments() async {
    print("_UploadDocuments called");
    List AllDocuments = new List();
    repo.getAllOutletImages(globals.orderId).then((val) async {
      setState(() {
        AllDocuments = val;
      });

    });
  }


  Future completeOrder(context) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    Position position = globals.currentPosition;
    if (position == null) {
      globals.getCurrentLocation(context).then((position1) {
        position = position1;
      }).whenComplete(() async {
        if (position != null || isLocationTimedOut) {
          if (isLocationTimedOut) {
            position = new Position(accuracy: 0, latitude: 0, longitude: 0);
          }
          print("position:" + position.toString());
          await repo.completeOrder(position.latitude, position.longitude,
              position.accuracy, globals.OutletID, globals.isSpotSale);
          await repo.setVisitType(globals.OutletID, 1);
          Navigator.of(context, rootNavigator: true).pop('dialog');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
              ModalRoute.withName("/PreSellRoute"));
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
                  new TextButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }

      });
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("position:" + position.toString());
      await repo.completeOrder(position.latitude, position.longitude,
          position.accuracy, globals.OutletID, globals.isSpotSale);
      await repo.setVisitType(globals.OutletID, 1);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PreSellRoute(2222)),
          ModalRoute.withName("/PreSellRoute"));
    }
  }
  final _formKey = GlobalKey<FormState>();
  Widget _getSubCategoirsList(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        index == 0 ? Container() : Divider(),
        ListTile(
          selected: SelectedCategories[index],
          selectedTileColor:
          SelectedCategories[index] ? Colors.green : Colors.white,
          focusColor: Colors.lightBlueAccent,
          onTap: () async {
            setState(() {
              //To reset value
              selectedCategoryMenuValue = 0;

              for (int i = 0; i < SelectedCategories.length; i++) {
                SelectedCategories[i] = false;
              }
              SelectedCategories[index] = true;
              if (lastSelectedSubCategoryIndex == index) {
                SelectedCategories[index] = !lastSubCategorySelection;
                //SelectedLRBType[index]=false;
              }
              selectedCategoryMenuValue = ProductsCatgories[index]['id'];
              if (!SelectedCategories[index]) {
                selectedCategoryMenuValue = 0;
              }
            });

            lastSelectedSubCategoryIndex = index;
            lastSubCategorySelection = SelectedCategories[index];
          },
          title: Text(ProductsCatgories[index]['label'].toString(),
              style: new TextStyle(
                  fontSize: 13,
                  color: SelectedCategories[index]
                      ? Colors.white
                      : Colors.blueGrey)),
        ),
      ],
    );
  }

  void initiateOrder(List<OutletOrders> order) {
    // repo.deleteAllUnUsedOrder(outlet_id);

    for (var i = 0; i < order.length; i++) {
      repo.initOrder(
          order[i].id,
          order[i].outlet_id,
          order[i].is_completed,
          order[i].is_uploaded,
          order[i].total_amount,
          order[i].uuid,
          order[i].created_on,
          order[i].lat,
          order[i].lng,
          order[i].accuracy);
    }
  }

  Future<void> addItemOrder(orderId, productId, productLabel) async {
    List Items = new List();
    List Itemss = new List();

    Items.add({
      'product_id': productId,
       'product_label': productLabel,
    });

    print(Items);
    repo.addItemToCurrentOrders(orderId, Items);
  }

  double getProductPrice(productId, outletId) {
    repo.getActiveProductPriceList(productId, outletId).then((val) async {
      setState(() {
        isQuantityNotAdded = false;
        amountController.text = "";
        quantityController.text = "";
        discountController.text = "";

      });

    });
  }

  bool isQuantityNotAdded = false;
  void _showDialog(int productId, String productLabel, int outletId) {
    getProductPrice(productId, outletId);

    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(10),
                child: Stack(
                  clipBehavior: Clip.none, alignment: Alignment.topCenter,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 1.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Text(productLabel),
                                  ),
                                  Container(
                                    // width: cardWidth,
                                    padding: EdgeInsets.all(5.0),
                                    child: TextField(
                                        controller: rateController,
                                        keyboardType: TextInputType.number,
                                        readOnly: true,
                                        autofocus: false,
                                        onChanged: (val) {},
                                        decoration: InputDecoration(
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black12,
                                                width: 0.0),
                                          ),
                                          labelText: 'Rate',
                                        )),
                                  ),
                                  Container(
                                    // width: cardWidth,
                                    padding: EdgeInsets.all(5.0),
                                    child: TextFormField(
                                        controller: discountController,
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        onChanged: (val) {
                                          //ToReset Value to intital
                                          priceRateAfterDiscount = priceRate;
                                          priceRateAfterDiscount = priceRate -
                                              double.parse(
                                                  discountController.text);
                                          if (int.parse(
                                              quantityController.text) !=
                                              0) {
                                            double amount = 0;
                                            double price = double.parse(
                                                quantityController.text) *
                                                priceRateAfterDiscount;
                                            amountController.text =
                                                price.toString();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black12,
                                                width: 0.0),
                                          ),
                                          labelText: 'Discount',
                                        )),
                                  ),
                                  Container(
                                    // width: cardWidth,
                                    padding: EdgeInsets.all(5.0),
                                    child: TextFormField(
                                        autofocus: true,
                                        onChanged: (val) {
                                          double price = double.parse(val) *
                                              priceRateAfterDiscount;
                                          amountController.text =
                                              price.toString();
                                        },
                                        validator: (val) {
                                          if (val == null ||
                                              val.isEmpty ||
                                              int.parse(val) <= 0) {
                                            return 'Please enter a valid quantity.';
                                          }
                                          return null;
                                        },
                                        controller: quantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black12,
                                                width: 0.0),
                                          ),
                                          labelText: 'Quantity *',
                                        )),
                                  ),
                                  Container(
                                    // width: cardWidth,
                                    padding: EdgeInsets.all(5.0),
                                    child: TextField(
                                        autofocus: false,
                                        readOnly: true,
                                        onChanged: (val) {},
                                        keyboardType: TextInputType.number,
                                        controller: amountController,
                                        decoration: InputDecoration(
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black12,
                                                width: 0.0),
                                          ),
                                          labelText: 'Amount',
                                        )),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(40),
                                        ),
                                        color: Colors.lightBlue,
                                        child: Text(
                                          'Add to Cart',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            double Discount = 0;
                                            if (discountController.text == "") {
                                              Discount = 0;
                                            } else {
                                              Discount = double.parse(
                                                  discountController.text);
                                            }

                                            List Items = new List();
                                            DateFormat dateFormat = DateFormat(
                                                "dd/MM/yyyy HH:mm:ss");
                                            String currDateTime = dateFormat
                                                .format(DateTime.now());
                                            var str = currDateTime.split(".");
                                            Items.add({
                                              'product_id': productId,
                                              'discount': Discount,
                                              'quantity': int.parse(
                                                  quantityController.text),
                                              'amount': double.parse(
                                                  amountController.text),
                                              'created_on': str[0],
                                              'rate': double.parse(
                                                  rateController.text),
                                              'product_label': productLabel
                                            });

                                            addItemOrder(orderId, productId, productLabel);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Orders(
                                                      outletId:
                                                      globals.OutletID)),
                                            );
                                          }

                                          //  order.add()
                                        }),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Products != null ? Products.length : 0,
      itemBuilder: _getOutletsList,
    );
  }
  List<int> selectedProductIndexes = [];

  Future<void> _handleCheckboxTap(int index) async {
    print("globals.orderId" + globals.orderId.toString());
    print("globals.productId" + globals.productId.toString());
    print("globals.productLabel" + globals.productLabel.toString());
    globals.productLabel = Products[index]['product_label'].toString();
    globals.productId = Products[index]['product_id'];
    globals.orderId = orderId;
    await addItemOrder(
        globals.orderId, globals.productId, globals.productLabel);

    // Toggle the checkbox
    setState(() {

        selectedProductIndexes.add(index);

    });
  }
 // int selectedProductIndex = -1;
  Widget _getOutletsList(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        index == 0 ? Container() : Divider(),
        Container(
          child: ListTile(
              onTap: () async {
                _handleCheckboxTap(index);
              },
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      Products[index]['product_label'].toString(),
                    ),
                  ),
                  Checkbox(
                    value: selectedProductIndexes.contains(index),
                    onChanged: (value) {
                      // Add your logic for onChanged here
                    },
                  ),
                ],
              )

          ),
        ),
        (Products.length - 1) == index ? Container(height: 500) : Container(height: 0)
      ],
    );
  }


  double cardWidth = 0.0;
  PanelController _pc = new PanelController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    cardWidth = width / 1.1;

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          leading: Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 15.0, 0.0),
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShopAction()),
                    );
                  })),
          actions: <Widget>[
          ],
        ),

        body: SlidingUpPanel(
          maxHeight: 250,
          minHeight: 70,
          backdropTapClosesPanel: true,
          backdropEnabled: false,
          panelSnapping: false,
          controller: _pc,
          panel: Center(
            child: Column(
              children: [
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                              height: 250,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        //physics: ClampingScrollPhysics(),
                                        itemCount: ProductsLrbTypes != null
                                            ? ProductsLrbTypes.length
                                            : 0,
                                        itemBuilder: _getLRBTypeList,
                                      )),
                                ],
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 250,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        //physics: ClampingScrollPhysics(),
                                        itemCount: ProductsCatgories.length,
                                        itemBuilder: _getSubCategoirsList,
                                      )),
                                ],
                              )),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          collapsed: GestureDetector(
            child:   ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // Background color
              ),
              child: Text('Next',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed:
                   () {
                print("hye");
                /* _UploadOrder();*/
                //  _showIndicator();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderCartView()),
                );
              },
            ),
          ),
        /*  AllOrdersItems == null || AllOrdersItems.isEmpty
              ? null*/
          body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    // width: cardWidth,
                    margin: EdgeInsets.all(5.0),
                    child: TextField(
                        focusNode: _focus,
                        autofocus: false,
                        onChanged: (val) {
                          repo
                              .getProductsBySerachMethod(selectedLRBMenuValue,
                              selectedCategoryMenuValue, val)
                              .then((val) {
                            setState(() {
                              Products = val;
                            });
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.black12, width: 0.0),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_sharp,
                          ),
                          labelText: 'Search',
                        )),
                  ),
                  _buildListView(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            child: Text("Open"),
            onPressed: () => _pc.open(),
          ),
          ElevatedButton(
            child: Text("Close"),
            onPressed: () => _pc.close(),
          ),
          ElevatedButton(
            child: Text("Show"),
            onPressed: () => _pc.show(),
          ),
          ElevatedButton(
            child: Text("Hide"),
            onPressed: () => _pc.hide(),
          ),
        ],
      ),
    );
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
