import 'package:cloud_firestore/cloud_firestore.dart';

class PesquisaData {
  String id,
      dataCriacao,
      dataFinal,
      dataInicial,
      empresaResponsavel,
      nomeLoja,
      nomePromotor,
      observacao,
      enderecoLoja,
      nomeRede,
      status;
  int dataQuery;

  List linhaProduto = new List();

  PesquisaData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    dataCriacao = snapshot.data["dataCriacao"];
    dataFinal = snapshot.data["dataFinal"];
    dataInicial = snapshot.data["dataInicial"];
    nomeRede = snapshot.data["nomeRede"];
    enderecoLoja = snapshot.data["enderecoLoja"];
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
      "nomeRede": nomeRede,
      "enderecoLoja": enderecoLoja
    };
  }
}
