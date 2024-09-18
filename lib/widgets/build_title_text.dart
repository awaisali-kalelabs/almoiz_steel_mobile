import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;

  const TitleText({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
