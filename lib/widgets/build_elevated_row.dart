import 'package:flutter/material.dart';

class BuildElevatedRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String image;
  final Function onTap;

  const BuildElevatedRow({
    super.key,
    required this.icon,
    required this.text,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF).withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Image.asset(image, height: 50, width: 50),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(icon, size: 30, color: const Color(0xFFFFFFFF)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
