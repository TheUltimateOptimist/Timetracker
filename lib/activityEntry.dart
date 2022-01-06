import 'package:flutter/material.dart';
import 'package:time/activityScreen.dart';

import 'activity.dart';

class ActivityEntry extends StatelessWidget {
  const ActivityEntry({Key? key, required this.activity}) : super(key: key);
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return ListTile(onTap: (){Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityScreen(activity: activity),
            ),
          );},
      title: Text(
        activity.title,
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
        onPressed: () {
        },
      ),
    );
  }
}
