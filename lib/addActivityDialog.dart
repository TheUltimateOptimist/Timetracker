import 'package:flutter/material.dart';

import 'activity.dart';
import 'dialogButton.dart';
import 'dialogInputField.dart';

class AddActivityDialog extends StatelessWidget {
  AddActivityDialog({required this.activitys});
  final Activitys activitys;
  final TextEditingController titleEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xff283618),
      title: Text(
        "Add Activity",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      content: DialogInputField(
        title: "title",
        inputEditingController: titleEditingController,
      ),
      actions: [
        DialogButton(title: "Save", onPressed: () {
          activitys.add(titleEditingController.text, 0, 0);
          Navigator.pop(context);
        }),
      ],
    );
  }
}
