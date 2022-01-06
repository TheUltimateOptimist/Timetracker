import 'converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  Activity(this.title, this.timeYesterday, this.timeToday);
  String title;
  DateTime? _start;
  final int timeYesterday;
  int timeToday;

  void start() {
    _start = DateTime.now();
  }

  String getTimeEllapsed() {
    return Converter.toMyTime(
        DateTime.now().difference(_start ?? DateTime.now()).inSeconds);
  }

  void stop() {
    timeToday += DateTime.now().difference(_start ?? DateTime.now()).inSeconds;
  }

  String getTimeToday(){
    return Converter.toMyTime(timeToday);
  }

  void printSome(){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference coll = firestore.collection("activitys");
  }

  String getTimeYesterday(){
    return Converter.toMyTime(timeYesterday);
  }
}

class Activitys {
  Activitys(this._activitys);

  List<Activity> _activitys;

  void add(String title, int timeYesterday, int timeToday) {
    _activitys.add(
      Activity(
        title,
        timeYesterday,
        timeToday,
      ),
    );
  }

  void remove(int index) {
    _activitys.remove(index);
  }

  void relocateActivity(int index, int newIndex) {
    Activity relevantActivity = _activitys[index];
    _activitys.removeAt(index);
    _activitys.insert(newIndex, relevantActivity);
  }

  Activity getActivity(int index) {
    return _activitys[index];
  }

  int getLength() {
    return _activitys.length;
  }
}
