import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData_ruptura_validade.dart';
import 'package:versaoPromotores/menu_principal/datas/estoqueDeposito_data.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/datas/pontoExtraImagemData.dart';

import 'exibirImagem.dart';

class DetalhamentoLinha extends StatelessWidget {
  String nomeLinha;
  PesquisaData data;

  DetalhamentoLinha(this.nomeLinha, this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeLinha, style: TextStyle(fontFamily: "QuickSand")),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Fotos Capturadas",
                  style: TextStyle(fontFamily: "QuickSand", fontSize: 15),
                ),
                Divider(),
                SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(
                        height: 150.0,
                        width: 350.0,
                        child: Carousel(
                          images: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 10,
                                    color: Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                          height: 80,
                                          width: 80,
                                          child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("Empresas")
                                                .document(
                                                    data.empresaResponsavel)
                                                .collection("pesquisasCriadas")
                                                .document(data.id)
                                                .collection("imagensLinhas")
                                                .document(nomeLinha)
                                                .collection("BeforeAreaDeVenda")
                                                .document("fotoAntesReposicao")
                                                .snapshots(),
                                            builder: (context, snapImg1) {
                                              if (!snapImg1.hasData) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ExibirImagem(
                                                                    snapImg1.data[
                                                                        "imagem"],
                                                                    "1",
                                                                    "1")));
                                                  },
                                                  child: Image.network(
                                                    snapImg1.data["imagem"],
                                                    fit: BoxFit.fill,
                                                  ),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Aréa de Venda\n(antes da reposição)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "QuickSandRegular",
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 10,
                                    color: Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("Empresas")
                                                .document(
                                                    data.empresaResponsavel)
                                                .collection("pesquisasCriadas")
                                                .document(data.id)
                                                .collection("imagensLinhas")
                                                .document(nomeLinha)
                                                .collection("AfterAreaDeVenda")
                                                .document("fotoDepoisReposicao")
                                                .snapshots(),
                                            builder: (context, snapImg1) {
                                              if (!snapImg1.hasData) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ExibirImagem(
                                                                    snapImg1.data[
                                                                        "imagem"],
                                                                    "1",
                                                                    "1")));
                                                  },
                                                  child: Image.network(
                                                    snapImg1.data["imagem"],
                                                    fit: BoxFit.fill,
                                                  ),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Aréa de Venda\n(após a reposição)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "QuickSandRegular",
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection("Empresas")
                                  .document(data.empresaResponsavel)
                                  .collection("pesquisasCriadas")
                                  .document(data.id)
                                  .collection("pontoExtra")
                                  .document(nomeLinha)
                                  .snapshots(),
                              builder: (context, snapPontoExtra) {
                                if (!snapPontoExtra.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  PontoExtraData pontoExtraData =
                                      PontoExtraData.fromDocument(
                                          snapPontoExtra.data);
                                  return pontoExtraData.existe == false
                                      ? Container()
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) => ExibirImagem(
                                                                pontoExtraData
                                                                    .imagemAntes,
                                                                "2",
                                                                "${pontoExtraData.id} " +
                                                                    "\n(antes da reposição)")));
                                                  },
                                                  child: Card(
                                                    elevation: 10,
                                                    color: Color(0xFFFFFFFF),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Container(
                                                        height: 100,
                                                        width: 100,
                                                        child: Image.network(
                                                          pontoExtraData
                                                              .imagemAntes,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) => ExibirImagem(
                                                                pontoExtraData
                                                                    .imagemAntes,
                                                                "2",
                                                                "${pontoExtraData.id} " +
                                                                    "\n(depois da reposição)")));
                                                  },
                                                  child: Card(
                                                    elevation: 10,
                                                    color: Color(0xFFFFFFFF),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Container(
                                                        height: 100,
                                                        width: 100,
                                                        child: Image.network(
                                                          pontoExtraData
                                                              .imagemDepois,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                )
                                              ],
                                            ),
                                            Text(
                                              "Ponto Extra ${pontoExtraData.id}\n " +
                                                  "(imagem antes e depois)",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily:
                                                      "QuickSandRegular",
                                                  fontSize: 12),
                                            ),
                                          ],
                                        );
                                  ;
                                }
                              },
                            ),
                          ],
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          animationDuration: Duration(seconds: 2),
                          showIndicator: false,
                          dotColor: Colors.white,
                          indicatorBgPadding: 5.0,
                          dotBgColor: Colors.deepPurple.withOpacity(0.5),
                          borderRadius: true,

//                                              moveIndicatorFromBottom: 180.0,
//                                              noRadiusForIndicator: true,
                        ))
                  ]),
                ),
                FutureBuilder(
                  future: Firestore.instance
                      .collection("Empresas")
                      .document(data.empresaResponsavel)
                      .collection("pesquisasCriadas")
                      .document(data.id)
                      .collection("linhasProdutosAntesReposicao")
                      .document(nomeLinha)
                      .collection("Produtos")
                      .where("linha", isEqualTo: nomeLinha)
                      .getDocuments(),
                  builder: (context, snapDetalhes) {
                    if (!snapDetalhes.hasData) {
                      return Container();
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Vencimentos Próximos",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Divider(),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapDetalhes
                                                .data.documents.length,
                                            itemBuilder: (_, index) {
                                              ProductDataRupturaValidade data =
                                                  ProductDataRupturaValidade
                                                      .fromDocument(snapDetalhes
                                                          .data
                                                          .documents[index]);

                                              if (data.validade !=
                                                  "00/00/0000") {
                                                return ListTile(
                                                  title: Text(
                                                    data.produto,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "QuickSandRegular"),
                                                  ),
                                                  trailing: Text(data.validade,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSandRegular")),
                                                );
                                              }
                                            })

                                        //Falta modificar a data de conclusão
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Em Ruptura",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Divider(),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapDetalhes
                                                .data.documents.length,
                                            itemBuilder: (_, index) {
                                              ProductDataRupturaValidade data =
                                                  ProductDataRupturaValidade
                                                      .fromDocument(snapDetalhes
                                                          .data
                                                          .documents[index]);

                                              if (data.ruptura != 0) {
                                                return ListTile(
                                                  title: Text(
                                                    data.produto,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "QuickSandRegular"),
                                                  ),
                                                  trailing: Text(
                                                      data.ruptura.toString() +
                                                          " UN",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSandRegular")),
                                                );
                                              }
                                            })

                                        //Falta modificar a data de conclusão
                                      ],
                                    ),
                                  ),
                                )),
                          )
                        ],
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: Firestore.instance
                      .collection("Empresas")
                      .document(data.empresaResponsavel)
                      .collection("pesquisasCriadas")
                      .document(data.id)
                      .collection("estoqueDeposito")
                      .getDocuments(),
                  builder: (context, snapDetalhes) {
                    if (!snapDetalhes.hasData) {
                      return Container();
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Estoques antes da reposição",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Divider(),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapDetalhes
                                                .data.documents.length,
                                            itemBuilder: (_, index) {
                                              estoqueDepositoData data =
                                                  estoqueDepositoData
                                                      .fromDocument(snapDetalhes
                                                          .data
                                                          .documents[index]);

                                              return ListTile(
                                                title: Text(
                                                  data.produto,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "QuickSandRegular"),
                                                ),
                                                trailing: Text(
                                                    data.antesReposicao
                                                            .toString() +
                                                        " UN",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "QuickSandRegular")),
                                              );
                                            })

                                        //Falta modificar a data de conclusão
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Estoques após reposição",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Divider(),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapDetalhes
                                                .data.documents.length,
                                            itemBuilder: (_, index) {
                                              estoqueDepositoData data =
                                                  estoqueDepositoData
                                                      .fromDocument(snapDetalhes
                                                          .data
                                                          .documents[index]);

                                              return ListTile(
                                                title: Text(
                                                  data.produto,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "QuickSandRegular"),
                                                ),
                                                trailing: Text(
                                                    data.aposReposicao
                                                            .toString() +
                                                        " UN",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "QuickSandRegular")),
                                              );
                                            })

                                        //Falta modificar a data de conclusão
                                      ],
                                    ),
                                  ),
                                )),
                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
