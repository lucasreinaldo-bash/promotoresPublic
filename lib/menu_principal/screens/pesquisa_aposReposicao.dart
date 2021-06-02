import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_apos_reposicao.dart';
import 'package:versaoPromotores/models/user_model.dart';
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
import 'package:versaoPromotores/menu_principal/tiles/loja_tile.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_antes_reposicao.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_validade.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/splash_screen_pesquisaRespondida.dart';
import 'package:versaoPromotores/style/style.dart';
import 'package:versaoPromotores/widget/afterBottomSheetView.dart';

import '../responder_pesquisa/responder_pesquisa.dart';

class PesquisaAposReposicao extends StatefulWidget {
  PesquisaData data;

  PesquisaAposReposicao(this.data);
  @override
  _PesquisaAposReposicaoState createState() =>
      _PesquisaAposReposicaoState(this.data);
}

class _PesquisaAposReposicaoState extends State<PesquisaAposReposicao> {
  final int _numPages = 5;

  PesquisaData data;
  final PageController _pageController = PageController(initialPage: 3);
  int _currentPage = 3;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  _PesquisaAposReposicaoState(this.data);

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 12.0,
      width: isActive ? 44.0 : 32.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white70 : Color(0xFF7C6DEA),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  String title = "Observações";
  final _observacaoController = TextEditingController();
  final FocusNode myFocusObservacao = FocusNode();
  @override
  Widget build(BuildContext context) {
    var lista = new List<int>(data.linhaProduto.length);

    bool pesquisaCompleta() {
      var resultFirstWhere = lista.every((el) => el == 0);

      return resultFirstWhere;
    }

    return MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('pt'), const Locale('BR')],
        home: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return Scaffold(
              backgroundColor: Color(0xFFEBEDF5),
              appBar: AppBar(
                title: Column(
                  children: [
                    Text("Área de Venda",
                        style: TextStyle(fontFamily: "QuickSand")),
                  ],
                ),
                centerTitle: true,
                backgroundColor: Colors.deepPurple,
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("Empresas")
                            .document(model.firebaseUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.75,
                                      child: PageView(
                                        allowImplicitScrolling: false,
                                        physics: NeverScrollableScrollPhysics(),
                                        controller: _pageController,
                                        onPageChanged: (int page) {
                                          _currentPage = page;
                                        },
                                        children: <Widget>[
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 5,
                                                          right: 5,
                                                          bottom: 15),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    elevation: 1,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Faça a pesquisa para cada linha de produto abaixo após finalizar a reposição dos produtos.",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "QuickSand",
                                                                color: Color(
                                                                    0xFF000000)),
                                                          ),
                                                          Container(
                                                            height: 200,
                                                            child: ListView
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
                                                                          data.linhaProduto[
                                                                              index];

                                                                      bool
                                                                          nomeCategoriaBool =
                                                                          false;

                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showBarModalBottomSheet(
                                                                              expand: false,
                                                                              isDismissible: false,
                                                                              context: context,
                                                                              builder: (context) => Container(height: MediaQuery.of(context).size.height * 8, child: AfterBottomSheetView(nomeCategoria, data)));
                                                                        },
                                                                        child: Card(
                                                                            elevation: 2,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                            ),
                                                                            child: StreamBuilder(
                                                                              stream: Firestore.instance.collection("Empresas").document(data.empresaResponsavel).collection("pesquisasCriadas").document(data.id).collection("linhasProdutosAposReposicao").document(nomeCategoria).snapshots(),
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
                                                          ),
                                                          SizedBox(
                                                              height: 15.0),
                                                          _currentPage !=
                                                                  _numPages - 1
                                                              ? Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomRight,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FlatButton(
                                                                            child:
                                                                                Row(
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
                                                                            onPressed:
                                                                                () async {
                                                                              bool resultado = await pesquisaCompleta();

                                                                              if (resultado == true) {
                                                                                print(true);
                                                                                setState(() {
                                                                                  title = "Estoque depósito";
                                                                                  _pageController.nextPage(
                                                                                    duration: Duration(milliseconds: 500),
                                                                                    curve: Curves.ease,
                                                                                  );
                                                                                });
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
                                                                            }),
                                                                        FlatButton(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  'Avançar',
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
                                                                            onPressed:
                                                                                () async {
                                                                              bool resultado = await pesquisaCompleta();

                                                                              if (resultado == true) {
                                                                                print(true);
                                                                                setState(() {
                                                                                  title = "Estoque depósito";
                                                                                  _pageController.nextPage(
                                                                                    duration: Duration(milliseconds: 500),
                                                                                    curve: Curves.ease,
                                                                                  );
                                                                                });
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
                                                                            }),
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
                                              ),
                                            ],
                                          ),
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 5,
                                                          right: 5,
                                                          bottom: 15),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    elevation: 1,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Faça a pesquisa para cada linha de produto abaixo após finalizar a reposição dos produtos.",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "QuickSand",
                                                                color: Color(
                                                                    0xFF000000)),
                                                          ),
                                                          Container(
                                                            height: 200,
                                                            child: ListView
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
                                                                          data.linhaProduto[
                                                                              index];

                                                                      bool
                                                                          nomeCategoriaBool =
                                                                          false;

                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showBarModalBottomSheet(
                                                                              expand: false,
                                                                              isDismissible: false,
                                                                              context: context,
                                                                              builder: (context) => Container(height: MediaQuery.of(context).size.height * 8, child: AfterBottomSheetView(nomeCategoria, data)));
                                                                        },
                                                                        child: Card(
                                                                            elevation: 2,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                            ),
                                                                            child: StreamBuilder(
                                                                              stream: Firestore.instance.collection("Empresas").document(data.empresaResponsavel).collection("pesquisasCriadas").document(data.id).collection("linhasProdutosAposReposicao").document(nomeCategoria).snapshots(),
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
                                                          ),
                                                          SizedBox(
                                                              height: 15.0),
                                                          _currentPage !=
                                                                  _numPages - 1
                                                              ? Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomRight,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FlatButton(
                                                                            child:
                                                                                Row(
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
                                                                            onPressed:
                                                                                () async {
                                                                              bool resultado = await pesquisaCompleta();

                                                                              if (resultado == true) {
                                                                                print(true);
                                                                                setState(() {
                                                                                  title = "Estoque depósito";
                                                                                  _pageController.nextPage(
                                                                                    duration: Duration(milliseconds: 500),
                                                                                    curve: Curves.ease,
                                                                                  );
                                                                                });
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
                                                                            }),
                                                                        FlatButton(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  'Avançar',
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
                                                                            onPressed:
                                                                                () async {
                                                                              bool resultado = await pesquisaCompleta();

                                                                              if (resultado == true) {
                                                                                print(true);
                                                                                setState(() {
                                                                                  title = "Estoque depósito";
                                                                                  _pageController.nextPage(
                                                                                    duration: Duration(milliseconds: 500),
                                                                                    curve: Curves.ease,
                                                                                  );
                                                                                });
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
                                                                            }),
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
                                              ),
                                            ],
                                          ),
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 5,
                                                          right: 5,
                                                          bottom: 15),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    elevation: 1,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Faça a pesquisa para cada linha de produto abaixo após finalizar a reposição dos produtos.",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "QuickSand",
                                                                color: Color(
                                                                    0xFF000000)),
                                                          ),
                                                          Container(
                                                            height: 200,
                                                            child: ListView
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
                                                                          data.linhaProduto[
                                                                              index];

                                                                      bool
                                                                          nomeCategoriaBool =
                                                                          false;

                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showBarModalBottomSheet(
                                                                              expand: false,
                                                                              isDismissible: false,
                                                                              context: context,
                                                                              builder: (context) => Container(height: MediaQuery.of(context).size.height * 8, child: AfterBottomSheetView(nomeCategoria, data)));
                                                                        },
                                                                        child: Card(
                                                                            elevation: 2,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                            ),
                                                                            child: StreamBuilder(
                                                                              stream: Firestore.instance.collection("Empresas").document(data.empresaResponsavel).collection("pesquisasCriadas").document(data.id).collection("linhasProdutosAposReposicao").document(nomeCategoria).snapshots(),
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
                                                          ),
                                                          SizedBox(
                                                              height: 15.0),
                                                          _currentPage !=
                                                                  _numPages - 1
                                                              ? Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomRight,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FlatButton(
                                                                            child:
                                                                                Row(
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
                                                                            onPressed:
                                                                                () async {
                                                                              bool resultado = await pesquisaCompleta();

                                                                              if (resultado == true) {
                                                                                print(true);
                                                                                setState(() {
                                                                                  title = "Estoque depósito";
                                                                                  _pageController.nextPage(
                                                                                    duration: Duration(milliseconds: 500),
                                                                                    curve: Curves.ease,
                                                                                  );
                                                                                });
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
                                                                            }),
                                                                        FlatButton(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  'Avançar',
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
                                                                            onPressed:
                                                                                () async {
                                                                              bool resultado = await pesquisaCompleta();

                                                                              if (resultado == true) {
                                                                                print(true);
                                                                                setState(() {
                                                                                  title = "Estoque depósito";
                                                                                  _pageController.nextPage(
                                                                                    duration: Duration(milliseconds: 500),
                                                                                    curve: Curves.ease,
                                                                                  );
                                                                                });
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
                                                                            }),
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
                                              ),
                                            ],
                                          ),
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 5,
                                                          right: 5,
                                                          bottom: 15),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    elevation: 1,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Informe a quantidade dos produtos que ficaram no depósito da loja após a reposição. (em unid.)",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "QuickSand",
                                                                color: Color(
                                                                    0xFF000000)),
                                                          ),
                                                          Container(
                                                            height: 4,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                          ),
                                                          Container(
                                                            color:
                                                                Colors.black12,
                                                            height: 2,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                          ),
                                                          FutureBuilder(
                                                            future: Firestore
                                                                .instance
                                                                .collection(
                                                                    "Empresas")
                                                                .document(data
                                                                    .empresaResponsavel)
                                                                .collection(
                                                                    "Lojas")
                                                                .document(data
                                                                    .nomeLoja)
                                                                .collection(
                                                                    "Produtos")
                                                                .getDocuments(),
                                                            builder: (context,
                                                                snapshotProdutos) {
                                                              if (!snapshotProdutos
                                                                  .hasData) {
                                                                return LinearProgressIndicator();
                                                              } else {
                                                                return Container(
                                                                  height: 300,
                                                                  child: ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: snapshotProdutos
                                                                              .data
                                                                              .documents
                                                                              .length,
                                                                          itemBuilder:
                                                                              (_, index) {
                                                                            ProductData
                                                                                dataProduto =
                                                                                ProductData.fromDocument(snapshotProdutos.data.documents[index]);
                                                                            bool
                                                                                nomeCategoriaBool =
                                                                                false;

                                                                            return ProdutosTileAposReposicao(data,
                                                                                dataProduto);
                                                                          }),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(
                                                              height: 15.0),
                                                          _currentPage !=
                                                                  _numPages - 1
                                                              ? Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomRight,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FlatButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              title = "Área de Venda";
                                                                            });
                                                                            _pageController.previousPage(
                                                                              duration: Duration(milliseconds: 500),
                                                                              curve: Curves.ease,
                                                                            );
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
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
                                                                          onPressed:
                                                                              () async {
                                                                            DocumentReference
                                                                                documentReference3 =
                                                                                await Firestore.instance.collection("Empresas").document(data.empresaResponsavel).collection("pesquisasCriadas").document(data.id);

                                                                            documentReference3.updateData({
                                                                              "comentarioPromotor": _observacaoController.text.length != 0 ? _observacaoController.text : "Nenhuma",
                                                                              "status": "A APROVAR",
                                                                              "tag": FieldValue.arrayRemove([
                                                                                "Nova Pesquisa"
                                                                              ]),
                                                                              "dataFinalizacao": da.formatDate(DateTime.now(), [
                                                                                    da.dd,
                                                                                    '/',
                                                                                    da.mm,
                                                                                    '/',
                                                                                    da.yyyy
                                                                                  ]) +
                                                                                  " às ${da.formatDate(DateTime.now(), [
                                                                                    da.HH,
                                                                                    ':',
                                                                                    da.nn,
                                                                                    ':',
                                                                                    da.ss
                                                                                  ])}",
                                                                              "data_query_finalizada": DateTime.now().microsecondsSinceEpoch,
                                                                            });
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SplashScreenPesquisaRespondida()));
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                bottom: 100),
                                            child: Card(
                                              elevation: 15,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
//
                                                    SizedBox(height: 60.0),
                                                    Text(
                                                      'Pesquisa Respondida',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: kTitleStyle,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 30,
                                                          right: 30,
                                                          top: 20),
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        child: Center(
                                                            child: FlareActor(
                                                                "assets/success_check.flr",
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                fit: BoxFit
                                                                    .contain,
                                                                animation:
                                                                    "Untitled")),
                                                      ),
                                                    ),
                                                    SizedBox(height: 15.0),
                                                    _currentPage !=
                                                            _numPages - 2
                                                        ? Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  FractionalOffset
                                                                      .bottomRight,
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  _pageController
                                                                      .nextPage(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    curve: Curves
                                                                        .ease,
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
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: _buildPageIndicator(),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 200,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              onPressed: () async {
                                                //Limpar Area de Venda

                                                DocumentReference
                                                    documentReference1 =
                                                    await Firestore.instance
                                                        .collection("Empresas")
                                                        .document(data
                                                            .empresaResponsavel)
                                                        .collection(
                                                            "pesquisasCriadas")
                                                        .document(data.id)
                                                        .collection(
                                                            "imagensLinhas")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                  for (DocumentSnapshot ds
                                                      in snapshot.documents) {
                                                    ds.reference.delete();
                                                  }
                                                });
                                                DocumentReference
                                                    documentReference3 =
                                                    await Firestore.instance
                                                        .collection("Empresas")
                                                        .document(data
                                                            .empresaResponsavel)
                                                        .collection(
                                                            "pesquisasCriadas")
                                                        .document(data.id);

                                                await Firestore.instance
                                                  ..collection("Empresas")
                                                      .document(data
                                                          .empresaResponsavel)
                                                      .collection(
                                                          "pesquisasCriadas")
                                                      .document(data.id)
                                                      .collection(
                                                          "antesReposicao")
                                                      .getDocuments()
                                                      .then((snapshot) {
                                                    for (DocumentSnapshot ds
                                                        in snapshot.documents) {
                                                      ds.reference.delete();
                                                    }
                                                    ;
                                                  });

                                                await Firestore.instance
                                                  ..collection("Empresas")
                                                      .document(model
                                                          .firebaseUser.uid)
                                                      .collection("Lojas")
                                                      .document(data.nomeLoja)
                                                      .collection("Produtos")
                                                      .getDocuments()
                                                      .then((snapshot) {
                                                    for (DocumentSnapshot ds
                                                        in snapshot.documents) {
                                                      Firestore.instance
                                                          .collection(
                                                              "Empresas")
                                                          .document(model
                                                              .firebaseUser.uid)
                                                          .collection(
                                                              "pesquisasCriadas")
                                                          .document(data.id)
                                                          .collection(
                                                              "estoqueDeposito")
                                                          .document(ds.data[
                                                              "nomeProduto"])
                                                          .setData({
                                                        "produto": ds.data[
                                                            "nomeProduto"],
                                                        "linha": ds
                                                            .data["nomeLinha"],
                                                        "antesReposicao": 9999,
                                                        "aposReposicao": 9999,
                                                        "qtdMinAreaEstoque": ds
                                                                .data[
                                                            "qtdMinAreaEstoque"],
                                                        "qtdMinAreaVenda": ds
                                                                .data[
                                                            "qtdMinAreaVenda"],
                                                      });
                                                    }
                                                  });

                                                await Firestore.instance
                                                  ..collection("Empresas")
                                                      .document(data
                                                          .empresaResponsavel)
                                                      .collection(
                                                          "pesquisasCriadas")
                                                      .document(data.id)
                                                      .collection("pontoExtra")
                                                      .getDocuments()
                                                      .then((snapshot) {
                                                    for (DocumentSnapshot ds
                                                        in snapshot.documents) {
                                                      ds.reference.updateData({
                                                        "existe": false,
                                                        "imagemAntes":
                                                            "nenhuma",
                                                        "imagemDepois":
                                                            "nenhuma"
                                                      });
                                                    }
                                                    ;
                                                  });

                                                await Firestore.instance
                                                    .collection("Empresas")
                                                    .document(
                                                        data.empresaResponsavel)
                                                    .collection(
                                                        "pesquisasCriadas")
                                                    .document(data.id)
                                                    .collection(
                                                        "linhasProdutos")
                                                    .getDocuments()
                                                    .then((snapshot) {
                                                  for (DocumentSnapshot ds
                                                      in snapshot.documents) {
                                                    ds.reference.updateData(
                                                        {"concluida": false});
                                                  }
                                                  ;
                                                });

                                                await Firestore.instance
                                                  ..collection("Empresas")
                                                      .document(data
                                                          .empresaResponsavel)
                                                      .collection(
                                                          "pesquisasCriadas")
                                                      .document(data.id)
                                                      .collection(
                                                          "linhasProdutosAntesReposicao")
                                                      .getDocuments()
                                                      .then((snapshot) {
                                                    for (DocumentSnapshot ds
                                                        in snapshot.documents) {
                                                      ds.reference.updateData(
                                                          {"concluida": false});
                                                    }
                                                    ;
                                                  });

                                                await Firestore.instance
                                                  ..collection("Empresas")
                                                      .document(data
                                                          .empresaResponsavel)
                                                      .collection(
                                                          "pesquisasCriadas")
                                                      .document(data.id)
                                                      .collection(
                                                          "linhasProdutosAposReposicao")
                                                      .getDocuments()
                                                      .then((snapshot) {
                                                    for (DocumentSnapshot ds
                                                        in snapshot.documents) {
                                                      ds.reference.updateData(
                                                          {"concluida": false});
                                                    }
                                                    ;
                                                  });

                                                documentReference1.delete();

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
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
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
}

class DialogAposReposicao extends StatefulWidget {
  PesquisaData data;
  String nomeCategoria;

  DialogAposReposicao(this.nomeCategoria, this.data);
  @override
  _DialogAposReposicaoState createState() =>
      _DialogAposReposicaoState(this.nomeCategoria, this.data);
}

class _DialogAposReposicaoState extends State<DialogAposReposicao> {
  String textoBtnPontoExtra = "Não";
  String textoBtnValidadeProxima = "Não";
  String textoBtnRuptura = "Não";
  File _image;
  PesquisaData data;

  String imagemAntes = "sem imagem";
  String imagemPontoExtra = "sem imagem";
  String nomeCategoria;

  _DialogAposReposicaoState(this.nomeCategoria, this.data);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
//      title: new Text("Foto da Aréa de venda\n(após a reposição)"),
      content: SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    getImage(false, data);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                          : InkWell(
                              onTap: () {
                                getImagePontoExtra(false, data);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Foto do ponto extra:"),
                                          Text(
                                            "(Após a reposição)",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(8),
                                              child: imagemPontoExtra ==
                                                      "sem imagem"
                                                  ? Container(
                                                      height: 100,
                                                      width: 300,
                                                      child: Image.asset(
                                                        "assets/cam.png",
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                    )
                                                  : imagemPontoExtra ==
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
                                                      : Image.network(
                                                          imagemPontoExtra,
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
                  );
                }
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        // define os botões na base do dialogo
        new FlatButton(
            child: new Text("Salvar"),
            onPressed:
                //  imagemAntes != "sem imagem" &&
                //         imagemPontoExtra != "sem imagem"
                //     ?
                () {
              void _settingModalBottomSheet(context) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
//
                            SizedBox(height: 20.0),
                            Text(
                              'É necessário um novo pedido ?',
                              textAlign: TextAlign.center,
                              style: kTitleStyle,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 30, right: 30, top: 30),
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Center(
                                    child: Column(
                                  children: [
                                    Container(
                                      width: 200,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onPressed: () async {
                                          var tagAtualizada =
                                              new List<String>.from(data.tag);

                                          if (tagAtualizada
                                              .contains("NOVO PEDIDO")) {
                                            tagAtualizada.remove("NOVO PEDIDO");
                                          }

                                          if (tagAtualizada
                                              .contains("NOVA PESQUISA")) {
                                            tagAtualizada
                                                .remove("NOVA PESQUISA");
                                          }

                                          DocumentReference documentReference =
                                              Firestore.instance
                                                  .collection("Empresas")
                                                  .document(
                                                      data.empresaResponsavel)
                                                  .collection(
                                                      "pesquisasCriadas")
                                                  .document(data.id);

                                          await documentReference.updateData({
                                            "novoPedido": "Não",
                                            "tag": tagAtualizada,
                                          });

                                          Navigator.of(bc).pop();
                                        },
                                        color: Color(0xFFF26868),
                                        textColor: Colors.white,
                                        child: Text("Não",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    "QuickSandRegular")),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onPressed: () async {
                                          var tagAtualizada =
                                              new List<String>.from(data.tag);

                                          tagAtualizada.add("NOVO PEDIDO");

                                          if (tagAtualizada
                                              .contains("NOVA PESQUISA")) {
                                            tagAtualizada
                                                .remove("NOVA PESQUISA");
                                          }

                                          DocumentReference documentReference =
                                              Firestore.instance
                                                  .collection("Empresas")
                                                  .document(
                                                      data.empresaResponsavel)
                                                  .collection(
                                                      "pesquisasCriadas")
                                                  .document(data.id);

                                          await documentReference.updateData({
                                            "novoPedido": "Sim",
                                            "tag": tagAtualizada,
                                          });

                                          DocumentReference
                                              documentReferenceAntesReposicao =
                                              Firestore.instance
                                                  .collection("Empresas")
                                                  .document(
                                                      data.empresaResponsavel)
                                                  .collection(
                                                      "pesquisasCriadas")
                                                  .document(data.id)
                                                  .collection(
                                                      "linhasProdutosAntesReposicao")
                                                  .document(nomeCategoria);

                                          documentReferenceAntesReposicao
                                              .updateData(
                                            {
                                              "tags": FieldValue.arrayUnion(
                                                  ["Novo Pedido"])
                                            },
                                          );
                                          Navigator.of(bc).pop();
                                        },
                                        color: Color(0xFF4FCEB6),
                                        textColor: Colors.white,
                                        child: Text("Sim",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    "QuickSandRegular")),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                            SizedBox(height: 15.0),
                          ],
                        ),
                      );
                    });
              }

              DocumentReference reference = Firestore.instance
                  .collection("Empresas")
                  .document(data.empresaResponsavel)
                  .collection("pesquisasCriadas")
                  .document(data.id)
                  .collection("linhasProdutosAposReposicao")
                  .document(nomeCategoria);

              reference
                  .setData({"concluida": true, "nomeLinha": nomeCategoria});
              Navigator.of(context).pop();

              _settingModalBottomSheet(context);

//            DocumentReference documentReference = Firestore.instance
//                .collection("Empresas")
//                .document(data.empresaResponsavel)
//                .collection("pesquisasCriadas")
//                .document(data.id)
//                .collection("linhasProdutos")
//                .document(nomeCategoria);
//
//            documentReference.setData({"concluida": true}, merge: true);
            }
            // : null,
            ),
      ],
    );
  }

  Future getImage(bool gallery, PesquisaData data) async {
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
      print(docUrl);

      setState(() {
        imagemAntes = docUrl;
      });

      DocumentReference documentReference = await Firestore.instance
          .collection("Empresas")
          .document(data.empresaResponsavel)
          .collection("pesquisasCriadas")
          .document(data.id)
          .collection("imagensLinhas")
          .document(nomeCategoria)
          .collection("AfterAreaDeVenda")
          .document("fotoDepoisReposicao");
      documentReference.setData({"imagem": docUrl});
    }

    uploadPic(context);
  }

  Future getImagePontoExtra(bool gallery, PesquisaData data) async {
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
