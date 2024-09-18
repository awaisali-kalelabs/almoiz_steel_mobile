import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final IconData? icon; // Optional icon
  final VoidCallback onPressed;

  const CustomButtonWidget({
    Key? key,
    required this.text,
    this.icon, // Optional icon in constructor
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00bf8f), Color(0xFF00A375)], // Bright blue gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Make background transparent for gradient effect
            shadowColor: Colors.transparent, // Remove button shadow to match gradient
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Colors.white, Colors.white], // White color to keep the text visible
              ).createShader(bounds);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min, // Keeps the button size compact
              children: [

                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white, // Text color remains white
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (icon != null) const SizedBox(width: 12), // Add spacing between icon and text

                if (icon != null) // Show icon only if provided
                  Icon(
                    icon,
                    color: Colors.white, // Icon color

                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
