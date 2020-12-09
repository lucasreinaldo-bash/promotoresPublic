import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/menu_principal/datas/LojaData.dart';

// ignore: must_be_immutable
class LojaTile extends StatelessWidget {
  final LojaData lojaData;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone, uid;
  double latitude, longitude;

  LojaTile(this.uid, this.lojaData);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
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
                              "Rede: " + lojaData.nomeRede,
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: "QuickSand",
                              ),
                            ),
                            Text(
                              "Nome da Loja: " + lojaData.nomeLoja,
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                            Divider()
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ],
        )));
  }
}
