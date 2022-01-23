//this file contains the implementation of all SharedPreferences that are needed throughout the app

//packages:
import 'package:shared_preferences/shared_preferences.dart';

///manages all SharedPreferences
class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }
  UserPreferences._ctor();
  late SharedPreferences _p;

  ///initializes the SharedPreferences
  init() async {
    _p = await SharedPreferences.getInstance();
  }

  set isActivityRunning(bool isRunning){
    _p.setBool("isRunning", isRunning);
  }

  bool get isActivityRunning{
    return _p.getBool("isRunning") ?? false;
  }

  set activityStart(int activityStart){
    _p.setInt("activityStart", activityStart);
  }

  int get activityStart{
    int? start = _p.getInt("activityStart");
    if(start == null){
      throw Exception("ERROR: No time for the activity start could be retrieved!!");
    }
    return start;
  }

  set runningActivityId(String id){
    _p.setString("runningActivityId", id);
  }

  String get runningActivityId{
    return _p.getString("runningActivityId")!;
  }

}