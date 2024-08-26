import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart'; // Import the LoginController
import 'daily_visit.dart';
import 'login_screen.dart';
import 'package:moiz_steel/constants.dart';
import 'package:moiz_steel/first_page_buildrow_model.dart';
import 'package:moiz_steel/snack_bar_model.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'outlet_registration.dart';

class FirstPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController()); // Get the existing controller

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(35), // AppBar height
        //   child: AppBar(
        //     automaticallyImplyLeading: false,
        //     elevation: 0, // No shadow
        //     backgroundColor: kAppBarColor, // Transparent AppBar
        //     actions: [
        //       PopupMenuButton<String>(
        //         onSelected: (value) {
        //           if (value == 'logout') {
        //             Get.off(() => LoginScreen());
        //             print("logout");
        //           }
        //         },
        //         itemBuilder: (context) => [
        //           const PopupMenuItem(
        //             value: 'logout',
        //             child: Text('Logout'),
        //           ),
        //         ],
        //         icon: const Icon(Icons.menu, color: Colors.white), // White "hamburger" icon
        //       ),
        //     ],
        //   ),
        // ),
        body: Stack(

          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/SF_img.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GlassmorphicContainer(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              borderRadius: 0,
              blur: 30,
              alignment: Alignment.bottomCenter,
              border: 0,
              linearGradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.1),
                  Colors.red.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderGradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.5),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 25), // Space at the top
                Obx(() => Column(
                  children: [
                    // const Text(
                    //   "Welcome",
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 24, // Font size for "Welcome"
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      loginController.fullName.value, // User's name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24, // Same font size for consistency
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 60),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 140.0), // Padding from the top
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Center horizontally
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildElevatedRow(
                          icon: Icons.arrow_forward,
                          text: 'Daily visit',
                          image: 'assets/images/img9.png',
                          onTap: () {
                            Get.to(() => DailyVisit());
                          },
                        ),
                        const SizedBox(height: 10), // Space between rows
                        buildElevatedRow(
                          icon: Icons.arrow_forward,
                          text: 'Outlet Registration',
                          image: 'assets/images/img10.png',
                          onTap: () {
                            Get.to(() => RegistrationFormScreen());
                          },
                        ),
                        const SizedBox(height: 10),
                        buildElevatedRow(
                          icon: Icons.arrow_forward,
                          text: 'Attendance',
                          image: 'assets/images/img11.png',
                          onTap: () {
                            CustomSnackbar.show(
                              title: "Complaints",
                              message: "Complaints",
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        buildElevatedRow(
                          icon: Icons.arrow_forward,
                          text: 'Reports',
                          image: 'assets/images/img12.png', // Add the appropriate image for Reports
                          onTap: () {
                            // Handle the onTap for Reports
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 25, // Adjust position based on topMargin and desired overlap
              child: Center(
                child: Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Container(
                    width: 325, // Adjust the size of the small card
                    height: 200, // Adjust the height of the small card
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 4), // Shadow effect
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                      child: Row(
                        children: [
                          // Text portion
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Outlets: 10",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Visits: 7",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: 0.7, // Set the progress value (70%)
                                strokeWidth: 12, // Adjust the thickness of the progress indicator
                                backgroundColor: Colors.grey[200], // Set the background color
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrangeAccent,
                                ), // Set the color of the progress indicator
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildElevatedRow({required IconData icon, required String text, required String image, required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          // margin: const EdgeInsets.symmetric(vertical: 3.0),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF).withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.1),
            //     offset: Offset(0, 0),
            //     blurRadius: 0,
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Image.asset(image, height: 50, width: 50),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(icon, size: 30, color: Color(0xFFFFFFFF)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
