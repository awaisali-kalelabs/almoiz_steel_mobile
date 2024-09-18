import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  // Method to display a custom Snackbar
  static void show({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM, // Default position
    Color? backgroundColor, // Optional background color
    Color textColor = Colors.green, // Default text color
    Duration duration = const Duration(seconds: 3), // Duration of Snackbar
    double borderRadius = 10.0, // Default border radius
    EdgeInsets margin = const EdgeInsets.all(10), // Default margin
    IconData? icon, // Optional icon
    bool isDismissible = true, // Can be dismissed by swiping
    SnackStyle style = SnackStyle.FLOATING, // Default style
    Curve forwardCurve = Curves.easeOut, // Forward animation curve
    Curve reverseCurve = Curves.easeIn, // Reverse animation curve
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor, // You can still set the background color here
      colorText: textColor,
      borderRadius: borderRadius,
      margin: margin,
      duration: duration,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      isDismissible: isDismissible,
      snackStyle: style,
      forwardAnimationCurve: forwardCurve,
      reverseAnimationCurve: reverseCurve,
      // Use the `barBlur` or `boxShadows` for decoration-like features, but you cannot directly use `BoxDecoration`
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF00A375), Color(0xFF00A375)], // Bright blue gradient colors
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
