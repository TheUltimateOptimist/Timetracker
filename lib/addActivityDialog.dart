import 'package:flutter/material.dart';
import 'dialogButton.dart';
import 'dialogInputField.dart';
import 'activity.dart';

class AddActivityDialog extends StatelessWidget {
  AddActivityDialog({required this.activity});
  final Activity activity;
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
        DialogButton(title: "Save", onPressed: () async{
          await activity.addActivity(titleEditingController.text);
          print("2");
          print(activity.children);
          Navigator.pop(context);
        }),
      ],
    );
  }
}
