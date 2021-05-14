import 'dart:io';
import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/detalhamentoPesquisa.dart';
import 'package:versaoPromotores/menu_principal/product_tile_ruptura_screen.dart';
import 'package:versaoPromotores/menu_principal/product_tile_validade_screen.dart';
import 'package:versaoPromotores/menu_principal/responder_pesquisa/responder_presquisa_widget.dart';
import 'package:versaoPromotores/menu_principal/screens/pesquisa_aposReposicao.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_antes_reposicao.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/style/style.dart';
import 'package:versaoPromotores/style/theme.dart' as Theme;
import 'package:versaoPromotores/widget/bottomSheetView.dart';

import '../datas/pesquisaData.dart';

class ResponderPesquisaData extends StatefulWidget {
  PesquisaData data;

  ResponderPesquisaData(this.data);

  @override
  _ResponderPesquisaDataState createState() =>
      _ResponderPesquisaDataState(this.data);
}

class _ResponderPesquisaDataState extends State<ResponderPesquisaData> {
  //Instanciar a classe modelo para recuperar as informações da pesquisa
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

  final int _numPages =
      5; //Numero total de telas para responder a pesquisa antes da reposição

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }
  //Pesquisa

  String dataInicioPesquisa, dataFinalPesquisa, nomeRede;

  List<String> avancarAntesReposicao;

  String title = "Área de Venda";
  String concluido = "não";

  _ResponderPesquisaDataState(this.data);
  //Metodo para setar os buttons
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
                backgroundColor: Color(0xFFEBEDF5),
                appBar: AppBar(
                  title: Text(title, style: TextStyle(fontFamily: "QuickSand")),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.75,
                                        child: PageView(
                                          allowImplicitScrolling: false,
                                          physics:
                                              NeverScrollableScrollPhysics(),
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
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      elevation: 1,
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
                                                                            data.linhaProduto[index];
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
                                                                                builder: (context) => Container(height: MediaQuery.of(context).size.height * 8, child: BottomSheetView(nomeCategoria, data)));
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
                                                                              setState(() {
                                                                                title = "Observações";
                                                                              });
                                                                              _pageController.previousPage(
                                                                                duration: Duration(milliseconds: 2000),
                                                                                curve: Curves.fastOutSlowIn,
                                                                              );
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
                                                              "Informe as quantidades dos produtos que estão no depósito da loja antes da reposição. (em unid.)",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "QuickSand",
                                                                  fontSize: 8,
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
                                                              color: Colors
                                                                  .black12,
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
                                                                    height: 200,
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

                                                                          return ProdutosTileAntesReposicao(
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
                                                                              setState(() {
                                                                                title = "Instruções de Reposição";
                                                                              });
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
                                              ],
                                            ),
                                            StreamBuilder(
                                              stream: Firestore.instance
                                                  .collection("Empresas")
                                                  .document(
                                                      data.empresaResponsavel)
                                                  .snapshots(),
                                              builder:
                                                  (context, snapInstrucao) {
                                                if (!snapInstrucao.hasData) {
                                                  return CircularProgressIndicator();
                                                } else {
                                                  _instrucaoController.text =
                                                      snapInstrucao
                                                          .data["instrução"];
                                                  return Flex(
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 50,
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 50),
                                                          child: Container(
                                                            height: 600,
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
                                                                      "Siga as instruções abaixo para realizar a reposição dos produtos",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "QuickSand",
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Color(0xFF000000)),
                                                                    ),
                                                                    Container(
                                                                      height: 4,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                    ),
                                                                    Container(
                                                                      color: Colors
                                                                          .black12,
                                                                      height: 2,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            15.0),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        decoration: new BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1.0, color: Colors.black12),
                                                                            borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              TextField(
                                                                            focusNode:
                                                                                myFocusInstrucao,
                                                                            enabled:
                                                                                false,
                                                                            maxLines:
                                                                                10,
                                                                            controller:
                                                                                _instrucaoController,
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            style: TextStyle(
                                                                                fontFamily: "WorkSansSemiBold",
                                                                                fontSize: 13.0,
                                                                                color: Colors.black),
                                                                            decoration:
                                                                                InputDecoration(
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
                                                                            _numPages -
                                                                                1
                                                                        ? Expanded(
                                                                            child:
                                                                                Align(
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
                                                                        : Text(
                                                                            ''),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }
                                              },
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
//
                                                      SizedBox(height: 60.0),
                                                      Text(
                                                        'Pesquisa Criada',
                                                        textAlign:
                                                            TextAlign.center,
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
                                                      SizedBox(height: 15.0),
                                                      _currentPage !=
                                                              _numPages - 2
                                                          ? Flex(
                                                              direction: Axis
                                                                  .horizontal,
                                                              children: [
                                                                Expanded(
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
                                                              ],
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
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onPressed: () async {
                                                  //Limpar Area de Venda

                                                  DocumentReference
                                                      documentReference1 =
                                                      await Firestore.instance
                                                          .collection(
                                                              "Empresas")
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
                                                          .collection(
                                                              "Empresas")
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
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference.delete();
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
                                                            "estoqueDeposito")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference.delete();
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
                                                            "pontoExtra")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference
                                                            .updateData({
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
                                                      .document(data
                                                          .empresaResponsavel)
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
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference
                                                            .updateData({
                                                          "concluida": false
                                                        });
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
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference
                                                            .updateData({
                                                          "concluida": false
                                                        });
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
                      ),
                    ],
                  ),
                ));
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
  String imagemAntesPontoExtra = "sem imagem";
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
                    getImage(false, nomeCategoria);
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
                          DocumentReference documentReference = Firestore
                              .instance
                              .collection("Empresas")
                              .document(data.empresaResponsavel)
                              .collection("pesquisasCriadas")
                              .document(data.id)
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
                          DocumentReference documentReference = Firestore
                              .instance
                              .collection("Empresas")
                              .document(data.empresaResponsavel)
                              .collection("pesquisasCriadas")
                              .document(data.id)
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
                textoBtnPontoExtra == "Sim"
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () {
                              getImagePontoExtra(false, nomeCategoria);
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
                                        child: imagemAntesPontoExtra ==
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
                                                : Image.network(
                                                    imagemAntesPontoExtra,
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
                                fontFamily: "QuickSandRegular", fontSize: 10),
                            textAlign: TextAlign.left,
                          )
                        ],
                      )
                    : Container(),

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
          onPressed: imagemAntes != "sem imagem" &&
                  (textoBtnPontoExtra == "Sim"
                      ? imagemAntesPontoExtra != "sem imagem"
                      : textoBtnPontoExtra == "Não")
              ? () async {
                  DocumentReference reference = await Firestore.instance
                      .collection("Empresas")
                      .document(data.empresaResponsavel)
                      .collection("pesquisasCriadas")
                      .document(data.id)
                      .collection("linhasProdutosAntesReposicao")
                      .document(nomeCategoria);

                  reference
                      .setData({"concluida": true, "nomeLinha": nomeCategoria});

                  Navigator.of(context).pop();
                }
              : null,
        ),
      ],
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

    uploadPic(context, categoria);
  }

  Future uploadPic(BuildContext context, String categoria) async {
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
    });

    DocumentReference documentReference = await Firestore.instance
        .collection("Empresas")
        .document(data.empresaResponsavel)
        .collection("pesquisasCriadas")
        .document(data.id)
        .collection("imagensLinhas")
        .document(categoria)
        .collection("BeforeAreaDeVenda")
        .document("fotoAntesReposicao");
    documentReference.setData({"imagem": docUrl});
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
        imagemAntesPontoExtra = "carregando";
      });
      String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      setState(() async {
        print(docUrl);
        imagemAntesPontoExtra = docUrl;

        DocumentReference documentReference = await Firestore.instance
            .collection("Empresas")
            .document(data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(data.id)
            .collection("pontoExtra")
            .document(nomeCategoria);

        documentReference.updateData(
          {
            "existe": true,
            "imagemAntes": docUrl,
          },
        );
      });
    }

    uploadPic(context);

    uploadPic(context);
  }
}
