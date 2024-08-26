import 'package:flutter/material.dart';

//
//
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Define the vertices for the isosceles triangle
    // Point A: Top-left (unequal side extends to this point)
    path.moveTo(0, size.height / 2);

    // Point B: Bottom-right (base of the triangle)
    path.lineTo(size.width, size.height);

    // Point C: Top-right (base of the triangle)
    path.lineTo(size.width, 0); // Close the path to form a triangle
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // The clipper won't change, so no need to reclip
  }
}

class StretchedTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0); // Top-left corner
    path.lineTo(size.width, 0); // Top-right corner (hypotenuse)
    path.lineTo(0, size.height); // Bottom-left corner (opposite side)
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // The shape does not need to be re-clipped
  }
}
