import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moiz_steel/services/database.dart';
import 'view/login_screen.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => DatabaseHelper().database);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryTextTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Montserrat'),
          bodyMedium: TextStyle(fontFamily: 'Montserrat'),
          displayLarge: TextStyle(fontFamily: 'Montserrat'),
          displayMedium: TextStyle(fontFamily: 'Montserrat'),
          displaySmall: TextStyle(fontFamily: 'Montserrat'),
          headlineMedium: TextStyle(fontFamily: 'Montserrat'),
          headlineSmall: TextStyle(fontFamily: 'Montserrat'),
          titleLarge: TextStyle(fontFamily: 'Montserrat'),
          titleMedium: TextStyle(fontFamily: 'Montserrat'),
          titleSmall: TextStyle(fontFamily: 'Montserrat'),
        ),
        fontFamily: 'Montserrat',
      ),

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),

      ],
    );
  }
}

// }
