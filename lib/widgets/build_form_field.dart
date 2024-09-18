import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for inputFormatters

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength; // Optional maxLength

  const CustomFormField({
    Key? key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength, // maxLength is optional now
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE6FD),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        validator: validator, // Use the validator here
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength), // Apply length limit only if provided
          if (keyboardType == TextInputType.phone) FilteringTextInputFormatter.digitsOnly, // Restrict to digits for phone input
        ],
      ),
    );
  }
}
