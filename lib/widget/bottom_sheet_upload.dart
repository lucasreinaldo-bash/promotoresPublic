import 'dart:io';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/product_tile_ruptura_screen.dart';
import 'package:versaoPromotores/menu_principal/product_tile_validade_screen.dart';
import 'package:versaoPromotores/styles/colors.dart';

class BottomSheetUpload extends StatefulWidget {
  PesquisaData data;

  BottomSheetUpload(this.data);
  @override
  _BottomSheetUploadState createState() => _BottomSheetUploadState(this.data);
}

class _BottomSheetUploadState extends State<BottomSheetUpload> {
  final _observacaoController = TextEditingController();

  _BottomSheetUploadState(this.data);
  PesquisaData data;
  bool carregando = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadImagemFirestore(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Center(
              child: carregando == false
                  ? Column(
                      children: [
                        Text("Realizando o Envio da Pesquisa"),
                        SizedBox(
                          height: 10,
                        ),
                        LinearProgressIndicator(
                          minHeight: 5,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Text("Pesquisa enviada com sucesso!"),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          child: Center(
                              child: FlareActor("assets/success_check.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: "Untitled")),
                        ),
                      ],
                    ),
            )));
  }

  Future uploadImagemFirestore(PesquisaData data) async {
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
    setState(() {
      carregando = true;
    });
  }

  Future uploadStorage(DocumentReference reference, String imagemPath) async {
    String filName = path.basename(imagemPath);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(imagemPath));

    String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    reference.updateData({"imagem": docUrl});
    print(docUrl);
  }

  Future uploadPontoExtraBeforeStorage(
      DocumentReference reference, String imagemPath) async {
    String filName = path.basename(imagemPath);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(imagemPath));

    String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    reference.updateData({"imagemAntes": docUrl});
    print(docUrl);
  }

  Future uploadPontoExtraAfterStorage(
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
