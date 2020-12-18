import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart' as da;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/drawer/custom_drawer.dart';
import 'package:versaoPromotores/menu_principal/datas/LinhaProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/LojaData.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/detalhamentoPesquisa.dart';
import 'package:versaoPromotores/menu_principal/home_menu.dart';
import 'package:versaoPromotores/menu_principal/tiles/loja_tile.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/style/style.dart';

import 'datas/PromotorData.dart';
import 'datas/pesquisaData.dart';

class ResponderPesquisa extends StatefulWidget {
  PesquisaData data;

  ResponderPesquisa(this.data);
  @override
  _ResponderPesquisaState createState() => _ResponderPesquisaState(data);
}

class _ResponderPesquisaState extends State<ResponderPesquisa> {
  PesquisaData data;
  final _nomeLojaController = TextEditingController();
  final _dataController = TextEditingController();
  final _pesquisarLojaController = TextEditingController();
  final _nomePromotorController = TextEditingController();
  final _linhaProdutoController = TextEditingController();
  final _observacaoController = TextEditingController();
  final FocusNode myFocusPesquisa = FocusNode();
  final FocusNode myFocusData = FocusNode();
  final FocusNode myFocusNomeLoja = FocusNode();
  final FocusNode myFocusNomePromotor = FocusNode();
  final FocusNode myFocusLinhaProduto = FocusNode();
  final FocusNode myFocusObservacao = FocusNode();

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

  _ResponderPesquisaState(this.data);

  @override
  Widget build(BuildContext context) {
    _observacaoController.text = data.observacao;
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('pt'), const Locale('BR')],
      home: Scaffold(
        appBar: AppBar(
          title: Text("Observações", style: TextStyle(fontFamily: "QuickSand")),
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
                      return Stack(
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
                                              setState(() {
                                                _currentPage = page;
                                              });
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
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    elevation: 15,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          SizedBox(
                                                              height: 30.0),
                                                          SizedBox(
                                                              height: 15.0),
                                                          Card(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            elevation: 10,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                height: 250,
                                                                child:
                                                                    TextField(
                                                                  focusNode:
                                                                      myFocusObservacao,
                                                                  enabled: true,
                                                                  maxLines: 10,
                                                                  controller:
                                                                      _observacaoController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "WorkSansSemiBold",
                                                                      fontSize:
                                                                          13.0,
                                                                      color: Colors
                                                                          .black),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.white),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.white),
                                                                    ),
                                                                    border:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.white),
                                                                    ),
                                                                    hintStyle: TextStyle(
                                                                        fontFamily:
                                                                            "Georgia",
                                                                        fontSize:
                                                                            10.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetalhamentoPesquisa(data)));
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
                                                                            _pageController.nextPage(
                                                                              duration: Duration(milliseconds: 500),
                                                                              curve: Curves.ease,
                                                                            );
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
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    elevation: 15,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
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
                                                              shrinkWrap: true,
                                                              itemCount: data
                                                                  .linhaProduto
                                                                  .length,
                                                              itemBuilder:
                                                                  (_, index) {
                                                                String
                                                                    nomeCategoria =
                                                                    data.linhaProduto[
                                                                        index];

                                                                return InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        // retorna um objeto do tipo Dialog
                                                                        return AlertDialog(
                                                                          title:
                                                                              new Text("Informe os estoques dos produtos abaixo\n(antes da reposição)"),
                                                                          content:
                                                                              new Column(
                                                                            children: [
                                                                              FutureBuilder(
                                                                                future: Firestore.instance.collection("Empresas").document("ydj6RHQ8g1ahwDABJHM9ipb0Wnu1").collection("Produtos").where("nomeLinha", isEqualTo: nomeCategoria).getDocuments(),
                                                                                builder: (context, snapshotProdutos) {
                                                                                  if (!snapshotProdutos.hasData) {
                                                                                    return LinearProgressIndicator();
                                                                                  } else {
                                                                                    return ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: snapshotProdutos.data.documents.length,
                                                                                        itemBuilder: (_, indexProduto) {
                                                                                          ProductData data = ProductData.fromDocument(snapshotProdutos.data.documents[indexProduto]);

                                                                                          return ProdutosTile(data);
                                                                                        });
                                                                                  }
                                                                                },
                                                                              )
                                                                            ],
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            // define os botões na base do dialogo
                                                                            new FlatButton(
                                                                              child: new Text("Fechar"),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
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
                                                                          ListTile(
                                                                        trailing:
                                                                            Card(
                                                                          color:
                                                                              Color(0xFF4FCEB6),
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(10),
                                                                            child:
                                                                                Text(
                                                                              "Concluída",
                                                                              style: TextStyle(color: Colors.white, fontFamily: "QuickSandRegular"),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        title:
                                                                            Text(
                                                                          "" +
                                                                              nomeCategoria,
                                                                          style: TextStyle(
                                                                              fontFamily: "QuickSand",
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                        subtitle:
                                                                            Text(
                                                                          "Toque para editar a pesquisa",
                                                                          style: TextStyle(
                                                                              fontFamily: "QuickSandRegular",
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black54),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                      )),
                                                                );
                                                              }),
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
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetalhamentoPesquisa(data)));
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
                                                                            _pageController.nextPage(
                                                                              duration: Duration(milliseconds: 500),
                                                                              curve: Curves.ease,
                                                                            );
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
                                              Padding(
                                                padding: const EdgeInsets.only(
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

  Future getLojas() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection("Empresas")
        .document(UserModel.of(context).firebaseUser.uid)
        .collection("Lojas")
        .getDocuments();

    return qn.documents;
  }
}
