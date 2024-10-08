import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/database.dart';

// import '../services/database_sqflite.dart';

enum Week { thisWeek, lastWeek }

class DailyVisitController extends GetxController {
  final DatabaseHelper dbController = Get.put(DatabaseHelper());

  var currentWeek = Week.thisWeek.obs;
  var cardContents = <String>[].obs;
  var searchText = ''.obs;
  var selectedDay = ''.obs;
  var selectedDayNumber = 0.obs; // New variable to store day number
  var PreSellOutlets = <Map<String, dynamic>>[].obs;
  var cardCompletionStatus = <String, bool>{}.obs;
  var Day = ''.obs;
  var PreSellOutletsLength = 0.obs;
  var orderId= 0.obs;
  var userName = '';





  final dayAbbreviationToNumber = {
    'Su': 1,
    'Mo': 2,
    'Tu': 3,
    'We': 4,
    'Th': 5,
    'Fr': 6,
    'Sa': 7,
  };

  @override
  void onInit() {
    super.onInit();
    initializeSelectedDay();
    fetchOutletData();
    addCard();

  }


  void initializeSelectedDay() {
    final currentDate = DateTime.now();
    final daysOfWeek = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    selectedDay.value = daysOfWeek[currentDate.weekday % 7];
    selectedDayNumber.value = dayAbbreviationToNumber[selectedDay.value] ?? 0; // Set day number
    print("Selected day: ${selectedDay.value}, Number: ${selectedDayNumber.value}");
    changeDay(selectedDay.value);
  }
  int getUniqueMobileId() {
    ////print("UserID:" + username.toString());
    String MobileId = "";
    if (userName.toString().length > 4) {
      MobileId = userName.toString() +
          DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      MobileId = userName.toString() +
          DateTime.now().millisecondsSinceEpoch.toString();
    }
    return int.parse(MobileId);
  }


  Future<void> fetchOutletData() async {
    try {
      print("Fetching outlet data for day number: ${selectedDayNumber.value}");
      var fetchedData = await dbController.getAllOutletData(selectedDayNumber.value);
      PreSellOutlets.assignAll(fetchedData);
      PreSellOutletsLength.value = PreSellOutlets.length;
      print("Fetched outlet data here: ${PreSellOutlets.length}");
    } catch (e) {
      print("Error fetching outlet data: $e");
    }
  }
  // void printOutletData(int outletId) async {
  //   List<Map<String, dynamic>> outletData = await  dbController.getOutletDataById(outletId);
  //
  //   if (outletData.isNotEmpty) {
  //     outletData.forEach((outlet) {
  //       print("Outlet ID: ${outlet['outlet_id']}");
  //       print("Outlet Name: ${outlet['outlet_name']}");
  //       print("Day Number: ${outlet['day_number']}");
  //       print("Owner: ${outlet['owner']}");
  //       print("Address: ${outlet['address']}");
  //       print("Telephone: ${outlet['telephone']}");
  //       print("NFC Tag ID: ${outlet['nfc_tag_id']}");
  //       print("Visit Type: ${outlet['visit_type']}");
  //       print("Latitude: ${outlet['lat']}");
  //       print("Longitude: ${outlet['lng']}");
  //       print("Area Label: ${outlet['area_label']}");
  //       print("Sub Area Label: ${outlet['sub_area_label']}");
  //       print("Is Alternate Visible: ${outlet['is_alternate_visible']}");
  //       print("PIC Channel ID: ${outlet['pic_channel_id']}");
  //       print("Channel Label: ${outlet['channel_label']}");
  //       print("Order Created On Date: ${outlet['order_created_on_date']}");
  //       print("VPO Classifications: ${outlet['common_outlets_vpo_classifications']}");
  //       print("Visit: ${outlet['Visit']}");
  //       print("Purchaser Name: ${outlet['purchaser_name']}");
  //       print("Purchaser Mobile No: ${outlet['purchaser_mobile_no']}");
  //       print("Cache Contact NIC: ${outlet['cache_contact_nic']}");
  //     });
  //   } else {
  //     print("No data found for Outlet ID: $outletId");
  //   }
  // }


  void addCard() {
    final newCardContent = PreSellOutlets.toString();
    cardContents.add(newCardContent);
    cardCompletionStatus[newCardContent] = false; // Initially, the card is not completed
  }

  void changeDay(String dayAbbreviation) {
    selectedDay.value = dayAbbreviation;
    selectedDayNumber.value = dayAbbreviationToNumber[selectedDay.value] ?? 0; // Update day number
    fetchOutletData(); // Fetch data for the newly selected day
  }

  void changeWeek(Week week) {
    currentWeek.value = week;
  }

  void updateSearchText(String text) {
    searchText.value = text;
  }

  void markCardAsCompleted(String cardContent) {
    cardCompletionStatus[cardContent] = true;
  }

  List<String> get filteredCardContents {
    return cardContents.where((content) {
      return content.contains(selectedDay.value) && content.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../services/database.dart';
//
//
// // import '../services/database_sqflite.dart';
//
// enum Week { thisWeek, lastWeek }
//
// class DailyVisitController extends GetxController {
//   // final DatabaseController databaseController = Get.put(DatabaseController());
//   final DatabaseHelper dbController = Get.put(DatabaseHelper());
//
//
//   var currentWeek = Week.thisWeek.obs;
//   var cardContents = <String>[].obs;
//   var searchText = ''.obs;
//   var selectedDay = ''.obs;
//   var selectedDayNumber = 0.obs; // New variable to store day number
//   var PreSellOutlets = <Map<String, dynamic>>[].obs;
//   var cardCompletionStatus = <String, bool>{}.obs;
//   var Day = ''.obs;
//
//   final dayAbbreviationToNumber = {
//     'Su': 1,
//     'Mo': 2,
//     'Tu': 3,
//     'We': 4,
//     'Th': 5,
//     'Fr': 6,
//     'Sa': 7,
//   };
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeSelectedDay();
//     loadHardcodedData();
//     fetchOutletData();
//   }
//
//   void initializeSelectedDay() {
//     final currentDate = DateTime.now();
//     final daysOfWeek = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
//     selectedDay.value = daysOfWeek[currentDate.weekday % 7];
//     selectedDayNumber.value = dayAbbreviationToNumber[selectedDay.value] ?? 0; // Set day number
//     print("Selected day: ${selectedDay.value}, Number: ${selectedDayNumber.value}");
//     changeDay(selectedDay.value);
//   }
//
//     Future<void> fetchOutletData() async {
//     try {
//       print("Fetching outlet data for day number: ${selectedDayNumber.value}");
//       var fetchedData = await dbController.getAllOutletData(selectedDayNumber.value);
//       PreSellOutlets.assignAll(fetchedData);
//       print("Fetched outlet data: $PreSellOutlets");
//     } catch (e) {
//       print("Error fetching outlet data: $e");
//     }
//   }
//
//   void addCard() {
//     final newCardContent = PreSellOutlets.toString();
//     cardContents.add(newCardContent);
//     cardCompletionStatus[newCardContent] = false; // Initially, the card is not completed
//   }
//
//
//
//   void loadHardcodedData() {
//     PreSellOutlets.assignAll([
//       {
//         'outlet_name': 'Outlet 1',
//         'address': '123 Main St',
//         'sub_area': 'Downtown'
//       },
//       {
//         'outlet_name': 'Outlet 2',
//         'address': '456 Elm St',
//         'sub_area': 'Uptown'
//       },
//       {
//         'outlet_name': 'Outlet 3',
//         'address': '789 Oak St',
//         'sub_area': 'Midtown'
//       },
//     ]);
//   }
//
//   // void addCard() {
//   //   final newCardContent = PreSellOutlets.toString();
//   //   cardContents.add(newCardContent);
//   //   cardCompletionStatus[newCardContent] = false; // Initially, the card is not completed
//   // }
//
//   void changeDay(String dayAbbreviation) {
//     selectedDay.value = dayAbbreviation;
//     selectedDayNumber.value = dayAbbreviationToNumber[selectedDay.value] ?? 0; // Update day number
//   }
//
//   void changeWeek(Week week) {
//     currentWeek.value = week;
//   }
//
//   void updateSearchText(String text) {
//     searchText.value = text;
//   }
//
//   void markCardAsCompleted(String cardContent) {
//     cardCompletionStatus[cardContent] = true;
//   }
//
//   List<String> get filteredCardContents {
//     return cardContents.where((content) {
//       return content.contains(selectedDay.value) && content.toLowerCase().contains(searchText.value.toLowerCase());
//     }).toList();
//   }
// }