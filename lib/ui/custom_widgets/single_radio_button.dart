import 'package:flutter/material.dart';

class CustomSingleRadioButton extends StatelessWidget {
  final bool isSelected;
  // ignore: prefer_typing_uninitialized_variables, strict_top_level_inference
  final onPressed;
  const CustomSingleRadioButton({
    super.key,
    this.isSelected = false,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 14,
          width: 14,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
