import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/daily_visit_controller.dart';
import '../controller/login_controller.dart';
// import '../controller/outlet_image.dart';
import 'home.dart';
// import 'map_view.dart';
import 'package:moiz_steel/constants.dart';

import 'outlet_images.dart';

class DailyVisit extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final DailyVisitController dailyVisitController = Get.put(DailyVisitController());

  DailyVisit() {
    // Initialize the selected day to the current day
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dailyVisitController.initializeSelectedDay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => FirstPage());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Daily Visit",
            style: kAppBarTextColor,
          ),
          backgroundColor: kAppBarColor,
          elevation: 5,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              // child: Obx(() {
              //   return Row(
              //     children: [
              //       // Radio<Week>(
              //       //   activeColor: Colors.white,
              //       //   value: Week.thisWeek,
              //       //   groupValue: dailyVisitController.currentWeek.value,
              //       //   onChanged: (value) {
              //       //     if (value != null) {
              //       //       dailyVisitController.changeWeek(value);
              //       //     }
              //       //   },
              //       // ),
              //       // const Text(
              //       //   'This Week',
              //       //   style: TextStyle(color: Colors.white),
              //       // ),
              //       // Radio<Week>(
              //       //   value: Week.lastWeek,
              //       //   groupValue: dailyVisitController.currentWeek.value,
              //       //   onChanged: (value) {
              //       //     if (value != null) {
              //       //       dailyVisitController.changeWeek(value);
              //       //     }
              //       //   },
              //       // ),
              //       // const Text(
              //       //   'Last Week',
              //       //   style: TextStyle(color: Colors.white),
              //       // ),
              //     ],
              //   );
              // }),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    'Su',
                    'Mo',
                    'Tu',
                    'We',
                    'Th',
                    'Fr',
                    'Sa',
                  ].map((dayNumber) {
                    final isSelected = dailyVisitController.selectedDay.value == dayNumber;
                    return GestureDetector(
                      onTap: () {
                        print("Outlet Data${dailyVisitController.PreSellOutlets}");
                        dailyVisitController.changeDay(dayNumber);
                      },
                      child: Container(
                        width: 50,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                        decoration: BoxDecoration(
                          color: isSelected ? kAppBarColor : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          dayNumber,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  // enabledBorder: kFieldBorders,
                  // focusedBorder: kFieldBordersFocused,
                  errorBorder: kFieldBorderError,
                  focusedErrorBorder: kFieldFocusedBorderError,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                ),
                onChanged: (value) {
                  dailyVisitController.updateSearchText(value);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(() {
                if (dailyVisitController.PreSellOutlets.isEmpty) {
                  return Center(child: Text('No outlets for today'));
                } else {
                  final filteredContents = dailyVisitController.PreSellOutlets;
                  return ListView.builder(
                    itemCount: dailyVisitController.PreSellOutlets.length,
                    itemBuilder: (context, index) {
                      final cardContent = filteredContents[index];

                      return GestureDetector(
                        onTap: () async {
                          await Get.to(() => OutletImages());
                        },
                        child: Container(
                          width: double.infinity,
                          child: Card(
                            surfaceTintColor: Colors.grey[100],
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${cardContent['outlet_name'] ?? ""}",
                                        style: const TextStyle(
                                            color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(cardContent['address'] ?? ""),
                                      const SizedBox(height: 10),
                                      Text(cardContent['sub_area'] ?? ""),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.directions),
                                        SizedBox(width: 10),
                                        Icon(Icons.call),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: const Color(0xFFD82D26),
        //   elevation: 5,
        //   onPressed: () {
        //     // Get.to(() => MapView());
        //   },
        //   child: const Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Icon(Icons.map, color: Colors.white),
        //       Text(
        //         'Map View',
        //         style: TextStyle(color: Colors.white, fontSize: 10),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
