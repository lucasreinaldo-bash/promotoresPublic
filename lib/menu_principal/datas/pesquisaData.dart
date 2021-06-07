import 'package:cloud_firestore/cloud_firestore.dart';

class PesquisaData {
  String id,
      idPromotor,
      dataCriacao,
      dataFinal,
      dataInicial,
      empresaResponsavel,
      nomeLoja,
      nomePromotor,
      comentarioPromotor,
      observacao,
      dataFinalizacao,
      nomeRede,
      status;
  int dataQuery, data_query_finalizada;
  List tag;
  bool aceita, imagemUpload;

  List linhaProduto = new List();
  PesquisaData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    aceita = snapshot.data["aceita"];
    imagemUpload = snapshot.data["imagemUpload"] ?? false;
    dataCriacao = snapshot.data["dataCriacao"];
    dataFinal = snapshot.data["dataFinal"];
    dataFinalizacao = snapshot.data["dataFinalizacao"];
    data_query_finalizada = snapshot.data["data_query_finalizada"];
    dataInicial = snapshot.data["dataInicial"];
    nomeRede = snapshot.data["nomeRede"];
    idPromotor = snapshot.data["idPromotor"];
    empresaResponsavel = snapshot.data["empresaResponsavel"];
    linhaProduto = snapshot.data["linhaProduto"];
    nomeLoja = snapshot.data["nomeLoja"];
    tag = snapshot.data["tag"];
    nomePromotor = snapshot.data["nomePromotor"];
    observacao = snapshot.data["observacao"];
    status = snapshot.data["status"];
    comentarioPromotor = snapshot.data["comentarioPromotor"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "dataCriacao": dataCriacao,
      "dataFinal": dataFinal,
      "dataInicial": dataInicial,
      "aceita": aceita,
      "dataFinalizacao": dataFinalizacao,
      "data_query_finalizada": data_query_finalizada,
      "empresaResponsavel": empresaResponsavel,
      "linhaProduto": linhaProduto,
      "nomeLoja": nomeLoja,
      "nomePromotor": nomePromotor,
      "observacao": observacao,
      "status": status,
      "tag": tag,
      "nomeRede": nomeRede,
      "comentarioPromotor": comentarioPromotor,
      "imagemUpload": imagemUpload
    };
  }
}
