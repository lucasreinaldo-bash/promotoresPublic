import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart' as da;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/drawer/custom_drawer.dart';
import 'package:versaoPromotores/menu_principal/datas/LinhaProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/LojaData.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/detalhamentoPesquisa.dart';
import 'package:versaoPromotores/menu_principal/home_menu.dart';
import 'package:versaoPromotores/menu_principal/product_tile_ruptura_screen.dart';
import 'package:versaoPromotores/menu_principal/product_tile_validade_screen.dart';
import 'package:versaoPromotores/menu_principal/screens/pesquisa_aposReposicao.dart';
import 'package:versaoPromotores/menu_principal/tiles/loja_tile.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_antes_reposicao.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_validade.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/style/style.dart';

import 'datas/PromotorData.dart';
import 'datas/pesquisaData.dart';

class ResponderPesquisaData extends StatefulWidget {
  PesquisaData data;

  ResponderPesquisaData(this.data);

  @override
  _ResponderPesquisaDataState createState() =>
      _ResponderPesquisaDataState(this.data);
}

class _ResponderPesquisaDataState extends State<ResponderPesquisaData> {
  PesquisaData data;
  final _linhaProdutoController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _instrucaoController = TextEditingController();
  final FocusNode myFocusPesquisa = FocusNode();
  final FocusNode myFocusData = FocusNode();
  final FocusNode myFocusNomeLoja = FocusNode();
  final FocusNode myFocusNomePromotor = FocusNode();
  final FocusNode myFocusLinhaProduto = FocusNode();
  final FocusNode myFocusObservacao = FocusNode();
  final FocusNode myFocusInstrucao = FocusNode();

  String idPromotor;
  final int _numPages = 5;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  //Cores

  Color colorCard = Color(0xFF365BE5);

  //Pesquisa

  String dataInicioPesquisa, dataFinalPesquisa, nomeRede;

  //Metodo para setar os buttons

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.purple,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  _ResponderPesquisaDataState(this.data);

//  String textoBtnPontoExtra,
//      textoBtnProdutoValidade,
//      textoBtnProdutoPoucasUnidades = "sem informacao";

  List<String> avancarAntesReposicao;

  String title = "Observações";
  String concluido = "não";

  mudarTitulo(String texto) async {
    title = texto;
  }

  @override
  Widget build(BuildContext context) {
    var lista = new List<int>(data.linhaProduto.length);

    bool pesquisaCompleta() {
      var resultFirstWhere = lista.every((el) => el == 0);

      return resultFirstWhere;
    }

    _observacaoController.text = data.observacao;
    _instrucaoController.text = "Instruções de reposição...";
    return MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('pt'), const Locale('BR')],
        home: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title, style: TextStyle(fontFamily: "QuickSand")),
                centerTitle: true,
                backgroundColor: Colors.deepPurple,
              ),
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: ScopedModelDescendant<UserModel>(
                    builder: (context, child, model) {
                      return StreamBuilder(
                        stream: Firestore.instance
                            .collection("Empresas")
                            .document(model.firebaseUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return SingleChildScrollView(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: new AssetImage(
                                            "assets/fundo_colors.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child:
                                        null /* add child content content here */,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 500.0,
                                                child: Expanded(
                                                  child: PageView(
                                                    allowImplicitScrolling:
                                                        false,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    controller: _pageController,
                                                    onPageChanged: (int page) {
                                                      _currentPage = page;
                                                    },
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 50,
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 50),
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            elevation: 15,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                      height:
                                                                          30.0),
                                                                  SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  Card(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                    ),
                                                                    elevation:
                                                                        10,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            250,
                                                                        child:
                                                                            TextField(
                                                                          focusNode:
                                                                              myFocusObservacao,
                                                                          enabled:
                                                                              true,
                                                                          maxLines:
                                                                              10,
                                                                          controller:
                                                                              _observacaoController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          style: TextStyle(
                                                                              fontFamily: "WorkSansSemiBold",
                                                                              fontSize: 13.0,
                                                                              color: Colors.black),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            enabledBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.white),
                                                                            ),
                                                                            focusedBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.white),
                                                                            ),
                                                                            border:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.white),
                                                                            ),
                                                                            hintStyle:
                                                                                TextStyle(fontFamily: "Georgia", fontSize: 10.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  _currentPage !=
                                                                          _numPages -
                                                                              1
                                                                      ? Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                FractionalOffset.bottomRight,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                FlatButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      title = "Observações";
                                                                                    });
                                                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetalhamentoPesquisa(data)));
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        'Voltar',
                                                                                        style: TextStyle(
                                                                                          fontFamily: "Helvetica",
                                                                                          color: Color(0xFF707070),
                                                                                          fontSize: 22.0,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: 10.0),
                                                                                      Icon(
                                                                                        Icons.arrow_forward,
                                                                                        color: Colors.white,
                                                                                        size: 30.0,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                FlatButton(
                                                                                  onPressed: () async {
                                                                                    _pageController.nextPage(
                                                                                      duration: Duration(milliseconds: 2000),
                                                                                      curve: Curves.fastOutSlowIn,
                                                                                    );

                                                                                    setState(() {
                                                                                      title = "Área de Venda";
                                                                                    });
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        'Avançar',
                                                                                        textAlign: TextAlign.right,
                                                                                        style: TextStyle(
                                                                                          fontFamily: "Helvetica",
                                                                                          color: Color(0xFF707070),
                                                                                          fontSize: 22.0,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          ''),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 50,
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 50),
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            elevation: 15,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Faça a pesquisa para cada linha de produto abaixo antes de iniciar a reposição.",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "QuickSand",
                                                                        color: Color(
                                                                            0xFF000000)),
                                                                  ),
                                                                  ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: data
                                                                              .linhaProduto
                                                                              .length,
                                                                          itemBuilder:
                                                                              (_, index) {
                                                                            String
                                                                                nomeCategoria =
                                                                                data.linhaProduto[index];

                                                                            bool
                                                                                nomeCategoriaBool =
                                                                                false;

                                                                            return InkWell(
                                                                              onTap: () {
//                                                                      showDialog(
//                                                                        context:
//                                                                            context,
//                                                                        builder:
//                                                                            (BuildContext
//                                                                                context) {
//                                                                          // retorna um objeto do tipo Dialog
//                                                                          return AlertDialog(
//                                                                            title:
//                                                                                new Text("Informe os estoques dos produtos abaixo\n(antes da reposição)"),
//                                                                            content:
//                                                                                new Column(
//                                                                              children: [
//                                                                                FutureBuilder(
//                                                                                  future: Firestore.instance.collection("Empresas").document("ydj6RHQ8g1ahwDABJHM9ipb0Wnu1").collection("Produtos").where("nomeLinha", isEqualTo: nomeCategoria).getDocuments(),
//                                                                                  builder: (context, snapshotProdutos) {
//                                                                                    if (!snapshotProdutos.hasData) {
//                                                                                      return LinearProgressIndicator();
//                                                                                    } else {
//                                                                                      return ListView.builder(
//                                                                                          shrinkWrap: true,
//                                                                                          itemCount: snapshotProdutos.data.documents.length,
//                                                                                          itemBuilder: (_, indexProduto) {
//                                                                                            ProductData dataProdutos = ProductData.fromDocument(snapshotProdutos.data.documents[indexProduto]);
//
//                                                                                            return ProdutosTile(data, dataProdutos);
//                                                                                          });
//                                                                                    }
//                                                                                  },
//                                                                                )
//                                                                              ],
//                                                                            ),
//                                                                            actions: <Widget>[
//                                                                              // define os botões na base do dialogo
//                                                                              new FlatButton(
//                                                                                child: new Text("Avançar"),
//                                                                                onPressed: () {
//                                                                                  Navigator.of(context).pop();
//                                                                                  showDialog(
//                                                                                    context: context,
//                                                                                    builder: (BuildContext context) {
//                                                                                      // retorna um objeto do tipo Dialog
//                                                                                      return AlertDialog(
//                                                                                        title: new Text("Instrução"),
//                                                                                        content: new Card(
//                                                                                          shape: RoundedRectangleBorder(
//                                                                                            borderRadius: BorderRadius.circular(10.0),
//                                                                                          ),
//                                                                                          child: Padding(
//                                                                                            padding: EdgeInsets.all(8),
//                                                                                            child: Container(
//                                                                                              height: 250,
//                                                                                              child: TextField(
//                                                                                                focusNode: myFocusObservacao,
//                                                                                                enabled: true,
//                                                                                                maxLines: 10,
//                                                                                                controller: _instrucaoController,
//                                                                                                keyboardType: TextInputType.text,
//                                                                                                style: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 13.0, color: Colors.black),
//                                                                                                decoration: InputDecoration(
//                                                                                                  enabledBorder: UnderlineInputBorder(
//                                                                                                    borderSide: BorderSide(color: Colors.white),
//                                                                                                  ),
//                                                                                                  focusedBorder: UnderlineInputBorder(
//                                                                                                    borderSide: BorderSide(color: Colors.white),
//                                                                                                  ),
//                                                                                                  border: UnderlineInputBorder(
//                                                                                                    borderSide: BorderSide(color: Colors.white),
//                                                                                                  ),
//                                                                                                  hintStyle: TextStyle(fontFamily: "Georgia", fontSize: 10.0),
//                                                                                                ),
//                                                                                              ),
//                                                                                            ),
//                                                                                          ),
//                                                                                        ),
//                                                                                        actions: <Widget>[
//                                                                                          // define os botões na base do dialogo
//                                                                                          new FlatButton(
//                                                                                            child: new Text("Concluir"),
//                                                                                            onPressed: () {
//                                                                                              Navigator.of(context).pop();
//
//                                                                                              DocumentReference documentReference = Firestore.instance.collection("Empresas").document(data.empresaResponsavel).collection("pesquisasCriadas").document(data.id).collection("linhasProdutos").document(nomeCategoria);
//
//                                                                                              documentReference.setData({
//                                                                                                "concluida": true
//                                                                                              }, merge: true);
//                                                                                            },
//                                                                                          ),
//                                                                                        ],
//                                                                                      );
//                                                                                    },
//                                                                                  );
//                                                                                },
//                                                                              ),
//                                                                            ],
//                                                                          );
//                                                                        },
//                                                                      );
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    // retorna um objeto do tipo Dialog
                                                                                    return AfterDialogPesquisa(nomeCategoria, data);
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Card(
                                                                                  elevation: 2,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                                  ),
                                                                                  child: StreamBuilder(
                                                                                    stream: Firestore.instance.collection("Empresas").document(data.empresaResponsavel).collection("pesquisasCriadas").document(data.id).collection("linhasProdutosAntesReposicao").document(nomeCategoria).snapshots(),
                                                                                    builder: (context, snapshotLinhas) {
                                                                                      if (!snapshotLinhas.hasData) {
                                                                                        return Container();
                                                                                      } else {
                                                                                        if (snapshotLinhas.data["concluida"] == false) {
                                                                                          lista[index] = 1;
                                                                                        } else {
                                                                                          lista[index] = 0;
                                                                                        }

                                                                                        return snapshotLinhas.data["concluida"] == true
                                                                                            ? ListTile(
                                                                                                trailing: Card(
                                                                                                  color: Color(0xFF4FCEB6),
                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.all(10),
                                                                                                    child: Text(
                                                                                                      "Concluída",
                                                                                                      style: TextStyle(color: Colors.white, fontFamily: "QuickSandRegular"),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                title: Text(
                                                                                                  "" + nomeCategoria,
                                                                                                  style: TextStyle(fontFamily: "QuickSand", fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                                  textAlign: TextAlign.start,
                                                                                                ),
                                                                                                subtitle: Text(
                                                                                                  "Toque para editar a pesquisa",
                                                                                                  style: TextStyle(fontFamily: "QuickSandRegular", fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                                                                                  textAlign: TextAlign.start,
                                                                                                ),
                                                                                              )
                                                                                            : ListTile(
                                                                                                trailing: Card(
                                                                                                  color: Color(0xFFF26868),
                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.all(10),
                                                                                                    child: Text(
                                                                                                      "A Iniciar",
                                                                                                      style: TextStyle(color: Colors.white, fontFamily: "QuickSandRegular"),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                title: Text(
                                                                                                  "" + nomeCategoria,
                                                                                                  style: TextStyle(fontFamily: "QuickSand", fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                                  textAlign: TextAlign.start,
                                                                                                ),
                                                                                                subtitle: Text(
                                                                                                  "Toque para editar a pesquisa",
                                                                                                  style: TextStyle(fontFamily: "QuickSandRegular", fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                                                                                  textAlign: TextAlign.start,
                                                                                                ),
                                                                                              );
                                                                                      }
                                                                                    },
                                                                                  )),
                                                                            );
                                                                          }),
                                                                  SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  _currentPage !=
                                                                          _numPages -
                                                                              1
                                                                      ? Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                FractionalOffset.bottomRight,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                FlatButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      title = "Observações";
                                                                                    });
                                                                                    _pageController.previousPage(
                                                                                      duration: Duration(milliseconds: 2000),
                                                                                      curve: Curves.fastOutSlowIn,
                                                                                    );
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        'Voltar',
                                                                                        style: TextStyle(
                                                                                          fontFamily: "Helvetica",
                                                                                          color: Color(0xFF707070),
                                                                                          fontSize: 22.0,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: 10.0),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                FlatButton(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          ' Avançar',
                                                                                          style: TextStyle(
                                                                                            fontFamily: "Helvetica",
                                                                                            color: Color(0xFF707070),
                                                                                            fontSize: 22.0,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      bool resultado = await pesquisaCompleta();

                                                                                      if (resultado == true) {
                                                                                        print(true);
                                                                                        setState(() {
                                                                                          title = "Estoque depósito";
                                                                                        });
                                                                                        _pageController.nextPage(
                                                                                          duration: Duration(milliseconds: 500),
                                                                                          curve: Curves.ease,
                                                                                        );
                                                                                      } else {
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (_) => FlareGiffyDialog(
                                                                                                  flarePath: 'assets/seach_cloud.flr',
                                                                                                  flareAnimation: 'products',
                                                                                                  title: Text(
                                                                                                    'Existe pesquisa não respondida!',
                                                                                                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                                                                                                    textAlign: TextAlign.center,
                                                                                                  ),
                                                                                                  description: Text(
                                                                                                    'Você precisa responder todas as pesquisas antes de continuar.',
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(),
                                                                                                  ),
                                                                                                  onOkButtonPressed: () {
                                                                                                    Navigator.pop(_);
                                                                                                  },
                                                                                                  onlyOkButton: true,
                                                                                                  entryAnimation: EntryAnimation.DEFAULT,
                                                                                                ));
                                                                                      }
                                                                                    })
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          ''),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 50,
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 50),
                                                          child: Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            elevation: 15,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Informe os estoques dos produtos abaixo:",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "QuickSand",
                                                                        color: Color(
                                                                            0xFF000000)),
                                                                  ),
                                                                  FutureBuilder(
                                                                    future: Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "Empresas")
                                                                        .document(data
                                                                            .empresaResponsavel)
                                                                        .collection(
                                                                            "Produtos")
                                                                        .getDocuments(),
                                                                    builder:
                                                                        (context,
                                                                            snapshotProdutos) {
                                                                      if (!snapshotProdutos
                                                                          .hasData) {
                                                                        return LinearProgressIndicator();
                                                                      } else {
                                                                        return Container(
                                                                          height:
                                                                              300,
                                                                          child: ListView.builder(
                                                                              shrinkWrap: true,
                                                                              itemCount: snapshotProdutos.data.documents.length,
                                                                              itemBuilder: (_, index) {
                                                                                ProductData dataProduto = ProductData.fromDocument(snapshotProdutos.data.documents[index]);
                                                                                bool nomeCategoriaBool = false;

                                                                                return ProdutosTileAntesReposicao(data, dataProduto);
                                                                              }),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          15.0),
                                                                  _currentPage !=
                                                                          _numPages -
                                                                              1
                                                                      ? Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                FractionalOffset.bottomRight,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                FlatButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      title = "Área de Venda";
                                                                                    });
                                                                                    _pageController.previousPage(
                                                                                      duration: Duration(milliseconds: 500),
                                                                                      curve: Curves.ease,
                                                                                    );
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        'Voltar',
                                                                                        style: TextStyle(
                                                                                          fontFamily: "Helvetica",
                                                                                          color: Color(0xFF707070),
                                                                                          fontSize: 22.0,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: 10.0),
                                                                                      Icon(
                                                                                        Icons.arrow_forward,
                                                                                        color: Colors.white,
                                                                                        size: 30.0,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                FlatButton(
                                                                                  onPressed: () async {
                                                                                    _pageController.nextPage(
                                                                                      duration: Duration(milliseconds: 500),
                                                                                      curve: Curves.ease,
                                                                                    );
                                                                                    setState(() {
                                                                                      title = "Instruções de Reposição";
                                                                                    });
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        'Avançar',
                                                                                        textAlign: TextAlign.right,
                                                                                        style: TextStyle(
                                                                                          fontFamily: "Helvetica",
                                                                                          color: Color(0xFF707070),
                                                                                          fontSize: 22.0,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          ''),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection(
                                                                "Empresas")
                                                            .document(data
                                                                .empresaResponsavel)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapInstrucao) {
                                                          if (!snapInstrucao
                                                              .hasData) {
                                                            return CircularProgressIndicator();
                                                          } else {
                                                            _instrucaoController
                                                                    .text =
                                                                snapInstrucao
                                                                        .data[
                                                                    "instrução"];
                                                            return Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 50,
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            50),
                                                                child: Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0),
                                                                  ),
                                                                  elevation: 15,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        SizedBox(
                                                                            height:
                                                                                30.0),
                                                                        SizedBox(
                                                                            height:
                                                                                15.0),
                                                                        Card(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                          ),
                                                                          elevation:
                                                                              10,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Container(
                                                                              height: 250,
                                                                              child: TextField(
                                                                                focusNode: myFocusInstrucao,
                                                                                enabled: true,
                                                                                maxLines: 10,
                                                                                controller: _instrucaoController,
                                                                                keyboardType: TextInputType.text,
                                                                                style: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 13.0, color: Colors.black),
                                                                                decoration: InputDecoration(
                                                                                  enabledBorder: UnderlineInputBorder(
                                                                                    borderSide: BorderSide(color: Colors.white),
                                                                                  ),
                                                                                  focusedBorder: UnderlineInputBorder(
                                                                                    borderSide: BorderSide(color: Colors.white),
                                                                                  ),
                                                                                  border: UnderlineInputBorder(
                                                                                    borderSide: BorderSide(color: Colors.white),
                                                                                  ),
                                                                                  hintStyle: TextStyle(fontFamily: "Georgia", fontSize: 10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        _currentPage !=
                                                                                _numPages - 1
                                                                            ? Expanded(
                                                                                child: Align(
                                                                                  alignment: FractionalOffset.bottomRight,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      FlatButton(
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            title = "Estoque Depósito";
                                                                                          });
                                                                                          _pageController.previousPage(
                                                                                            duration: Duration(milliseconds: 500),
                                                                                            curve: Curves.ease,
                                                                                          );
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Voltar',
                                                                                              style: TextStyle(
                                                                                                fontFamily: "Helvetica",
                                                                                                color: Color(0xFF707070),
                                                                                                fontSize: 22.0,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(width: 10.0),
                                                                                            Icon(
                                                                                              Icons.arrow_forward,
                                                                                              color: Colors.white,
                                                                                              size: 30.0,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      FlatButton(
                                                                                        onPressed: () async {
                                                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PesquisaAposReposicao(data)));
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Avançar',
                                                                                              textAlign: TextAlign.right,
                                                                                              style: TextStyle(
                                                                                                fontFamily: "Helvetica",
                                                                                                color: Color(0xFF707070),
                                                                                                fontSize: 22.0,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Text(''),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                left: 10,
                                                                right: 10,
                                                                bottom: 100),
                                                        child: Card(
                                                          elevation: 15,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
//
                                                                SizedBox(
                                                                    height:
                                                                        60.0),
                                                                Text(
                                                                  'Pesquisa Criada',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      kTitleStyle,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              30,
                                                                          right:
                                                                              30,
                                                                          top:
                                                                              20),
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    height: 100,
                                                                    child: Center(
                                                                        child: FlareActor(
                                                                            "assets/success_check.flr",
                                                                            alignment:
                                                                                Alignment.center,
                                                                            fit: BoxFit.contain,
                                                                            animation: "Untitled")),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        15.0),
                                                                _currentPage !=
                                                                        _numPages -
                                                                            2
                                                                    ? Expanded(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              FractionalOffset.bottomRight,
                                                                          child:
                                                                              FlatButton(
                                                                            onPressed:
                                                                                () {
                                                                              _pageController.nextPage(
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.ease,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Text(''),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: _buildPageIndicator(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetalhamentoPesquisa(
                                                            data)));
                                          },
                                          color: Color(0xFFF26868),
                                          textColor: Colors.white,
                                          child: Text("Cancelar Pesquisa",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      "QuickSandRegular")),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  )),
//      bottomSheet: _currentPage == _numPages - 5
//          ? Container(
//              height: 100.0,
//              width: double.infinity,
//              color: Colors.white,
//              child: GestureDetector(
//                onTap: () => _pageController.nextPage(
//                  duration: Duration(milliseconds: 500),
//                  curve: Curves.ease,
//                ),
//                child: Center(
//                  child: Padding(
//                    padding: EdgeInsets.only(bottom: 30.0),
//                    child: Text(
//                      'Criar nova Pesquisa',
//                      style: TextStyle(
//                        color: Color(0xFF5B16D0),
//                        fontSize: 20.0,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            )
//          : Container(
//              height: 10.0,
//              width: double.infinity,
//              color: Colors.deepPurple,
//              child: GestureDetector(
//                onTap: () => _pageController.nextPage(
//                  duration: Duration(milliseconds: 500),
//                  curve: Curves.ease,
//                ),
//                child: Center(
//                  child: Padding(
//                    padding: EdgeInsets.only(bottom: 30.0),
//                    child: Text(
//                      'Criar nova Pesquisa',
//                      style: TextStyle(
//                        color: Color(0xFF5B16D0),
//                        fontSize: 20.0,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ),
            );
          },
        ));
  }

  // Create week date picker with passed parameters
  Widget buildWeekDatePicker(DateTime selectedDate, DateTime firstAllowedDate,
      DateTime lastAllowedDate, ValueChanged<DatePeriod> onNewSelected) {
    // add some colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0))),
      selectedPeriodStartDecoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration:
          BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle),
    );

    return WeekPicker(
        selectedDate: selectedDate,
        onChanged: onNewSelected,
        firstDate: firstAllowedDate,
        lastDate: lastAllowedDate,
        datePickerStyles: styles);
  }
}

class AfterDialogPesquisa extends StatefulWidget {
  String nomeCategoria;
  PesquisaData data;

  AfterDialogPesquisa(this.nomeCategoria, this.data);
  @override
  _AfterDialogPesquisaState createState() =>
      _AfterDialogPesquisaState(this.nomeCategoria, this.data);
}

class _AfterDialogPesquisaState extends State<AfterDialogPesquisa> {
  String textoBtnPontoExtra = "Não";
  String textoBtnValidadeProxima = "Não";
  String textoBtnRuptura = "Não";
  File _image;
  PesquisaData data;

  String imagemAntes = "sem imagem";
  String nomeCategoria;

  _AfterDialogPesquisaState(this.nomeCategoria, this.data);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Foto da Aréa de venda\n(antes da reposição)"),
      content: SingleChildScrollView(
        child: new Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    getImage(false);
                  },
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
                                      height: 100,
                                      width: 300,
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
                                      : Image.network(
                                          imagemAntes,
                                          height: 100,
                                          width: 300,
                                        )),
                        ],
                      ),
                    ),
                  ),
                ),

                //Temos Ponto Extra ?
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Temos ponto extra ?",
                      textAlign: TextAlign.left,
                    )),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            textoBtnPontoExtra == "Não"
                                ? textoBtnPontoExtra = "Não"
                                : textoBtnPontoExtra = "Não";
                          });
                        },
                        child: Card(
                          color: textoBtnPontoExtra == "Não"
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
                                    color: textoBtnPontoExtra == "Não"
                                        ? Color(0xFFFFFFFF)
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
                        },
                        child: Card(
                          color: textoBtnPontoExtra == "Sim"
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

                //Produtos com validade Proxima
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Existe algum produto com validade próxima?",
                      textAlign: TextAlign.left,
                    )),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            textoBtnValidadeProxima == "Não"
                                ? textoBtnValidadeProxima = "Não"
                                : textoBtnValidadeProxima = "Não";
                          });
                        },
                        child: Card(
                          color: textoBtnValidadeProxima == "Não"
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
                                    color: textoBtnValidadeProxima == "Não"
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xFF707070)),
                              ),
                            )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            textoBtnValidadeProxima == "Não"
                                ? textoBtnValidadeProxima = "Sim"
                                : textoBtnValidadeProxima = "Sim";
                          });
                        },
                        child: Card(
                          color: textoBtnValidadeProxima == "Sim"
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
                                "Sim",
                                style: TextStyle(
                                  color: textoBtnValidadeProxima == "Sim"
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
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Informe quais e suas respectivas datas",
                                textAlign: TextAlign.left,
                              )),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProductTileValidadeScreen(
                                          data, nomeCategoria)));
                            },
                            child: Card(
                              color: textoBtnValidadeProxima == "Sim"
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 50,
                                width: 200,
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    "Adicionar",
                                    style: TextStyle(
                                        color: textoBtnValidadeProxima == "Não"
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
                    Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, bottom: 1, top: 8),
                        child: Text(
                          "Existe algum produto com poucas unidades na área de venda?",
                          textAlign: TextAlign.left,
                        )),
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
                              setState(() {
                                textoBtnRuptura == "Não"
                                    ? textoBtnRuptura = "Não"
                                    : textoBtnRuptura = "Não";
                              });
                            },
                            child: Card(
                              color: textoBtnRuptura == "Não"
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
                                        color: textoBtnRuptura == "Não"
                                            ? Color(0xFFFFFFFF)
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
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Informe os produtos com ruptura",
                                textAlign: TextAlign.left,
                              )),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProductTileRupturaScreen(
                                          data, nomeCategoria)));
                            },
                            child: Card(
                              color: textoBtnValidadeProxima == "Sim"
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
          ],
        ),
      ),
      actions: <Widget>[
        // define os botões na base do dialogo
        new FlatButton(
          child: new Text("Salvar"),
          onPressed: () {
            DocumentReference reference = Firestore.instance
                .collection("Empresas")
                .document(data.empresaResponsavel)
                .collection("pesquisasCriadas")
                .document(data.id)
                .collection("linhasProdutosAntesReposicao")
                .document(nomeCategoria);

            reference.setData({"concluida": true, "nomeLinha": nomeCategoria});

            Navigator.of(context).pop();

//            DocumentReference documentReference = Firestore.instance
//                .collection("Empresas")
//                .document(data.empresaResponsavel)
//                .collection("pesquisasCriadas")
//                .document(data.id)
//                .collection("linhasProdutos")
//                .document(nomeCategoria);
//
//            documentReference.setData({"concluida": true}, merge: true);
          },
        ),
      ],
    );
  }

  Future getImage(bool gallery) async {
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

      setState(() {
        print(docUrl);
        imagemAntes = docUrl;

        DocumentReference documentReference = Firestore.instance
            .collection("Empresas")
            .document(data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(data.id)
            .collection("BeforeAreaDeVenda")
            .document("fotoAntesReposicao");
        documentReference.setData({"imagem": docUrl});
      });
    }

    uploadPic(context);

    uploadPic(context);
  }
}
