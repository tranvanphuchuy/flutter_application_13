import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final Color color;
  final Color textColor;
  final void Function() buttonTapped;

  const MyButton({
    Key? key,
    required this.buttonText,
    required this.color,
    required this.textColor,
    required this.buttonTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(0.5),
        ),
        margin: const EdgeInsets.all(1.0),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
