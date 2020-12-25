import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_ruptura.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_validade.dart';

import 'datas/ProdutoData.dart';

class ProductTileRupturaScreen extends StatelessWidget {
  PesquisaData data;
  String nomeCategoria;

  ProductTileRupturaScreen(this.data, this.nomeCategoria);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF365BE5),
        ),
        body: Stack(
          children: [
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/fundo_validade.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null /* add child content content here */,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Informe os produtos\ncom poucas unidades:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                        color: Color(0xFFF1EBFD),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 400,
                            child: Column(
                              children: [
                                Text(
                                    "Selecione os produtos com poucas unidades na área de venda:"),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Color(0xFFFFFFFF),
                                  child: Container(
                                    height: 300,
                                    child: FutureBuilder(
                                      future: Firestore.instance
                                          .collection("Empresas")
                                          .document(
                                              "ydj6RHQ8g1ahwDABJHM9ipb0Wnu1")
                                          .collection("Produtos")
                                          .where("nomeLinha",
                                              isEqualTo: nomeCategoria)
                                          .getDocuments(),
                                      builder: (context, snapshotProdutos) {
                                        if (!snapshotProdutos.hasData) {
                                          return LinearProgressIndicator();
                                        } else {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshotProdutos
                                                  .data.documents.length,
                                              itemBuilder: (_, indexProduto) {
                                                ProductData dataProdutos =
                                                    ProductData.fromDocument(
                                                        snapshotProdutos
                                                                .data.documents[
                                                            indexProduto]);

                                                return ProdutosTileRuptura(
                                                    data, dataProdutos);
                                              });
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
