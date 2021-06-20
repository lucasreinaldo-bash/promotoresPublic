import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:versaoPromotores/menu_principal/home_menu.dart';

dialogAnimado(
    {String urlImagem,
    String titulo,
    String subtitulo,
    String buttonConfirm,
    BuildContext context}) {
  showDialog(
      context: context,
      builder: (_) => NetworkGiffyDialog(
            buttonCancelText: Text(""),
            onOkButtonPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeMenu("Todas", "termosBuscaPromotor")));
            },
            buttonOkText: Text(buttonConfirm),
            onlyOkButton: true,
            image: Image.network(
              urlImagem,
              fit: BoxFit.cover,
            ),
            title: Text(
              titulo,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            description: Text(
              subtitulo,
              textAlign: TextAlign.center,
            ),
            entryAnimation: EntryAnimation.RIGHT,
          ));
}
