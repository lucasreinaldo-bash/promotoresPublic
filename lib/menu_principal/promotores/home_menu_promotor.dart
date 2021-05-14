import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/drawer/custom_drawer.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/home_menu.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/style/style.dart';

import '../detalhamentoPesquisa.dart';

class HomeMenuPromotor extends StatefulWidget {
  @override
  _HomeMenuPromotor createState() => _HomeMenuPromotor();
}

class _HomeMenuPromotor extends State<HomeMenuPromotor> {
  final _pesquisaController = TextEditingController();
  final FocusNode myFocusPesquisa = FocusNode();

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

  String empresaVinculada = "nenhuma";
  Color colorCard = Color(0xFF365BE5);
  Color colorCardFiltro = Color(0xFF8E1FF3);
  Color colorFloating = Color(0xFF4388F8);
  Color verdeClaro = Color(0xFF4FCEB6);

  String filtro;
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

  FirebaseUser firebaseUser;
  String uidPromotor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarUser();
    configFCM(context);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Desconectar do App?'),
            content: new Text('Você irá se deslogar dessa conta.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Cancelar'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeMenu("Todas", "termosBuscaPromotor")),
                  );
                },
                child: new Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void configFCM(BuildContext context) {
    if (Platform.isIOS) {
      final fcm = FirebaseMessaging();

      fcm.requestNotificationPermissions(
          const IosNotificationSettings(provisional: true));

      fcm.configure(
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume $message');
        },
        onMessage: (Map<String, dynamic> message) async {
          showNotification(message['notification']['title'] as String,
              message['notification']['body'] as String);
        },
      );
    } else {
      final fcm = FirebaseMessaging();

      fcm.configure(
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume $message');
        },
        onMessage: (Map<String, dynamic> message) async {
          print("Recebi algumaa mensagem");
          showNotification(message['notification']['title'] as String,
              message['notification']['body'] as String);
        },
      );
    }
  }

  void showNotification(String title, String message) {
    Flushbar(
        title: title,
        message: message,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        isDismissible: true,
        backgroundColor: Colors.deepPurpleAccent,
        duration: const Duration(seconds: 6),
        icon: Card(
          child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset("assets/logo.png"),
              )),
        )).show(context);
  }

  carregarUser() async {
    uidPromotor = await firebaseUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder(
          stream: Firestore.instance
              .collection("Promotores")
              .document(uidPromotor)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: CircularProgressIndicator(),
              );
            } else {
              empresaVinculada = snapshot.data["empresaVinculada"];
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                  ),
                  backgroundColor: colorFloating,
                  onPressed: () {
                    Navigator.pushNamed(context, "/criarPesquisa");
                  },
                ),
                drawer: CustomDrawer(),
                appBar: AppBar(
                  backgroundColor: Colors.deepPurple,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        color: colorCard,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: Text(
                                  'Pesquisas',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily: "QuickSandRegular"),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Card(
                              elevation: 5,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextField(
                                  focusNode: myFocusPesquisa,
                                  controller: _pesquisaController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 13.0,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    prefixIcon: InkWell(
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 20.0,
                                      ),
                                    ),
                                    suffixIcon: (InkWell(
                                        onTap: () {
                                          Dialog();
                                        },
                                        child: Image.asset(
                                          "assets/config_icon.png",
                                          height: 2,
                                        ))),
                                    border: InputBorder.none,
                                    hintText: "Digite um termo",
                                    hintStyle: TextStyle(
                                        fontFamily: "Georgia", fontSize: 10.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Card(
                              color: filtro == "Todas"
                                  ? colorCardFiltro
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 70,
                                width: 70,
                                child: Center(
                                  child: Text(
                                    "Todas",
                                    style: TextStyle(
                                        fontFamily: "QuickSand",
                                        fontSize: 12,
                                        color: filtro == "Todas"
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                filtro = "Todas";
                              });
                              initState();
                            },
                          ),
                          InkWell(
                            child: Card(
                              color: filtro == "ABERTA"
                                  ? colorCardFiltro
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 70,
                                width: 70,
                                child: Center(
                                  child: Text(
                                    "Abertas",
                                    style: TextStyle(
                                        fontFamily: "QuickSand",
                                        fontSize: 12,
                                        color: filtro == "Abertas"
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                filtro = "ABERTA";
                              });

                              initState();
                            },
                          ),
                          InkWell(
                            child: Card(
                              color: filtro == "A APROVAR"
                                  ? colorCardFiltro
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 70,
                                width: 70,
                                child: Center(
                                  child: Text(
                                    "A Aprovar",
                                    style: TextStyle(
                                        fontFamily: "QuickSand",
                                        fontSize: 12,
                                        color: filtro == "A Aprovar"
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                filtro = "A APROVAR";
                              });

                              initState();
                            },
                          ),
                          InkWell(
                            child: Card(
                              color: filtro == "CONCLUÍDA"
                                  ? colorCardFiltro
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 70,
                                width: 70,
                                child: Center(
                                  child: Text(
                                    "Concluídas",
                                    style: TextStyle(
                                        fontFamily: "QuickSand",
                                        fontSize: 12,
                                        color: filtro == "Concluídas"
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                filtro = "CONCLUÍDA";
                              });

                              initState();
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: Firestore.instance
                            .collection("Empresas")
                            .document(empresaVinculada)
                            .collection("pesquisasCriadas")
                            .where(
                                filtro == "Todas"
                                    ? "empresaResponsavel"
                                    : "status",
                                isEqualTo: filtro == "Todas"
                                    ? UserModel.of(context).firebaseUser.uid
                                    : filtro)
                            .getDocuments(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            bool corApertou = false;
                            return Container(
                              height: 300,
                              width: 400,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (_, index) {
                                    PesquisaData data =
                                        PesquisaData.fromDocument(
                                            snapshot.data.documents[index]);
                                    return InkWell(
                                      onTap: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetalhamentoPesquisa(
                                                        data)));
//
                                      },
                                      child: Card(
                                        elevation: 2,
                                        color: corApertou == true
                                            ? Colors.white70
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "" +
                                                                  data.nomeLoja
                                                                      .toUpperCase() +
                                                                  "\n" +
                                                                  data.nomeRede +
                                                                  "\n" +
                                                                  data.nomePromotor,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "QuickSand",
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Card(
                                                                color:
                                                                    verdeClaro,
                                                                child: Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          "TAG",
                                                                          style: TextStyle(
                                                                              fontFamily: "QuickSand",
                                                                              fontSize: 12,
                                                                              color: Colors.white),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ))),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "" +
                                                                  data.dataInicial,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "QuickSand",
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "" + data.status,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "QuickSand",
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
