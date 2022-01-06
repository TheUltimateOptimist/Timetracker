import 'package:flutter/material.dart';

class DialogInputField extends StatelessWidget {
  DialogInputField({required this.title, required this.inputEditingController});
  final String title;
  final TextEditingController inputEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      controller: inputEditingController,
      decoration: InputDecoration(
        focusColor: Color(
          0xffdda15e,
        ),
        hintText: title,
        hintStyle: TextStyle(
          color: Color(
            0xffffffff,
          ),
          fontSize: 15,
        ),
      ),
    );
  }
}
