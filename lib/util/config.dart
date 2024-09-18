// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class LocationService {
//   Future<Map<String, double>> getCurrentLocation() async {
//     await Permission.locationWhenInUse.request();
//
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled, request user to enable it
//       return Future.error('Location services are disabled.');
//     }
//
//     // Check if permission is granted
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, show a message to the user
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // Get the current position
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     // Return the location data
//     return {
//       'latitude': position.latitude,
//       'longitude': position.longitude,
//       'accuracy': position.accuracy
//     };
//   }
// }
