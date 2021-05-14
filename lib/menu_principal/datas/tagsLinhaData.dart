import 'package:cloud_firestore/cloud_firestore.dart';

class TagsLinhaData {
  String id;
  List tags;

  TagsLinhaData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;

    tags = snapshot.data["tags"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "tags": tags,
    };
  }
}
