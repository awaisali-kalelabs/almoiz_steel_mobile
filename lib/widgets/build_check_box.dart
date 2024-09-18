import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCheckbox extends StatelessWidget {
  final String title;
  final RxBool value;
  final VoidCallback onChanged;

  const CustomCheckbox({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
              () => Checkbox(
                activeColor: Color(0xFF00A375),
            value: value.value,
            onChanged: (bool? newValue) {
              onChanged();
            },
          ),
        ),
        Text(title),
      ],
    );
  }
}
