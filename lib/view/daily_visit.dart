import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/daily_visit_controller.dart';
import '../controller/login_controller.dart';
import '../widgets/custom_appbar.dart';
import 'outlet_images.dart';
import 'package:moiz_steel/constants.dart';

class DailyVisit extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final DailyVisitController dailyVisitController = Get.put(DailyVisitController());

  DailyVisit({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dailyVisitController.initializeSelectedDay();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Daily Visit'),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
              child: _buildDaysRow(),
            ),
            const Divider(thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: Obx(() {
                return dailyVisitController.PreSellOutlets.isEmpty
                    ? const Center(child: Text('No outlets for today'))
                    : _buildOutletsList();
              }),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDaysRow() {
    return Obx(() {
      // Get today's date and day of the week
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday % 7));
      final daysOfWeek = List.generate(
        7,
            (index) => weekStart.add(Duration(days: index)),
      );

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: daysOfWeek.map((date) {
          final dayNumber = DateFormat('E').format(date).substring(0, 2);
          final isSelected = dailyVisitController.selectedDay.value == dayNumber;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                dailyVisitController.changeDay(dayNumber);
              },
              child: Container(
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                    colors: [Color(0xFF00bf8f), Color(0xFF00A375)], // Bright blue gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null, // If not selected, don't apply gradient
                  color: isSelected ? null : Colors.grey[100], // Apply solid color if not selected
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      dayNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
  Widget _buildOutletsList() {
    final filteredContents = dailyVisitController.PreSellOutlets;
    return ListView.builder(
      itemCount: filteredContents.length,
      itemBuilder: (context, index) {
        final cardContent = filteredContents[index];
        return GestureDetector(
          onTap: () async {
            await Get.to(() => OutletImages(),transition: Transition.leftToRight);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
            child: Row(
              children: [
                // Blue container on the left side of the card
                Container(
                  width: 8, // Adjust the width as needed
                  height: 115, // Adjust the height as needed to fit the card height
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00bf8f), Color(0xFFFFFFFF)], // Bright blue gradient colors
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      child: _buildOutletRow(cardContent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOutletRow(Map<String, dynamic> cardContent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardContent['outlet_name'] ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(cardContent['address'] ?? ""),
              const SizedBox(height: 10),
              Text(cardContent['sub_area'] ?? ""),
            ],
          ),
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions),
            SizedBox(width: 10),
            Icon(Icons.call),
          ],
        ),
      ],
    );
  }
}
