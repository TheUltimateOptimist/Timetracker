import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({Key? key, required String title})
      : super(
          key: key,
          backgroundColor: Color(0xff283618),
          toolbarHeight: 75,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        );
}
