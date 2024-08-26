import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

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
    this.hintTextColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 10,
      textInputAction: TextInputAction.next,
      initialValue: initialValue,
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^[a-zA-Z0-9]+$')),
      ],
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
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
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

        if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
          return 'Invalid input. Only alphanumeric characters are allowed.';
        }

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