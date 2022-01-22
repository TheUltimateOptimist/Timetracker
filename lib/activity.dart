import 'package:time/database.dart';

class Activity{
  late String _id;
  late List<String> _ancestorIds;
  late List<Map<String, String>> _children;
  List<Map<String, int>> _entrys = [];
  DateTime? _timeBorder;
  late String _title;

  Activity({required String id, required String title, required List<String> ancestorIds, required List<Map<String, String>> children}){
    _id = id;
    _title = title;
    _ancestorIds = ancestorIds;
    _children = children;
  }

  String get title{
    return _title;
  }

  List<Map<String, String>> get children{
    return _children;
  }
  int get numberOfChildren{
    return _children.length;
  }

  Map<String, String> getChild(int index){
    return _children[index];
  }

  String get id{
    return _id;
  }

  List<String> get ancestorIds{
    return _ancestorIds;
  }

Future<int> getDuration(final int days, {final bool isExact = false}) async{
    final DateTime now = DateTime.now();
    final DateTime startDate = now.subtract(Duration(days: days));
    return await _getDuration(timeBorder: DateTime(startDate.year, startDate.month, startDate.day), oneDayOnly: isExact);
  }

 Future<int> _getDuration({required final DateTime timeBorder, final bool oneDayOnly = false}) async{
   await _queryEntrys(newTimeBorder: timeBorder);
   int duration = 0;
   for(Map<String,int> entry in _entrys){
     if(entry["start"]! > timeBorder.millisecondsSinceEpoch){
       duration+=entry["duration"]!;
     }
   }
   return duration;
  }

  Future<void> _queryEntrys({required final DateTime newTimeBorder}) async{
    if(_timeBorder == null || newTimeBorder.isBefore(_timeBorder!)){
      _entrys = await DataBase().getEntrys(_id, newTimeBorder);
      _timeBorder = newTimeBorder;
    } 
  }

  Future<void> addActivity(final String name) async{
    await DataBase().insertActivity(name, this);
  }

  Future<void> removeSubActivity(final String name) async{
    print(name);
    for(var child in _children){
      if(child["name"] == name){
        print("found");
        await DataBase().removeActivity(child["id"]!);
      }
    }
    _children.removeWhere((element) => element["name"] == name);
    await DataBase().updateChildren(_children, _id);
  }

  Future<Map<String, int>> getDurationYesToday() async{
    final int durationYesterday = await getDuration(1, isExact: true);
    final int durationToday = await getDuration(0, isExact: true);
    return {"durationToday": durationToday, "durationYesterday": durationYesterday};
  }

  void start(){

  }

  void stop(){

  }

  int getTimeEllapsed(){
    return 1000;
  }
}