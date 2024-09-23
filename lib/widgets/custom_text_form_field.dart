import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? prefixIcon;
  final bool obscureText;
  final IconButton? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final String? initialValue;
  final bool? enabled;
  final Color hintTextColor;
  final Color textColor;

  CustomTextFormField({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.initialValue,
    this.enabled,
    this.hintTextColor = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 50, // Updated maxLength to 50
      textInputAction: TextInputAction.next,
      initialValue: initialValue,
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        counterText: "",
        hintText: hintText,
        hintStyle: TextStyle(color: hintTextColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xFF00A375)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xFF00A375), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
      style: TextStyle(color: textColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid $hintText.';
        }

        // No need for alphanumeric check since special characters are allowed

        if (hintText == 'Password') {
          if (value.contains(RegExp(r'\s'))) {
            return 'Password cannot contain white spaces.';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters long.';
          }
        }

        if (validator != null) {
          return validator!(value);
        }

        return null;
      },
    );
  }
}
