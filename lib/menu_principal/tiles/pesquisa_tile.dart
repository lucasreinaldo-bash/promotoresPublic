import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart' as da;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:path/path.dart' as path;
import '../../models/user_manager.dart';
import '../detalhamentoPesquisa.dart';
import '../home_menu.dart';
import 'package:provider/provider.dart';

class PesquisaTile extends StatefulWidget {
  PesquisaData data;

  BuildContext contextHome;
  PesquisaTile(this.data, this.contextHome);

  @override
  _PesquisaTileState createState() =>
      _PesquisaTileState(this.data, this.contextHome);
}

class _PesquisaTileState extends State<PesquisaTile> {
  PesquisaData data;
  bool corApertou;

  BuildContext contextHome;
  List list = new List();
  Color colorCard = Color(0xFF365BE5);
  Color colorCardFiltro = Color(0xFF8E1FF3);
  Color colorFloating = Color(0xFF4388F8);
  Color verdeClaro = Color(0xFF4FCEB6);
  _PesquisaTileState(this.data, this.contextHome);
  @override
  Widget build(contextHome) {
    return InkWell(
      onLongPress: () {
        uploadImagemFirestore(data);
        setState(() {
          if (corApertou == true) {
            corApertou = false;
          } else {
            corApertou = true;

            setState(() {});
          }
        });
      },
      onTap: () async {
        context.read<ResearchManager>().setResearch(data);

        Navigator.pushNamed(context, "/detalhamentoPesquisa");
//
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6, left: 6),
        child: Card(
          elevation: 2,
          color: corApertou == true ? Colors.white60 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "" +
                                  data.nomeLoja.toUpperCase() +
                                  "\nRede: " +
                                  data.nomeRede +
                                  "\nPromotor: " +
                                  data.nomePromotor,
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 30,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.tag.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    return Card(
                                        color: data.tag[index]
                                                    .contains("NÃO APROVADA") ||
                                                data.tag[index].contains(
                                                    "VENCIMENTOS PRÓXIMOS")
                                            ? Colors.red
                                            : verdeClaro,
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  data.tag[index],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "QuickSand",
                                                      fontSize: 6,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            )));
                                  },
                                )),
                          ),
                          Text(
                            data.dataInicial == "sem data inicial"
                                ? "Não Agendada"
                                : "Agendada: " + data.dataInicial,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "QuickSand",
                                fontSize: 10,
                                color: Colors.black54),
                          ),
                          Text(
                            data.dataFinalizacao == "pesquisa não respondida"
                                ? "Não Finalizada"
                                : "Finalizada: " + data.dataFinalizacao,
                            style: TextStyle(
                                fontFamily: "QuickSand",
                                fontSize: 10,
                                color: Colors.black54),
                          ),
                          Text(
                            "" + data.status,
                            style: TextStyle(
                                fontFamily: "QuickSand",
                                fontSize: 10,
                                color: Colors.black54),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: (data.imagemUpload != null &&
                                        data.imagemUpload == true)
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadImagemFirestore(PesquisaData data) async {
    for (int i = 0; i < data.linhaProduto.length; i++) {
      DocumentReference imagemAntes = await Firestore.instance
          .collection("Empresas")
          .document(data.empresaResponsavel)
          .collection("pesquisasCriadas")
          .document(data.id)
          .collection("imagensLinhas")
          .document(data.linhaProduto[i])
          .collection("BeforeAreaDeVenda")
          .document("fotoAntesReposicao");

      DocumentReference imagemDepois = await Firestore.instance
          .collection("Empresas")
          .document(data.empresaResponsavel)
          .collection("pesquisasCriadas")
          .document(data.id)
          .collection("imagensLinhas")
          .document(data.linhaProduto[i])
          .collection("AfterAreaDeVenda")
          .document("fotoDepoisReposicao");

      DocumentReference pontoExtra = await Firestore.instance
          .collection("Empresas")
          .document(data.empresaResponsavel)
          .collection("pesquisasCriadas")
          .document(data.id)
          .collection("pontoExtra")
          .document(data.linhaProduto[i]);

      try {
        imagemAntes.get().then((doc) => {
              if (doc.exists)
                {uploadStorage(imagemAntes, doc.data["imagem"])}
              else
                {
                  print("Nao Existe")
                  // doc.data() will be undefined in this case
                }
            });
        imagemDepois.get().then((doc) => {
              if (doc.exists)
                {uploadStorage(imagemAntes, doc.data["imagem"])}
              else
                {
                  print("Nao Existe")
                  // doc.data() will be undefined in this case
                }
            });

        pontoExtra.get().then((doc) => {
              if (doc.exists)
                {
                  if (doc.data["existe"] == true)
                    {
                      uploadPontoExtraBeforeStorage(
                          imagemAntes, doc.data["imagemAntes"]),
                      uploadPontoExtraAfterStorage(
                          imagemAntes, doc.data["imagemDepois"])
                    }
                }
              else
                {
                  print("Nao Existe")
                  // doc.data() will be undefined in this case
                }
            });

        await Firestore.instance
            .collection("Empresas")
            .document(data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(data.id)
            .updateData({"imagemUpload": true});
      } catch (e) {
        print(e);
      }
    }
  }

  uploadStorage(DocumentReference reference, String imagemPath) async {
    String filName = path.basename(imagemPath);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(imagemPath));

    String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    reference.updateData({"imagem": docUrl});
    print(docUrl);
  }

  uploadPontoExtraBeforeStorage(
      DocumentReference reference, String imagemPath) async {
    String filName = path.basename(imagemPath);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(imagemPath));

    String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    reference.updateData({"imagemAntes": docUrl});
    print(docUrl);
  }

  uploadPontoExtraAfterStorage(
      DocumentReference reference, String imagemPath) async {
    String filName = path.basename(imagemPath);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(imagemPath));

    String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    reference.updateData({"imagemDepois": docUrl});
    print(docUrl);
  }
}
