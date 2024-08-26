import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login_screen.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),

      ],
    );
  }
}

// }
