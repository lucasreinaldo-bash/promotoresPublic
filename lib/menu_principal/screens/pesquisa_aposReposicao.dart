import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

import '../criar_pesquisa.dart';

class PesquisaAposReposicao extends StatelessWidget {
  final int _numPages = 3;

  PesquisaData data;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  PesquisaAposReposicao(this.data);

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('pt'), const Locale('BR')],
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text("Área de Venda", style: TextStyle(fontFamily: "QuickSand")),
              Text("(Após a Reposição)",
                  style: TextStyle(fontFamily: "QuickSand", fontSize: 13)),
            ],
          ),
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
                                  image:
                                      new AssetImage("assets/fundo_colors.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: null /* add child content content here */,
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
                                              physics: ClampingScrollPhysics(),
                                              controller: _pageController,
                                              onPageChanged: (int page) {
                                                _currentPage = page;
                                              },
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 50,
                                                            left: 20,
                                                            right: 20,
                                                            bottom: 50),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      elevation: 15,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              "Faça a pesquisa para cada linha de produto abaixo antes de iniciar a reposição.",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "QuickSand",
                                                                  color: Color(
                                                                      0xFF000000)),
                                                            ),
                                                            ListView.builder(
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
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          // retorna um objeto do tipo Dialog
                                                                          return DialogAposReposicao(
                                                                              nomeCategoria,
                                                                              data);
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Card(
                                                                        elevation:
                                                                            2,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                        ),
                                                                        child:
                                                                            StreamBuilder(
                                                                          stream: Firestore
                                                                              .instance
                                                                              .collection("Empresas")
                                                                              .document(data.empresaResponsavel)
                                                                              .collection("pesquisasCriadas")
                                                                              .document(data.id)
                                                                              .collection("linhasProdutosAposReposicao")
                                                                              .document(nomeCategoria)
                                                                              .snapshots(),
                                                                          builder:
                                                                              (context, snapshotLinhas) {
                                                                            if (!snapshotLinhas.hasData) {
                                                                              return Container();
                                                                            } else {
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
                                                                height: 15.0),
                                                            _currentPage !=
                                                                    _numPages -
                                                                        1
                                                                ? Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          FractionalOffset
                                                                              .bottomRight,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          FlatButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetalhamentoPesquisa(data)));
                                                                            },
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
                                                                          ),
                                                                          FlatButton(
                                                                            child:
                                                                                Row(
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
                                                                              _pageController.nextPage(
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.ease,
                                                                              );
                                                                            },
                                                                          )
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
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 50,
                                                            left: 20,
                                                            right: 20,
                                                            bottom: 50),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      elevation: 15,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
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
                                                              builder: (context,
                                                                  snapshotProdutos) {
                                                                if (!snapshotProdutos
                                                                    .hasData) {
                                                                  return LinearProgressIndicator();
                                                                } else {
                                                                  return Container(
                                                                    height: 300,
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: snapshotProdutos.data.documents.length,
                                                                        itemBuilder: (_, index) {
                                                                          ProductData
                                                                              dataProduto =
                                                                              ProductData.fromDocument(snapshotProdutos.data.documents[index]);
                                                                          bool
                                                                              nomeCategoriaBool =
                                                                              false;

                                                                          return ProdutosTileAposReposicao(
                                                                              data,
                                                                              dataProduto);
                                                                        }),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                                height: 15.0),
                                                            _currentPage !=
                                                                    _numPages -
                                                                        1
                                                                ? Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          FractionalOffset
                                                                              .bottomRight,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          FlatButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetalhamentoPesquisa(data)));
                                                                            },
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
                                                                          ),
                                                                          FlatButton(
                                                                            onPressed:
                                                                                () async {
                                                                              _pageController.nextPage(
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.ease,
                                                                              );
                                                                            },
                                                                            child:
                                                                                Row(
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
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 100),
                                                  child: Card(
                                                    elevation: 15,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
//
                                                          SizedBox(
                                                              height: 60.0),
                                                          Text(
                                                            'É necessário um novo pedido ?',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: kTitleStyle,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 30,
                                                                    right: 30,
                                                                    top: 20),
                                                            child: Container(
                                                              width: 100,
                                                              height: 100,
                                                              child: Center(
                                                                  child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: 200,
                                                                    child:
                                                                        RaisedButton(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        DocumentReference documentReference = Firestore
                                                                            .instance
                                                                            .collection("Empresas")
                                                                            .document(data.empresaResponsavel)
                                                                            .collection("pesquisasCriadas")
                                                                            .document(data.id);

                                                                        await documentReference
                                                                            .updateData({
                                                                          "novoPedido":
                                                                              "Não",
                                                                          "status":
                                                                              "A APROVAR"
                                                                        });
                                                                        _pageController.nextPage(
                                                                            duration:
                                                                                Duration(milliseconds: 500),
                                                                            curve: Curves.ease);
                                                                      },
                                                                      color: Color(
                                                                          0xFFF26868),
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      child: Text(
                                                                          "Não",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: "QuickSandRegular")),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 200,
                                                                    child:
                                                                        RaisedButton(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        DocumentReference documentReference = Firestore
                                                                            .instance
                                                                            .collection("Empresas")
                                                                            .document(data.empresaResponsavel)
                                                                            .collection("pesquisasCriadas")
                                                                            .document(data.id);

                                                                        await documentReference
                                                                            .updateData({
                                                                          "novoPedido":
                                                                              "Sim",
                                                                          "status":
                                                                              "A APROVAR"
                                                                        });

                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SplashScreenPesquisaRespondida()));
                                                                      },
                                                                      color: Color(
                                                                          0xFF4FCEB6),
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      child: Text(
                                                                          "Sim",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: "QuickSandRegular")),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 15.0),
                                                          _currentPage !=
                                                                  _numPages - 2
                                                              ? Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomRight,
                                                                    child:
                                                                        FlatButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SplashScreenPesquisaRespondida()));
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 100),
                                                  child: Card(
                                                    elevation: 15,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
//
                                                          SizedBox(
                                                              height: 60.0),
                                                          Text(
                                                            'Pesquisa Respondida',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: kTitleStyle,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
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
                                                          SizedBox(
                                                              height: 15.0),
                                                          _currentPage !=
                                                                  _numPages - 2
                                                              ? Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomRight,
                                                                    child:
                                                                        FlatButton(
                                                                      onPressed:
                                                                          () {
                                                                        _pageController
                                                                            .nextPage(
                                                                          duration:
                                                                              Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.ease,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetalhamentoPesquisa(data)));
                                    },
                                    color: Color(0xFFF26868),
                                    textColor: Colors.white,
                                    child: Text("Cancelar Pesquisa",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "QuickSandRegular")),
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
      ),
    );
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    getImagePontoExtra(false, data);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Foto do ponto extra:"),
                              Text(
                                "(Após a reposição)",
                                style: TextStyle(fontSize: 10),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: imagemPontoExtra == "sem imagem"
                                      ? Container(
                                          height: 100,
                                          width: 300,
                                          child: Image.asset(
                                            "assets/cam.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                        )
                                      : imagemPontoExtra == "carregando"
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
                .collection("linhasProdutosAposReposicao")
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
      setState(() {
        print(docUrl);
        imagemAntes = docUrl;

        DocumentReference documentReference = Firestore.instance
            .collection("Empresas")
            .document(data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(data.id)
            .collection("AfterAreaDeVenda")
            .document("fotoDepoisReposicao");
        documentReference.setData({"imagem": docUrl});
      });
    }

    uploadPic(context);
  }

  Future getImagePontoExtra(bool gallery, PesquisaData data) async {
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
          setState(() {
            print(docUrl);
            imagemPontoExtra = docUrl;

            DocumentReference documentReference = Firestore.instance
                .collection("Empresas")
                .document(data.empresaResponsavel)
                .collection("pesquisasCriadas")
                .document(data.id)
                .collection("pontoExtra")
                .document("ponto");
            documentReference.updateData({"imagem": docUrl});
          });
        }

        uploadPic(context);
        //_image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }
}
