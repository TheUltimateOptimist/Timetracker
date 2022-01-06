import 'package:flutter/material.dart';
import 'package:time/activity.dart';
import 'package:time/myAppBar.dart';

import 'activityEntry.dart';
import 'addActivityDialog.dart';

void main() {
  Activity("Hallo", 45, 45).printSome();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time',
      home: MyHomePage(title: 'Timetracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Activitys activitys = Activitys(
    [
      Activity(
        "Spielen",
        3000,
        200,
      ),
      Activity(
        "Klavier",
        4500,
        9000,
      ),
      Activity(
        "Singen",
        100,
        35000,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfefae0),
      appBar: MyAppBar(title: widget.title),
      body: ReorderableListView.builder(
          itemBuilder: (context, index) {
            final Activity activity = activitys.getActivity(index);
            return ActivityEntry(
              activity: activity,
              key: ValueKey(
                activity.title,
              ),
            );
          },
          itemCount: activitys.getLength(),
          onReorder: (a, b) => activitys.relocateActivity(a, b)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => AddActivityDialog(
              activitys: activitys,
            ),
          );
          setState(() {});
        },
        child: Icon(
          Icons.add,
          color: Color(0xFFfefae0),
          size: 20,
        ),
        backgroundColor: Color(0xff283618),
      ),
    );
  }
}
