
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';
class DataBase{
  late CollectionReference activitysCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DataBase._privateConstructor();
  static final DataBase _instance = DataBase._privateConstructor();
  factory DataBase() => _instance;

void initialize(){
  activitysCollection = firestore.collection("activitys");
}

void insertEntry(String id, DateTime start, int duration) async{
  await activitysCollection.doc(id).collection("entrys").doc().set({"start": start.millisecondsSinceEpoch, "duration": duration});
}

Future<String> insertActivity(String name, Activity originActivity) async{
  List<String> ancestorIds = originActivity.ancestorIds;
  ancestorIds.add(originActivity.id);
 final DocumentReference addedDoc =  await activitysCollection.add({"name": name, "ancestorIds": ancestorIds, "children": []});
 List<Map<String, String>> children = originActivity.children;
 children.add({"name": name, "id": addedDoc.id});
 await activitysCollection.doc(originActivity.id).update({"children": children});
 print("1");
 print(originActivity.children);
 return addedDoc.id;
}

Future<void> removeActivity(String id) async{
  //rel... relevant
  List<String> relIds = [id];
  var relDocs = (await activitysCollection.where("ancestorIds", arrayContains: id).get()).docs;
  for(var doc in relDocs){
    relIds.add(doc.id);
  }
  for(String relId in relIds){
    print(relId + "deleted");
    await activitysCollection.doc(relId).delete();
  }
}

Future<void> updateChildren(List<Map<String, String>> newChildren, String id) async{
 await activitysCollection.doc(id).update({"children": newChildren});
}

Future<Activity> getActivity(String id) async{
  DocumentReference document = activitysCollection.doc(id);
  Map<String, dynamic> docData = (await document.get()).data() as Map<String, dynamic>;
  List<String> ancestorIds = List.empty(growable: true);
  List<Map<String, String>> children = List.empty(growable: true);
  for(var ancestorId in docData["ancestorIds"]){
    ancestorIds.add(ancestorId);
  }
  for(var child in docData["children"]){
    children.add({"name": child["name"], "id": child["id"]});
  }
  print(docData["children"]);
  print(children);
  print(children.length);
  return Activity(id: id, title: docData["name"], ancestorIds: ancestorIds, children: children);
}

Future<List<Map<String, int>>> getEntrys(String id, DateTime timeBorder) async{
  List<Map<String, int>> entrys = List.empty(growable: true);
  List<String> relevantDocIds = [id];
  var subDocs = (await activitysCollection.where("ancestorIds", arrayContains: id).get()).docs;
  for(var doc in subDocs){
    relevantDocIds.add(doc.id);
  }
  for(String docId in relevantDocIds){
    var entryDocs = (await activitysCollection.doc(docId).collection("entrys").where("start", isGreaterThanOrEqualTo: timeBorder.millisecondsSinceEpoch).get()).docs;
    for(var doc in entryDocs){
      var docData = doc.data() as Map<String, int>;
      entrys.add({"start": docData["start"]!, "duration": docData["duration"]!});
    }
  }
  return entrys;
}
}