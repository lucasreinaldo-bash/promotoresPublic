import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_validade.dart';

import 'datas/ProdutoData.dart';

class ProductTileValidadeScreen extends StatelessWidget {
  PesquisaData data;
  String nomeCategoria;

  ProductTileValidadeScreen(this.data, this.nomeCategoria);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF796CE7),
        centerTitle: true,
        title: Text("Área de Venda",
            style: TextStyle(
              fontFamily: "Helvetica",
              color: Colors.white,
              fontSize: 16,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    height: 500,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                              "Informe somente as datas dos produtos com vencimentos próximos"),
                          Container(
                            height: 4,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Container(
                            color: Colors.black12,
                            height: 2,
                            width: MediaQuery.of(context).size.width,
                          ),
                          FutureBuilder(
                            future: Firestore.instance
                                .collection("Empresas")
                                .document(data.empresaResponsavel)
                                .collection("Lojas")
                                .document(data.nomeLoja)
                                .collection("Produtos")
                                .where("nomeLinha", isEqualTo: nomeCategoria)
                                .getDocuments(),
                            builder: (context, snapshotProdutos) {
                              if (!snapshotProdutos.hasData) {
                                return LinearProgressIndicator();
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshotProdutos.data.documents.length,
                                    itemBuilder: (_, indexProduto) {
                                      ProductData dataProdutos =
                                          ProductData.fromDocument(
                                              snapshotProdutos.data
                                                  .documents[indexProduto]);

                                      return ProdutosTileValidade(
                                          data, dataProdutos);
                                    });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black54),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              "Salvar",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
