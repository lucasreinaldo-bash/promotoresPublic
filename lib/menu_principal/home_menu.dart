import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/drawer/custom_drawer.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/style/style.dart';

import 'detalhamentoPesquisa.dart';
import 'exibirPesquisa.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
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

  Color colorCard = Color(0xFF365BE5);
  Color colorCardFiltro = Color(0xFF8E1FF3);
  Color colorFloating = Color(0xFF4388F8);
  Color verdeClaro = Color(0xFF4FCEB6);

  String filtro = "Todas";
  String termoBusca = "nenhum";
  String tipoDeBusca = "nomeLoja";
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
          print("Recebi alguma mensagem");
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Scaffold(
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
                                    showAnimatedDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return CustomDialogWidget(
                                            title: Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Configurar Busca",
                                                  style: TextStyle(
                                                      fontFamily: "QuickSand",
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "(Selecione o Parâmetro a ser utilizado)",
                                                  style: TextStyle(
                                                      fontFamily: "Helvetica",
                                                      fontSize: 12),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      tipoDeBusca = "nomeLoja";
                                                    });
                                                    Navigator.pop(context);

                                                    Flushbar(
                                                      title:
                                                          "Filtro de Busca alterado",
                                                      message:
                                                          "O parâmetro da busca será o Nome da Loja",
                                                      flushbarPosition:
                                                          FlushbarPosition
                                                              .BOTTOM,
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .GROUNDED,
                                                      isDismissible: true,
                                                      backgroundColor: Colors
                                                          .deepPurpleAccent,
                                                      duration: const Duration(
                                                          seconds: 6),
                                                    ).show(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Card(
                                                    child: ListTile(
                                                      leading: Icon(
                                                          FontAwesomeIcons
                                                              .store),
                                                      title: Text(
                                                          "Nome da Loja",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Helvetica",
                                                              fontSize: 14)),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      tipoDeBusca = "nomeRede";
                                                    });
                                                    Navigator.pop(context);

                                                    Flushbar(
                                                      title:
                                                          "Filtro de Busca alterado",
                                                      message:
                                                          "O parâmetro da busca será o Nome da Rede",
                                                      flushbarPosition:
                                                          FlushbarPosition
                                                              .BOTTOM,
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .GROUNDED,
                                                      isDismissible: true,
                                                      backgroundColor: Colors
                                                          .deepPurpleAccent,
                                                      duration: const Duration(
                                                          seconds: 6),
                                                    ).show(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Card(
                                                    child: ListTile(
                                                      leading:
                                                          Icon(Icons.store),
                                                      title: Text(
                                                          "Nome da Rede",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Helvetica",
                                                              fontSize: 14)),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      tipoDeBusca =
                                                          "nomePromotor";
                                                    });
                                                    Navigator.pop(context);

                                                    Flushbar(
                                                      title:
                                                          "Filtro de Busca alterado",
                                                      message:
                                                          "O parâmetro da busca será o Nome do Promotor",
                                                      flushbarPosition:
                                                          FlushbarPosition
                                                              .BOTTOM,
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .GROUNDED,
                                                      isDismissible: true,
                                                      backgroundColor: Colors
                                                          .deepPurpleAccent,
                                                      duration: const Duration(
                                                          seconds: 6),
                                                    ).show(context);
                                                  },
                                                  child: Card(
                                                    child: ListTile(
                                                      leading: Icon(
                                                          FontAwesomeIcons
                                                              .user),
                                                      title: Text(
                                                          "Nome do Promotor",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Helvetica",
                                                              fontSize: 14)),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                      },
                                      animationType:
                                          DialogTransitionType.slideFromTop,
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(seconds: 1),
                                    );
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
                        color:
                            filtro == "Todas" ? colorCardFiltro : Colors.white,
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
                        color:
                            filtro == "ABERTA" ? colorCardFiltro : Colors.white,
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
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Promotores")
                      .document(UserModel.of(context).firebaseUser.uid)
                      .snapshots(),
                  builder: (context, snapshotPromotor) {
                    if (!snapshotPromotor.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return FutureBuilder(
                        future: Firestore.instance
                            .collection("Empresas")
                            .document(snapshotPromotor.data["empresaVinculada"])
                            .collection("pesquisasCriadas")
                            .where(
                                filtro == "Todas"
                                    ? "empresaResponsavel"
                                    : "status",
                                isEqualTo: filtro == "Todas"
                                    ? snapshotPromotor.data["empresaVinculada"]
                                    : filtro.toString().toUpperCase())
                            .where("idPromotor",
                                isEqualTo:
                                    UserModel.of(context).firebaseUser.uid)
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
                                                    ExibirPesquisa(data)));
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
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
