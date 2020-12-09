import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart' as da;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/drawer/custom_drawer.dart';
import 'package:versaoPromotores/menu_principal/datas/LinhaProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/LojaData.dart';
import 'package:versaoPromotores/menu_principal/home_menu.dart';
import 'package:versaoPromotores/menu_principal/tiles/loja_tile.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/style/style.dart';

import 'datas/PromotorData.dart';

class CriarPesquisa extends StatefulWidget {
  @override
  _CriarPesquisaState createState() => _CriarPesquisaState();
}

class _CriarPesquisaState extends State<CriarPesquisa> {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('pt'), const Locale('BR')],
      home: Scaffold(
        appBar: AppBar(
          title:
              Text("Nova Pesquisa", style: TextStyle(fontFamily: "QuickSand")),
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
                          Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 600.0,
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                bottom: 100),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              color: Colors.white,
                                              elevation: 15,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Center(
                                                      child: Text(
                                                        'Pesquisas',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                "QuickSandRegular"),
                                                      ),
                                                    ),
                                                    SizedBox(height: 30.0),
                                                    TextField(
                                                      focusNode:
                                                          myFocusNomeLoja,
                                                      enabled: true,
                                                      enableInteractiveSelection:
                                                          false,
                                                      controller:
                                                          _nomeLojaController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                          fontSize: 13.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: (InkWell(
                                                            onTap: () {
                                                              showAnimatedDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                      content:
                                                                          Column(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              30),
                                                                      TextField(
                                                                        onEditingComplete:
                                                                            () {
                                                                          model
                                                                              .notifyListeners();
                                                                          setState(
                                                                              () {
                                                                            print("Terminei de digitar");
                                                                          });
                                                                          initState();
                                                                        },
                                                                        controller:
                                                                            _pesquisarLojaController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "WorkSansSemiBold",
                                                                            fontSize:
                                                                                13.0,
                                                                            color:
                                                                                Colors.black),
                                                                        decoration:
                                                                            new InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(Icons.search),
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                                                          hintText:
                                                                              "Nome da Loja",
                                                                          hintStyle: TextStyle(
                                                                              fontFamily: "Georgia",
                                                                              fontSize: 10.0),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: FutureBuilder<
                                                                            QuerySnapshot>(
                                                                          future: _pesquisarLojaController.text.length == 0
                                                                              ? Firestore.instance.collection("Empresas").document(model.firebaseUser.uid).collection("Lojas").getDocuments()
                                                                              : Firestore.instance.collection("Empresas").document(model.firebaseUser.uid).collection("Lojas").where("termosBusca", arrayContains: _pesquisarLojaController.text).getDocuments(),
                                                                          builder:
                                                                              (_, s) {
                                                                            if (s.connectionState ==
                                                                                ConnectionState.waiting) {
                                                                              return new Center(
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                            } else {
                                                                              return new ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: s.data.documents.length,
                                                                                  itemBuilder: (_, index) {
                                                                                    LojaData data = LojaData.fromDocument(s.data.documents[index]);
                                                                                    return InkWell(
                                                                                      onTap: () {
                                                                                        _nomeLojaController.text = data.nomeLoja;
                                                                                        nomeRede = data.nomeRede;
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Card(
                                                                                          child: Stack(
                                                                                        children: <Widget>[
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: <Widget>[
                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              Flexible(
                                                                                                  flex: 1,
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: <Widget>[
                                                                                                      Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        children: <Widget>[
                                                                                                          Text(
                                                                                                            "Rede: " + data.nomeRede,
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 9,
                                                                                                              fontFamily: "QuickSand",
                                                                                                            ),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "Nome da Loja: " + data.nomeLoja,
                                                                                                            style: TextStyle(fontFamily: "QuickSand", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                                                                                                          ),
                                                                                                          Divider()
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ))
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      )),
                                                                                    );
                                                                                  });
                                                                            }
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ));
                                                                },
                                                                animationType:
                                                                    DialogTransitionType
                                                                        .size,
                                                                curve: Curves
                                                                    .fastOutSlowIn,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                              );
                                                            },
                                                            child: Image.asset(
                                                              "assets/icon_mais.png",
                                                              height: 1,
                                                            ))),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "Nome da Loja: ",
                                                        hintText:
                                                            "Nome da Loja",
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "Georgia",
                                                            fontSize: 10.0),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    TextField(
                                                      focusNode:
                                                          myFocusPesquisa,
                                                      controller:
                                                          _nomePromotorController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                          fontSize: 13.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: (InkWell(
                                                            onTap: () {
                                                              showAnimatedDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                      content:
                                                                          Column(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              30),
                                                                      TextField(
                                                                        focusNode:
                                                                            myFocusPesquisa,
                                                                        controller:
                                                                            _pesquisarLojaController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "WorkSansSemiBold",
                                                                            fontSize:
                                                                                13.0,
                                                                            color:
                                                                                Colors.black),
                                                                        decoration:
                                                                            new InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(Icons.search),
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                                                          hintText:
                                                                              "Nome do Promotor",
                                                                          hintStyle: TextStyle(
                                                                              fontFamily: "Georgia",
                                                                              fontSize: 10.0),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: FutureBuilder<
                                                                            QuerySnapshot>(
                                                                          future: Firestore
                                                                              .instance
                                                                              .collection("Promotores")
                                                                              .where("empresaVinculada", isEqualTo: model.firebaseUser.uid)
                                                                              .getDocuments(),
                                                                          builder:
                                                                              (_, s) {
                                                                            if (s.connectionState ==
                                                                                ConnectionState.waiting) {
                                                                              return new Center(
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                            } else {
                                                                              return new ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: s.data.documents.length,
                                                                                  itemBuilder: (_, index) {
                                                                                    PromotorData data = PromotorData.fromDocument(s.data.documents[index]);
                                                                                    return InkWell(
                                                                                      onTap: () {
                                                                                        _nomePromotorController.text = data.nomePromotor;
                                                                                        idPromotor = data.id;
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Card(
                                                                                          child: Stack(
                                                                                        children: <Widget>[
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: <Widget>[
                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              Flexible(
                                                                                                  flex: 1,
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: <Widget>[
                                                                                                      Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        children: <Widget>[
                                                                                                          Text(
                                                                                                            "Promotor: " + data.nomePromotor,
                                                                                                            style: TextStyle(fontFamily: "QuickSand", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "e-mail: " + data.email,
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 9,
                                                                                                              fontFamily: "QuickSand",
                                                                                                            ),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "Tipo Contrato: " + data.tipoContrato,
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 9,
                                                                                                              fontFamily: "QuickSand",
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider()
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ))
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      )),
                                                                                    );
                                                                                  });
                                                                            }
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ));
                                                                },
                                                                animationType:
                                                                    DialogTransitionType
                                                                        .size,
                                                                curve: Curves
                                                                    .fastOutSlowIn,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                              );
                                                            },
                                                            child: Image.asset(
                                                              "assets/icon_mais.png",
                                                              height: 1,
                                                            ))),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: "Promotor: ",
                                                        hintText:
                                                            "Nome do Promotor",
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "Georgia",
                                                            fontSize: 10.0),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    TextField(
                                                      focusNode:
                                                          myFocusPesquisa,
                                                      controller:
                                                          _linhaProdutoController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                          fontSize: 13.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: (InkWell(
                                                            onTap: () {
                                                              showAnimatedDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                      content:
                                                                          Column(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              30),
                                                                      TextField(
                                                                        focusNode:
                                                                            myFocusPesquisa,
                                                                        controller:
                                                                            _pesquisarLojaController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "WorkSansSemiBold",
                                                                            fontSize:
                                                                                13.0,
                                                                            color:
                                                                                Colors.black),
                                                                        decoration:
                                                                            new InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(Icons.search),
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                                                          hintText:
                                                                              "Nome do Promotor",
                                                                          hintStyle: TextStyle(
                                                                              fontFamily: "Georgia",
                                                                              fontSize: 10.0),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: FutureBuilder<
                                                                            QuerySnapshot>(
                                                                          future: Firestore
                                                                              .instance
                                                                              .collection("Empresas")
                                                                              .document(model.firebaseUser.uid)
                                                                              .collection("linhasProdutos")
                                                                              .getDocuments(),
                                                                          builder:
                                                                              (_, s) {
                                                                            if (s.connectionState ==
                                                                                ConnectionState.waiting) {
                                                                              return new Center(
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                            } else {
                                                                              return new ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: s.data.documents.length,
                                                                                  itemBuilder: (_, index) {
                                                                                    LinhaProdutoData data = LinhaProdutoData.fromDocument(s.data.documents[index]);
                                                                                    return InkWell(
                                                                                      onTap: () {
                                                                                        _linhaProdutoController.text = data.nomeLinha;
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Card(
                                                                                          child: Stack(
                                                                                        children: <Widget>[
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: <Widget>[
                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              Flexible(
                                                                                                  flex: 1,
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: <Widget>[
                                                                                                      Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        children: <Widget>[
                                                                                                          Text(
                                                                                                            "Linha: " + data.nomeLinha,
                                                                                                            style: TextStyle(fontFamily: "QuickSand", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                                                                                                          ),
                                                                                                          Divider()
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ))
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      )),
                                                                                    );
                                                                                  });
                                                                            }
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ));
                                                                },
                                                                animationType:
                                                                    DialogTransitionType
                                                                        .size,
                                                                curve: Curves
                                                                    .fastOutSlowIn,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                              );
                                                            },
                                                            child: Image.asset(
                                                              "assets/icon_mais.png",
                                                              height: 1,
                                                            ))),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "Linha do Produto: ",
                                                        hintText:
                                                            "Linha do Produto",
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "Georgia",
                                                            fontSize: 10.0),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Text(
                                                        "Quando a pesquisa deverá ser realizada?"),
                                                    SizedBox(height: 10.0),
                                                    TextField(
                                                      focusNode: myFocusData,
                                                      controller:
                                                          _dataController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                          fontSize: 13.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: (InkWell(
                                                            onTap: () async {
                                                              final DateTimeRange
                                                                  picked =
                                                                  await showDateRangePicker(
                                                                locale:
                                                                    const Locale(
                                                                        "pt",
                                                                        "BR"),
                                                                context:
                                                                    context,
                                                                helpText:
                                                                    "SELECIONE A DATA DA PESQUISA",
                                                                confirmText:
                                                                    "CONFIRMAR",
                                                                firstDate:
                                                                    DateTime(
                                                                        2000),
                                                                lastDate:
                                                                    DateTime(
                                                                        2030),
                                                              );

                                                              dataInicioPesquisa = picked
                                                                      .start.day
                                                                      .toString() +
                                                                  "/" +
                                                                  picked.start
                                                                      .month
                                                                      .toString() +
                                                                  "/" +
                                                                  picked.start
                                                                      .year
                                                                      .toString();

                                                              dataFinalPesquisa = picked
                                                                      .end.day
                                                                      .toString() +
                                                                  "/" +
                                                                  picked
                                                                      .end.month
                                                                      .toString() +
                                                                  "/" +
                                                                  picked
                                                                      .end.year
                                                                      .toString();

                                                              _dataController
                                                                      .text =
                                                                  "Início: " +
                                                                      dataInicioPesquisa +
                                                                      " Término: " +
                                                                      dataFinalPesquisa;
                                                            },
                                                            child: Icon(Icons
                                                                .calendar_today))),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "Data da Pesquisa",
                                                        hintText: "22/12/2020",
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "Georgia",
                                                            fontSize: 10.0),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    SizedBox(height: 15.0),
                                                    Expanded(
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
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                'Próximo',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      22.0,
                                                                ),
                                                              ),
                                                            ],
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
                                          Expanded(
                                            child: Padding(
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
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(height: 30.0),
                                                      SizedBox(height: 15.0),
                                                      TextField(
                                                        focusNode:
                                                            myFocusObservacao,
                                                        enabled: true,
                                                        maxLines: 10,
                                                        controller:
                                                            _observacaoController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "WorkSansSemiBold",
                                                            fontSize: 13.0,
                                                            color:
                                                                Colors.black),
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText:
                                                              "Observação...",
                                                          hintText:
                                                              "Adicione qualquer informação relevante para auxiliar o promotor na execução da pesquisa.",
                                                          hintStyle: TextStyle(
                                                              fontFamily:
                                                                  "Georgia",
                                                              fontSize: 10.0),
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
                                                                        _pageController
                                                                            .previousPage(
                                                                          duration:
                                                                              Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.ease,
                                                                        );
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            'Anterior',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 22.0,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 10.0),
                                                                          Icon(
                                                                            Icons.arrow_forward,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                30.0,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    FlatButton(
                                                                      onPressed:
                                                                          () async {
                                                                        DocumentReference referenciaOrdem = await Firestore
                                                                            .instance
                                                                            .collection("Empresas")
                                                                            .document(model.firebaseUser.uid)
                                                                            .collection("pesquisasCriadas")
                                                                            .add({
                                                                          "empresaResponsavel": model
                                                                              .firebaseUser
                                                                              .uid,
                                                                          "nomeLoja":
                                                                              _nomeLojaController.text,
                                                                          "nomePromotor":
                                                                              _nomePromotorController.text,
                                                                          "idPromotor":
                                                                              idPromotor,
                                                                          "nomeRede":
                                                                              nomeRede,
                                                                          "linhaProduto":
                                                                              _linhaProdutoController.text,
                                                                          "dataInicial":
                                                                              dataInicioPesquisa,
                                                                          "dataFinal":
                                                                              dataFinalPesquisa,
                                                                          "observacao":
                                                                              _observacaoController.text,
                                                                          "dataCriacao": da.formatDate(DateTime.now(), [
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
                                                                          "data_query":
                                                                              DateTime.now().microsecondsSinceEpoch,
                                                                          "status":
                                                                              "ABERTO",
                                                                          "promotor":
                                                                              "nenhum"
                                                                        });

                                                                        _pageController
                                                                            .nextPage(
                                                                          duration:
                                                                              Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.ease,
                                                                        );
                                                                        await Future.delayed(
                                                                            Duration(
                                                                                seconds:
                                                                                    3),
                                                                            () =>
                                                                                {
                                                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeMenu()))
                                                                                });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            'Finalizar',
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
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
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _buildPageIndicator(),
                                  ),
                                ],
                              ),
                            ),
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
