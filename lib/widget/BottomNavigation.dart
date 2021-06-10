import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:date_format/date_format.dart' as da;

import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/responder_pesquisa/responder_pesquisa.dart';

class BottomNavigationPesquisa extends StatefulWidget {
  PesquisaData data;

  BottomNavigationPesquisa(this.data);
  @override
  _BottomNavigationPesquisaState createState() =>
      _BottomNavigationPesquisaState(this.data);
}

class _BottomNavigationPesquisaState extends State<BottomNavigationPesquisa> {
  PesquisaData data;

  int _indiceAtual = 0;
  List list = new List();

  _BottomNavigationPesquisaState(this.data);

  @override
  Widget build(BuildContext context) {
    return data.aceita == true
        ? BottomNavigationBar(
            iconSize: 10,
            currentIndex: 0,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/home.png",
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                  title: Text("", style: TextStyle(color: Colors.grey))),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Container(
                        width: 125,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: data.status == "CONCLUÍDA" ||
                                    data.status == "A APROVAR"
                                ? null
                                : () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResponderPesquisaData(data)));
                                  },
                            color: Color(0xFF4FCEB6),
                            textColor: Colors.white,
                            child: data.status != "ABERTA"
                                ? Text("Respondida",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontFamily: "QuickSandRegular"))
                                : Text("Continuar",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "QuickSandRegular"))),
                      ),
                    ],
                  ),
                  title: Text("", style: TextStyle(color: Colors.grey))),
            ],
          )
        : BottomNavigationBar(
            iconSize: 10,
            currentIndex: _indiceAtual,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/home.png",
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                  title: Text("", style: TextStyle(color: Colors.grey))),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/icon_aprovado.png",
                        height: 30,
                        width: 30,
                      )
                    ],
                  ),
                  title: Text("", style: TextStyle(color: Colors.grey))),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/icon_reprovado.png",
                        height: 30,
                        width: 30,
                      )
                    ],
                  ),
                  title: Text("", style: TextStyle(color: Colors.grey))),
            ],
          );
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
      print(index);

      if (_indiceAtual == 0) {
        Navigator.pop(context);
      } else if (data.status != "A APROVAR") {
        bottomDialogPesquisa();
      } else {}
    });
  }

  void bottomDialogPesquisa() {
    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14.0),
                  topRight: const Radius.circular(14.0),
                ),
              ),
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                            _indiceAtual == 1
                                ? "Deseja Aceitar essa pesquisa?"
                                : _indiceAtual == 2
                                    ? "Deseja Recusar essa pesquisa ?"
                                    : "Deseja Excluir essa pesquisa?",
                            style: TextStyle(fontFamily: "QuickSand"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: () async {
                                  switch (_indiceAtual) {
                                    case 1:
                                      print(data.aceita);
                                      aceitarPesquisa();
                                      break;
                                    case 2:
                                      recusarPesquisa();
                                      break;
                                  }
                                },
                                color: Color(0xFF4FCEB6),
                                textColor: Colors.white,
                                child: Text("Sim",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "QuickSandRegular"))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                color: Color(0xFFF26768),
                                textColor: Colors.white,
                                child: Text("Não",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "QuickSandRegular"))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    _settingModalBottomSheet(context);
  }

  void aceitarPesquisa() async {
    await Firestore.instance
        .collection("Empresas")
        .document(data.empresaResponsavel)
        .collection("pesquisasCriadas")
        .document(data.id)
        .updateData({"aceita": true});
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ResponderPesquisaData(data)));
  }

  void recusarPesquisa() async {
    await Firestore.instance
        .collection("Empresas")
        .document(data.empresaResponsavel)
        .collection("pesquisasCriadas")
        .document(data.id)
        .updateData({"aceita": false});

    await Firestore.instance
        .collection("Empresas")
        .document(data.empresaResponsavel)
        .collection("pesquisasCriadas")
        .document(data.id)
        .updateData({"rejeitada": true});

    Navigator.of(context).pop();

  }
}
