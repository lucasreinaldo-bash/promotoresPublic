import 'dart:io';
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

class AfterBottomSheetView extends StatefulWidget {
  String nomeCategoria;
  PesquisaData data;

  AfterBottomSheetView(this.nomeCategoria, this.data);
  @override
  _AfterBottomSheetViewState createState() =>
      _AfterBottomSheetViewState(this.nomeCategoria, this.data);
}

class _AfterBottomSheetViewState extends State<AfterBottomSheetView> {
  final _observacaoController = TextEditingController();
  final FocusNode myFocusObservacao = FocusNode();
  String textoBtnPontoExtra = "Não";
  bool novoPedido = false;
  String textoBtnValidadeProxima = "Não";
  String textoBtnRuptura = "Não";
  File _image;
  PesquisaData data;

  String imagemAntes = "sem imagem";
  String imagemAntesPontoExtra = "sem imagem";
  String imagemPontoExtra = "sem imagem";
  String nomeCategoria;

  _AfterBottomSheetViewState(this.nomeCategoria, this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.80,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Foto da aréa de venda:",
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "(Após a reposição)",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              getImage(false, nomeCategoria);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(8),
                                            child: imagemAntes == "sem imagem"
                                                ? Container(
                                                    height: 100,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Image.asset(
                                                      "assets/cam.png",
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  )
                                                : imagemAntes == "carregando"
                                                    ? Container(
                                                        height: 100,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        child: Column(
                                                          children: [
                                                            CircularProgressIndicator(),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                "Aguarde, a sua foto está sendo processada!")
                                                          ],
                                                        ))
                                                    : Image.network(
                                                        imagemAntes,
                                                        height: 100,
                                                        width: 300,
                                                      )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection("Empresas")
                                .document(data.empresaResponsavel)
                                .collection("pesquisasCriadas")
                                .document(data.id)
                                .collection("pontoExtra")
                                .document(nomeCategoria)
                                .snapshots(),
                            builder: (context, snapPonto) {
                              if (!snapPonto.hasData) {
                                return Container();
                              } else {
                                String teste;
                                snapPonto.data["existe"] == false
                                    ? imagemPontoExtra = "sem ponto"
                                    : teste = "sem imagem";
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    snapPonto.data["existe"] == false
                                        ? Container()
                                        : Column(
                                            children: [
                                              ListTile(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Foto ponto extra:",
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    Text(
                                                      "(Após a reposição)",
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  getImagePontoExtra(
                                                      false, nomeCategoria);
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child: imagemPontoExtra ==
                                                                        "sem imagem"
                                                                    ? Container(
                                                                        height:
                                                                            100,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.5,
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/cam.png",
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              50,
                                                                        ),
                                                                      )
                                                                    : imagemPontoExtra ==
                                                                            "carregando"
                                                                        ? Container(
                                                                            height:
                                                                                100,
                                                                            width: MediaQuery.of(context).size.width *
                                                                                0.5,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                CircularProgressIndicator(),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Text("Aguarde, a sua foto está sendo processada!")
                                                                              ],
                                                                            ))
                                                                        : Image
                                                                            .network(
                                                                            imagemPontoExtra,
                                                                            height:
                                                                                100,
                                                                            width:
                                                                                300,
                                                                          )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        title: Text(
                          "É necessário um novo pedido para essa linha de produto?",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  novoPedido = false;
                                });
                                DocumentReference documentReference =
                                    await Firestore.instance
                                        .collection("Empresas")
                                        .document(data.empresaResponsavel)
                                        .collection("pesquisasCriadas")
                                        .document(data.id);

                                documentReference.updateData(
                                  {
                                    "tag":
                                        FieldValue.arrayRemove(["Novo Pedido"])
                                  },
                                );

                                DocumentReference documentReferenceLinha =
                                    await Firestore.instance
                                        .collection("Empresas")
                                        .document(data.empresaResponsavel)
                                        .collection("pesquisasCriadas")
                                        .document(data.id)
                                        .collection(
                                            "linhasProdutosAntesReposicao")
                                        .document(nomeCategoria);

                                documentReferenceLinha.updateData(
                                  {
                                    "tags":
                                        FieldValue.arrayRemove(["Novo Pedido"])
                                  },
                                );

                                setState(() {
                                  imagemAntesPontoExtra = "sem imagem";
                                });
                              },
                              child: Card(
                                color: novoPedido == false
                                    ? Color(0xFFF26768)
                                    : Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      "Não",
                                      style: TextStyle(
                                          color: novoPedido == false
                                              ? Color(0xFFFFFFFF)
                                              : Color(0xFF707070)),
                                    ),
                                  )),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  novoPedido = true;
                                });
                                DocumentReference documentReference =
                                    await Firestore.instance
                                        .collection("Empresas")
                                        .document(data.empresaResponsavel)
                                        .collection("pesquisasCriadas")
                                        .document(data.id);

                                documentReference.updateData(
                                  {
                                    "tag":
                                        FieldValue.arrayUnion(["Novo Pedido"])
                                  },
                                );

                                DocumentReference documentReferenceLinha =
                                    await Firestore.instance
                                        .collection("Empresas")
                                        .document(data.empresaResponsavel)
                                        .collection("pesquisasCriadas")
                                        .document(data.id)
                                        .collection(
                                            "linhasProdutosAntesReposicao")
                                        .document(nomeCategoria);

                                documentReferenceLinha.updateData(
                                  {
                                    "tags":
                                        FieldValue.arrayUnion(["Novo Pedido"])
                                  },
                                );
                              },
                              child: Card(
                                color: novoPedido == true
                                    ? verdeClaro
                                    : Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      "Sim",
                                      style: TextStyle(
                                        color: novoPedido == true
                                            ? Color(0xFFFFFFFF)
                                            : Color(0xFF707070),
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        title: Text(
                          "Observação do Promotor",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          decoration: new BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.black12),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              focusNode: myFocusObservacao,
                              enabled: true,
                              maxLines: 5,
                              controller: _observacaoController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 13.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Sua observação",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintStyle: TextStyle(
                                    fontFamily: "Georgia", fontSize: 10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ),
                    GestureDetector(
                      onTap: imagemAntes != "sem imagem" &&
                              (textoBtnPontoExtra == "Sim"
                                  ? imagemAntesPontoExtra != "sem imagem"
                                  : textoBtnPontoExtra == "Não")
                          ? () async {
                              await Firestore.instance
                                  .collection("Empresas")
                                  .document(data.empresaResponsavel)
                                  .collection("pesquisasCriadas")
                                  .document(data.id)
                                  .collection("linhasProdutosAposReposicao")
                                  .document(nomeCategoria)
                                  .updateData({
                                "concluida": true,
                                "nomeLinha": nomeCategoria,
                                "comentario":
                                    _observacaoController.text.length != 0
                                        ? _observacaoController.text
                                        : "Nenhuma",
                              });
                              await Firestore.instance
                                  .collection("Empresas")
                                  .document(data.empresaResponsavel)
                                  .collection("pesquisasCriadas")
                                  .document(data.id)
                                  .collection("linhasProdutosAntesReposicao")
                                  .document(nomeCategoria)
                                  .updateData({
                                "tags":
                                    FieldValue.arrayRemove(["Nova Pesquisa"])
                              });

                              Navigator.of(context).pop();
                            }
                          : null,
                      child: Text(
                        "Salvar",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getImage(bool gallery, String categoria) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 80);
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print("tem imagem aqui");

        //_image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });

    Future uploadPic(BuildContext context) async {
      String filName = path.basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(filName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      setState(() {
        imagemAntes = "carregando";
      });
      String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      setState(() async {
        print(docUrl);
        imagemAntes = docUrl;

        DocumentReference documentReference = await Firestore.instance
            .collection("Empresas")
            .document(data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(data.id)
            .collection("imagensLinhas")
            .document(categoria)
            .collection("AfterAreaDeVenda")
            .document("fotoDepoisReposicao");
        documentReference.setData({"imagem": docUrl});
      });
    }

    uploadPic(context);

    uploadPic(context);
  }

  Future getImagePontoExtra(bool gallery, String nomeCategoria) async {
    setState(() {
      imagemPontoExtra = "sem imagem";
    });
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print("tem imagem aqui");
        Future uploadPic(BuildContext context) async {
          String filName = path.basename(_image.path);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(filName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
          setState(() {
            imagemPontoExtra = "carregando";
          });
          String docUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          print(docUrl);
          imagemPontoExtra = docUrl;

          DocumentReference documentReference = await Firestore.instance
              .collection("Empresas")
              .document(data.empresaResponsavel)
              .collection("pesquisasCriadas")
              .document(data.id)
              .collection("pontoExtra")
              .document(nomeCategoria);
          documentReference.updateData({"imagemDepois": docUrl});
        }

        uploadPic(context);
        //_image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }
}
