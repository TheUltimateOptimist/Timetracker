import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';

enum IdentificationType{
  directChild,
  indirectChild,
  noChildren,
  atRoot
}

class DataBase {
  late CollectionReference activitysCollection;
  late CollectionReference entrysCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DataBase._privateConstructor();
  static final DataBase _instance = DataBase._privateConstructor();
  factory DataBase() => _instance;

  void initialize() {
    activitysCollection = firestore.collection("activitys");
    entrysCollection = firestore.collection("entrys");
  }

  Future<void> insertEntry(List<String> bindedIds, int start, int duration) async {
    await entrysCollection.add({"activityIds": bindedIds, "start": start, "duration": duration});
  }

  Future<String> insertActivity(String name, Activity originActivity) async {
    final DocumentReference addedDoc = await activitysCollection
        .add({"name": name, "ancestorIds": originActivity.ancestorIds + [originActivity.id], "children": null, "directAncestorId": originActivity.id});
    List<Map<String, String>> children = originActivity.children;
    children.add({"name": name, "id": addedDoc.id});
    await activitysCollection
        .doc(originActivity.id)
        .update({"children": children});
    return addedDoc.id;
  }

  Future<void> removeActivity(String id) async {
    //rel... relevant
    List<String> relActIds = [id];
    var relActDocs = (await activitysCollection
            .where("ancestorIds", arrayContains: id)
            .get())
        .docs;
    for (var doc in relActDocs) {
      relActIds.add(doc.id);
    }
    for (String relId in relActIds) {
      await activitysCollection.doc(relId).delete();
      var relEntryDocs = (await entrysCollection.where("activityIds", arrayContains: relId).get()).docs;
      for(var relEntry in relEntryDocs){
        entrysCollection.doc(relEntry.id).delete();
      }
    }
  }

  Future<void> updateChildren(
      List<Map<String, String>> newChildren, String id) async {
    await activitysCollection.doc(id).update({"children": newChildren});
  }

  Future<Activity> getActivity(String id) async {
    DocumentReference document = activitysCollection.doc(id);
    Map<String, dynamic> docData =
        (await document.get()).data() as Map<String, dynamic>;
    List<String> ancestorIds = List.empty(growable: true);
    List<Map<String, String>> children = List.empty(growable: true);
    if(docData["ancestorIds"] != null){
    for (var ancestorId in docData["ancestorIds"]) {
      ancestorIds.add(ancestorId);
      }
    }
    if (docData["children"] != null) {
      for (var child in docData["children"]) {
        children.add({"name": child["name"], "id": child["id"]});
      }
    }
    return Activity(
        id: id,
        title: docData["name"],
        ancestorIds: ancestorIds,
        children: children);
  }

  Future<List<Map<String, String>>> getActivityGroup(IdentificationType identificationType, {String? ancestorId}) async{
      if((identificationType == IdentificationType.directChild || identificationType == IdentificationType.indirectChild) && ancestorId == null){
          throw Exception("ERROR: ancestorId is null while the given IdentificationType requires an ancestorId");
        }
        List<Map<String, String>> activityGroup = List.empty(growable: true);
        List<QueryDocumentSnapshot<Object?>> relDocs;
    switch(identificationType){
      case IdentificationType.directChild: {
        relDocs = (await activitysCollection.where("directAncestorId", isEqualTo: ancestorId).get()).docs;
      }
      break;
      case IdentificationType.indirectChild: {
        relDocs = (await activitysCollection.where("ancestorIds", arrayContains: ancestorId).get()).docs;
      }
      break;
      case IdentificationType.noChildren: {
        relDocs = (await activitysCollection.where("children", isNull: true).get()).docs;
      }
      break;
      case IdentificationType.atRoot: {
        relDocs = (await activitysCollection.where("directAncestorId", isEqualTo: "root").get()).docs;
      }
      break;
      default: relDocs = [];
    }
      for(var doc in relDocs){
          activityGroup.add({"id": doc.id, "name": doc["name"]});
        }
      return activityGroup;
  }

  Future<List<Map<String, int>>> getEntrys(
      String id, DateTime timeBorder) async {
    List<Map<String, int>> entrys = List.empty(growable: true);
    var entryDocs = (await entrysCollection.where("activityIds", arrayContains: id).get()).docs;
    print(entryDocs.length);
    print(entryDocs);
      for (var doc in entryDocs) {
        print(doc);
        print(doc.data());
        var docData = doc.data() as Map<String, dynamic>;
        if(docData["start"]! > timeBorder.millisecondsSinceEpoch){
        entrys.add(
            {"start": docData["start"]!, "duration": docData["duration"]!});}
      }
      return entrys;
    }

// Future<Map<String, int>> getCircleDiagrammData(IdentificationType identificationType, DateTime date, {bool isExact = true}) async{
//   Map<String, int> result = {};
//   late List<Map<String, String>> activitys; 
//   if(identificationType == IdentificationType.atRoot){
//     activitys = await getActivityGroup(identificationType);
//   }
//   else if(identificationType == IdentificationType.noChildren){
//     activitys = await getActivityGroup(identificationType);
//   }
//   for(var activity in activitys){
    
//   }

// }
// Future<Map<String, int>> getDurations(int days, {bool isExact = false, int durationMinimum = 120, bool getMin = true}) async{
//   Map<String, int> durations = {};
//   List<QueryDocumentSnapshot<Object?>> docs;
//   if(getMin){
//     docs = (await activitysCollection.where("children", isNull: true).get()).docs;
//   }
//   else if(!getMin){
//     firestore.co
//     docs = (await activitysCollection.where)
//   }
// }
}
