import 'package:cloud_firestore/cloud_firestore.dart';

class PesquisaData {
  String id,
      dataCriacao,
      dataFinal,
      dataInicial,
      empresaResponsavel,
      linhaProduto,
      nomeLoja,
      nomePromotor,
      observacao,
      nomeRede,
      status;
  int dataQuery;

  PesquisaData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    dataCriacao = snapshot.data["dataCriacao"];
    dataFinal = snapshot.data["dataFinal"];
    dataInicial = snapshot.data["dataInicial"];
    nomeRede = snapshot.data["nomeRede"];
    empresaResponsavel = snapshot.data["empresaResponsavel"];
    linhaProduto = snapshot.data["linhaProduto"];
    nomeLoja = snapshot.data["nomeLoja"];
    nomePromotor = snapshot.data["nomePromotor"];
    observacao = snapshot.data["observacao"];
    status = snapshot.data["status"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "dataCriacao": dataCriacao,
      "dataFinal": dataFinal,
      "dataInicial": dataInicial,
      "empresaResponsavel": empresaResponsavel,
      "linhaProduto": linhaProduto,
      "nomeLoja": nomeLoja,
      "nomePromotor": nomePromotor,
      "observacao": observacao,
      "status": status,
      "nomeRede": nomeRede
    };
  }
}
