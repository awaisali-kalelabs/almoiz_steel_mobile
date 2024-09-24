import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/daily_visit_controller.dart';
import '../controller/login_controller.dart';
import '../controller/outlet_images_controller.dart';
import '../snack_bar_model.dart';
import '../utilities/common_functions.dart';
import 'attendance_view.dart';
import 'daily_visit.dart';
import 'login_screen.dart';
import 'outlet_registration.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class Home extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final PerformTask controller = Get.put(PerformTask());
  final CommonFunctions commonFunctions = Get.put(CommonFunctions());
  final DailyVisitController dailyVisitController = Get.put(DailyVisitController());




  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00bf8f), Color(0xFF00A375)], // Bright blue gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Handle logout logic
                  Get.off(() => LoginScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text('Upload Data'),
                onTap: () async {
                  commonFunctions.showLoader();
                  // Handle upload data logic
                  await controller.SaveNoOrder();
                  await controller.sendOutletImage();
                  commonFunctions.hideLoader();
                  CustomSnackbar.show(
                    title: "Upload",
                    message: " Data uploaded successfully",
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                // Profile Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/background_img.jpeg'), // Replace with your image asset
                      ),
                      const SizedBox(width: 10),
                       Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome Back,",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              "${loginController.fullName.value}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Cards Section
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // New Bigger Card with Progress Bar
                      Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Today's Outlets: ${dailyVisitController.PreSellOutlets.length}",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // const Text(
                            //   "Visits: 7",
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            // Progress Bar
                            const LinearProgressIndicator(
                              value: 7 / 10, // Calculating progress value (7 visits out of 10)
                              backgroundColor: Colors.orange,
                              color: Colors.orange, // Color of the progress bar
                              minHeight: 10, // Height of the progress bar
                            ),
                          ],
                        ),
                      ),
                      CustomCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFE082), Color(0xFFFFD54F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        title: 'DailyVisit',
                        subtitle: 'Start Your Daily Visit here',
                        icon: Icons.calendar_today,
                        onTap: () {
                          Get.to(() => DailyVisit(), transition: Transition.leftToRight);
                        },
                      ),
                      CustomCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF80DEEA), Color(0xFF4DD0E1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        title: 'Outlet Registration',
                        subtitle: 'Register your outlet here',
                        icon: Icons.app_registration,
                        onTap: () {
                          Get.to(() => RegistrationFormScreen(),transition: Transition.leftToRight);
                        },
                      ),
                      CustomCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFCE93D8), Color(0xFFBA68C8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        title: 'Attendance',
                        subtitle: 'Mark attendance here',
                        icon: Icons.front_hand,
                        onTap: () {
                          Get.to(() => Attendance());


                          // CustomSnackbar.show(
                          //   title: "Attendance",
                          //   message: "Mark attendance here",
                          // );
                        },
                      ),
                      CustomCard(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        title: 'Reports',
                        subtitle: 'View your reports here',
                        icon: Icons.report,
                        onTap: () {
                          // Handle onTap for Reports
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const CustomCard({
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
