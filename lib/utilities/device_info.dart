import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceIdProvider {
  static Future<String> getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.androidId.toString();
      }
      //print("device id: ${deviceInfo}");


      return "Unsupported Platform"; // Return a message for unsupported platforms
    } catch (e) {
      return "Error: Unable to retrieve device ID - ${e.toString()}"; // Return an error message in case of exception
    }
  }
}
