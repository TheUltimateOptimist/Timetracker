import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  DialogButton({required this.title, required this.onPressed});
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(
          color: Color(
            0xff283618,
          ),
          fontSize: 20,
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Color(
          0xffdda15e,
        ),
      ),
    );
  }
}