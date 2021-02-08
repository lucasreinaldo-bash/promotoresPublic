import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart' as da;
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';

import '../detalhamentoPesquisa.dart';
import '../home_menu.dart';

class PesquisaTile extends StatefulWidget {
  PesquisaData data;

  BuildContext contextHome;
  PesquisaTile(this.data, this.contextHome);

  @override
  _PesquisaTileState createState() =>
      _PesquisaTileState(this.data, this.contextHome);
}

class _PesquisaTileState extends State<PesquisaTile> {
  PesquisaData data;
  bool corApertou;

  BuildContext contextHome;
  List list = new List();
  Color colorCard = Color(0xFF365BE5);
  Color colorCardFiltro = Color(0xFF8E1FF3);
  Color colorFloating = Color(0xFF4388F8);
  Color verdeClaro = Color(0xFF4FCEB6);
  _PesquisaTileState(this.data, this.contextHome);
  @override
  Widget build(contextHome) {
    return InkWell(
      onLongPress: () {
        setState(() {
          if (corApertou == true) {
            corApertou = false;
          } else {
            corApertou = true;

            setState(() {});
          }
        });
      },
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetalhamentoPesquisa(data)));
//
      },
      child: Card(
        elevation: 2,
        color: corApertou == true ? Colors.white60 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "" +
                                  data.nomeLoja.toUpperCase() +
                                  "\n" +
                                  data.nomeRede +
                                  "\n" +
                                  data.nomePromotor,
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Card(
                                color: verdeClaro,
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "TAG",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ))),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "" + data.dataInicial,
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 10,
                                  color: Colors.black54),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "" + data.status,
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 10,
                                  color: Colors.black54),
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
  }
}
