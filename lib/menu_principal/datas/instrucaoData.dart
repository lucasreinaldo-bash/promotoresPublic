import 'package:cloud_firestore/cloud_firestore.dart';

class InstrucaoData {
  String title, mensagem, id;

  InstrucaoData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    mensagem = snapshot.data["mensagem"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "mensagem": mensagem,
    };
  }
}
