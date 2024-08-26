import 'package:flutter/material.dart';

const kThemeColor = Color(0xFFFFFFFF);

var kButtonStyle = ElevatedButton.styleFrom(
  // backgroundColor: const Color(0xFF062830),
  backgroundColor:  Color(0xFF101720),

// backgroundColor: Colors.blue, shadowColor: Colors.yellow,

  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
);

var kFieldBorders = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Color(0xFFFFFFFF),
  ),
  borderRadius: BorderRadius.circular(30.0),
);

var kFieldBordersFocused = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Color(0xFFFFFFFF),
    width: 2.0,
  ),
  borderRadius: BorderRadius.circular(30.0),
);

var kFieldBorderError = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 2),
  borderRadius: BorderRadius.circular(30.0),
);

var kFieldFocusedBorderError = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 2),
  borderRadius: BorderRadius.circular(30.0),
);
const kText = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Color(0xFFFFFFFF),
);
var kClipperDec = const BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);

const kAppBarColor = Color(0xFF4682B4);
const kAppBarTextColor = TextStyle(color: Colors.white);
