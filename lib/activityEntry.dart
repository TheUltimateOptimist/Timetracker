import 'package:flutter/material.dart';

class ActivityEntry extends StatelessWidget {
  const ActivityEntry({Key? key, required this.name, required this.onDelete, required this.onTap}) : super(key: key);
  final String name;
  final Function() onDelete;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(onTap: onTap,
      title: Text(
        name,
        style: TextStyle(
          color: Color(
            0xff283618,
          ),
          fontSize: 25,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          size: 25,
          color: Color(
            0xff283618,
          ),
        ),
        onPressed: onDelete,
      ),
    );
  }
}
