import 'package:flutter/material.dart';
import 'package:time/activity.dart';
import 'package:time/activityScreen.dart';
import 'package:time/database.dart';
import 'package:time/myAppBar.dart';
import 'package:time/userPreferences.dart';

import 'activityEntry.dart';
import 'addActivityDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late Activity root;
Activity? runningActivity;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DataBase().initialize();
  root = await DataBase().getActivity("root");
  if(UserPreferences().isActivityRunning){
    runningActivity = await DataBase().getActivity(UserPreferences().runningActivityId);
    runningActivity!.isRunning = true;
    runningActivity!.actStart = UserPreferences().activityStart;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {"/": (context)=>firstScreen()},
      title: 'Time',
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.subTitle, required this.activity})
      : super(key: key);
  final String? subTitle;
  final Activity activity;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print(widget.key.toString());
    return Scaffold(
      backgroundColor: Color(0xFFfefae0),
      appBar: MyAppBar(
        subTitle: widget.subTitle,
        showActivityIcon: widget.key.toString() == "[<'root'>]" ? false : true,
        onActivityIconPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityScreen(
                  activity: widget.activity, subTitle: widget.subTitle!),
            ),
          );
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Map<String, String> child = widget.activity.getChild(index);
          return ActivityEntry(
            name: child["name"]!,
            key: ValueKey(
              child["id"],
            ),
            onTap: () async {
              String subTitle = child["name"]!;
              if (widget.subTitle != null) {
                subTitle = widget.subTitle! + " > " + subTitle;
              }
              Activity newActivity = await DataBase().getActivity(child["id"]!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    subTitle: subTitle,
                    activity: newActivity,
                    key: ValueKey(
                      child["id"],
                    ),
                  ),
                ),
              );
            },
            onDelete: () async {
              await widget.activity.removeSubActivity(child["name"]!);
              setState(() {});
            },
          );
        },
        itemCount: widget.activity.numberOfChildren,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => AddActivityDialog(
              activity: widget.activity,
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

firstScreen(){
  if(UserPreferences().isActivityRunning){
    return ActivityScreen(activity: runningActivity!, subTitle: runningActivity!.title, isFirstPage: true,);
  }
  return MyHomePage(key: ValueKey("root"), activity: root);
}
