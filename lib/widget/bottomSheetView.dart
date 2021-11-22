import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/product_tile_ruptura_screen.dart';
import 'package:versaoPromotores/menu_principal/product_tile_validade_screen.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/styles/colors.dart';

class BottomSheetView extends StatefulWidget {
  String nomeCategoria;

  BottomSheetView(this.nomeCategoria);
  @override
  _BottomSheetViewState createState() =>
      _BottomSheetViewState(this.nomeCategoria);
}

class _BottomSheetViewState extends State<BottomSheetView> {
  String textoBtnPontoExtra = "Não";
  String textoBtnValidadeProxima = "Não";
  String textoBtnRuptura = "Não";
  File _image;

  String imagemAntes = "sem imagem";
  String imagemAntesPontoExtra = "sem imagem";
  String nomeCategoria;
  bool clickInicialPontoExtra = false,
      clickInicialValidade = false,
      clickInicialRuptura = false;

  _BottomSheetViewState(this.nomeCategoria);
  @override
  Widget build(BuildContext context) {
    return Consumer<ResearchManager>(
      builder: (_, researchManager, __) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Foto da aréa de venda:",
                                textAlign: TextAlign.left,
                              )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                getImage(false, nomeCategoria);
                              },
                              child: Container(
                                width: 200,
                                height: 90,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(8),
                                            child: imagemAntes == "sem imagem"
                                                ? Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Image.asset(
                                                      "assets/cam.png",
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  )
                                                : imagemAntes == "carregando"
                                                    ? Container(
                                                        height: 100,
                                                        width: 300,
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
                                                    : Image.file(
                                                        File(imagemAntes),
                                                        height: 100,
                                                        width: 300,
                                                      )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //Temos Ponto Extra ?
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Temos ponto extra ?",
                                textAlign: TextAlign.left,
                              )),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  clickInicialPontoExtra = true;
                                  setState(() {
                                    textoBtnPontoExtra == "Não"
                                        ? textoBtnPontoExtra = "Não"
                                        : textoBtnPontoExtra = "Não";
                                  });
                                  DocumentReference documentReference =
                                      Firestore.instance
                                          .collection("Empresas")
                                          .document(researchManager
                                              .data.empresaResponsavel)
                                          .collection("pesquisasCriadas")
                                          .document(researchManager.data.id)
                                          .collection("pontoExtra")
                                          .document(nomeCategoria);

                                  documentReference.updateData(
                                    {
                                      "existe": false,
                                      "imagemAntes": "nenhuma",
                                      "imagemDepois": "nenhuma",
                                    },
                                  );

                                  setState(() {
                                    imagemAntesPontoExtra = "sem imagem";
                                  });
                                },
                                child: Card(
                                  color: clickInicialPontoExtra == true
                                      ? textoBtnPontoExtra == "Não"
                                          ? Color(0xFFF26768)
                                          : Color(0xFFFFFFFF)
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
                                            color: clickInicialPontoExtra ==
                                                    true
                                                ? textoBtnPontoExtra == "Não"
                                                    ? Color(0xFFFFFFFF)
                                                    : Color(0xFF707070)
                                                : Color(0xFF707070)),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    textoBtnPontoExtra == "Não"
                                        ? textoBtnPontoExtra = "Sim"
                                        : textoBtnPontoExtra = "Sim";
                                  });
                                  DocumentReference documentReference =
                                      Firestore.instance
                                          .collection("Empresas")
                                          .document(researchManager
                                              .data.empresaResponsavel)
                                          .collection("pesquisasCriadas")
                                          .document(researchManager.data.id)
                                          .collection("pontoExtra")
                                          .document(nomeCategoria);

                                  documentReference.updateData(
                                    {
                                      "existe": true,
                                      "imagem": "nenhuma",
                                    },
                                  );
                                },
                                child: Card(
                                  color: textoBtnPontoExtra == "Sim"
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
                                          color: textoBtnPontoExtra == "Sim"
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
                        textoBtnPontoExtra == "Sim"
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      getImagePontoExtra(false, nomeCategoria);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(8),
                                                child: imagemAntesPontoExtra ==
                                                        "sem imagem"
                                                    ? Container(
                                                        height: 90,
                                                        width: 200,
                                                        child: Image.asset(
                                                          "assets/cam.png",
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                      )
                                                    : imagemAntesPontoExtra ==
                                                            "carregando"
                                                        ? Container(
                                                            height: 100,
                                                            width: 300,
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
                                                        : Image.file(
                                                            File(
                                                                imagemAntesPontoExtra),
                                                            height: 100,
                                                            width: 300,
                                                          )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "(adicione uma foto do ponto extra)",
                                    style: TextStyle(
                                        fontFamily: "QuickSandRegular",
                                        fontSize: 10),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )
                            : Container(),

                        //Produtos com validade Proxima
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Existe algum produto com validade próxima?",
                                textAlign: TextAlign.left,
                              )),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  clickInicialValidade = true;

                                  setState(() {
                                    textoBtnValidadeProxima == "Não"
                                        ? textoBtnValidadeProxima = "Não"
                                        : textoBtnValidadeProxima = "Não";
                                  });
                                },
                                child: Card(
                                  color: clickInicialValidade == true
                                      ? textoBtnValidadeProxima == "Não"
                                          ? Color(0xFFF26768)
                                          : Color(0xFFFFFFFF)
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
                                            color: clickInicialValidade == true
                                                ? textoBtnValidadeProxima ==
                                                        "Não"
                                                    ? Color(0xFFFFFFFF)
                                                    : Color(0xFF707070)
                                                : Color(0xFF707070)),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  clickInicialValidade = true;

                                  setState(() {
                                    textoBtnValidadeProxima == "Não"
                                        ? textoBtnValidadeProxima = "Sim"
                                        : textoBtnValidadeProxima = "Sim";
                                  });
                                },
                                child: Card(
                                  color: textoBtnValidadeProxima == "Sim"
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
                                          color:
                                              textoBtnValidadeProxima == "Sim"
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
                        textoBtnValidadeProxima == "Sim"
                            ? Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          "Informe quais e suas respectivas datas",
                                          textAlign: TextAlign.left,
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print(nomeCategoria);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductTileValidadeScreen(
                                                      researchManager.data,
                                                      nomeCategoria)));
                                    },
                                    child: Card(
                                      color: textoBtnValidadeProxima == "Sim"
                                          ? Color(0xFFFFFFFF)
                                          : Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                            "Adicionar",
                                            style: TextStyle(
                                                color:
                                                    textoBtnValidadeProxima ==
                                                            "Não"
                                                        ? Color(0xFFFFFFFF)
                                                        : Color(0xFF707070)),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, bottom: 1, top: 8),
                                  child: Text(
                                    "Existe algum produto com poucas unidades na área de venda?",
                                    textAlign: TextAlign.left,
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 1, right: 8, bottom: 8, top: 1),
                                child: Text(
                                  "(Produtos com menos de x uni. na área de venda)",
                                  style: TextStyle(
                                      fontFamily: "Helvetica",
                                      fontSize: 10,
                                      color: Colors.black),
                                  textAlign: TextAlign.left,
                                )),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      clickInicialRuptura = true;
                                      setState(() {
                                        textoBtnRuptura == "Não"
                                            ? textoBtnRuptura = "Não"
                                            : textoBtnRuptura = "Não";
                                      });
                                    },
                                    child: Card(
                                      color: clickInicialRuptura == true
                                          ? textoBtnRuptura == "Não"
                                              ? Color(0xFFF26768)
                                              : Color(0xFFFFFFFF)
                                          : Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                            "Não",
                                            style: TextStyle(
                                                color: clickInicialRuptura ==
                                                        true
                                                    ? textoBtnRuptura == "Não"
                                                        ? Color(0xFFFFFFFF)
                                                        : Color(0xFF707070)
                                                    : Color(0xFF707070)),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        textoBtnRuptura == "Não"
                                            ? textoBtnRuptura = "Sim"
                                            : textoBtnRuptura = "Sim";
                                      });
                                    },
                                    child: Card(
                                      color: textoBtnRuptura == "Sim"
                                          ? verdeClaro
                                          : Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                            "Sim",
                                            style: TextStyle(
                                              color: textoBtnRuptura == "Sim"
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
                          ],
                        ),
                        textoBtnRuptura == "Sim"
                            ? Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          "Informe os produtos com ruptura",
                                          textAlign: TextAlign.left,
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductTileRupturaScreen(
                                                      researchManager.data,
                                                      nomeCategoria)));
                                    },
                                    child: Card(
                                      color: textoBtnValidadeProxima == "Sim"
                                          ? Color(0xFFFFFFFF)
                                          : Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                            "Adicionar",
                                            style: TextStyle(
                                                color: textoBtnRuptura == "Não"
                                                    ? Color(0xFFFFFFFF)
                                                    : Color(0xFF707070)),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancelar",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54),
                          ),
                        ),
                        GestureDetector(
                          onTap: imagemAntes != "sem imagem" &&
                                  (textoBtnPontoExtra == "Sim"
                                      ? imagemAntesPontoExtra != "sem imagem"
                                      : textoBtnPontoExtra == "Não")
                              ? () async {
                                  DocumentReference documentReference =
                                      Firestore.instance
                                          .collection("Empresas")
                                          .document(researchManager
                                              .data.empresaResponsavel)
                                          .collection("pesquisasCriadas")
                                          .document(researchManager.data.id)
                                          .collection(
                                              "linhasProdutosAntesReposicao")
                                          .document(nomeCategoria);

                                  documentReference.updateData({
                                    "concluida": true,
                                    "nomeLinha": nomeCategoria
                                  });

                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Text(
                            "Salvar",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {
        imagemAntes = "carregando";
      });
      DocumentReference documentReference = await Firestore.instance
          .collection("Empresas")
          .document(context.read<ResearchManager>().data.empresaResponsavel)
          .collection("pesquisasCriadas")
          .document(context.read<ResearchManager>().data.id)
          .collection("imagensLinhas")
          .document(categoria)
          .collection("BeforeAreaDeVenda")
          .document("fotoAntesReposicao");
      documentReference.setData({"imagem": _image.path, "upload": false});
      setState(() {
        imagemAntes = _image.path;
      });
    } else {
      print('No image selected.');
    }
  }

  Future getImagePontoExtra(bool gallery, String categoria) async {
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
      imagemAntesPontoExtra = "carregando";
    });
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      print("tem imagem aqui");
      DocumentReference documentReference = await Firestore.instance
          .collection("Empresas")
          .document(context.read<ResearchManager>().data.empresaResponsavel)
          .collection("pesquisasCriadas")
          .document(context.read<ResearchManager>().data.id)
          .collection("pontoExtra")
          .document(nomeCategoria);

      documentReference.updateData(
        {"existe": true, "imagemAntes": _image.path, "upload": false},
      );
      setState(() {
        imagemAntesPontoExtra = _image.path;
      });
      //_image = File(pickedFile.path); // Use if you only need a single picture
    } else {
      print('No image selected.');
    }
  }
}
