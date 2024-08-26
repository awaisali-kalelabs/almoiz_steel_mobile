import 'package:flutter/material.dart';

Widget buildRow({
  IconData? icon, // Optional icon
  String? image, // Optional image asset path
  required String text,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 25.0, vertical: 8.0), // Padding around row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (image != null) // If there's an image, show it as a non-circular image
                Image.asset(
                  image,
                  height: 50, // Adjust as needed
                  width: 70, // Adjust as needed
                ),
              const SizedBox(width: 10), // Space between icon/image and text
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFFFF5733),
                  fontSize: 22, // Larger font size
                  fontWeight: FontWeight.bold,
                ),
              ),
           //   const SizedBox(width: 20), // Space between icon/image and text

           /*   if (image != null) // If there's an image, show it as a non-circular image
                Image.asset(
                  image,
                  height: 50, // Adjust as needed
                  width: 50, // Adjust as needed
                ),*/
            ],
          ),
          const Icon(Icons.arrow_forward_ios, color:Color(0xFF8F1D1C),),
        ],
      ),
    ),
  );
}
