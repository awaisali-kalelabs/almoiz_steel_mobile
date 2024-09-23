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
  var orderID =''.obs ;
   var orderId= 0.obs;




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
