import 'package:flutter/material.dart';

import '../constants.dart';


class BuildSectionTile extends StatelessWidget {
  String title;
  BuildSectionTile({required this.title});
//  const ({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Take full width
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: kAppBarColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
