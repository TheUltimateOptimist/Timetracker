import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time/activity.dart';
import 'package:time/myAppBar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key, required this.activity}) : super(key: key);
  final Activity activity;
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  IconData icon = Icons.play_arrow_rounded;
  late Timer t;
  String centerText = "";

  @override
  void initState() {
    t = Timer.periodic(
        Duration(
          seconds: 1,
        ), (t) {
      if (icon == Icons.stop) {
        setState(() {
          centerText = widget.activity.getTimeEllapsed();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffefae0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if(icon == Icons.play_arrow_rounded){
              widget.activity.start();
              icon = Icons.stop;
            }
            else{
              widget.activity.stop();
              centerText = "";
              icon = Icons.play_arrow_rounded;
            }
          });
        },
        backgroundColor: Color(
          0xff283618,
        ),
        child: Icon(
          icon,
          color: Color(
            0xffffffff,
          ),
          size: 30,
        ),
      ),
      appBar: MyAppBar(
        title: widget.activity.title,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Column(
              children: [
                DayDuration(
                  duration: widget.activity.getTimeYesterday(),
                  keyword: "Gestern: ",
                ),
                DayDuration(
                  duration: widget.activity.getTimeToday(),
                  keyword: "Heute:    ",
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              child: Text(
                centerText,
                style: TextStyle(
                  color: Color(0xff283618),
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DayDuration extends StatelessWidget {
  DayDuration({required this.duration, required this.keyword});

  final String duration;
  final String keyword;

  final TextStyle textStyle = TextStyle(
    color: Color(0xff606c38),
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            keyword,
            style: textStyle,
          ),
          Text(
            duration,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
