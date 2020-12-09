import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'datas/pesquisaData.dart';

class DetalhamentoPesquisa extends StatefulWidget {
  PesquisaData data;

  DetalhamentoPesquisa(this.data);
  @override
  _DetalhamentoPesquisaState createState() =>
      _DetalhamentoPesquisaState(this.data);
}

class _DetalhamentoPesquisaState extends State<DetalhamentoPesquisa> {
  PesquisaData data;

  _DetalhamentoPesquisaState(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Detalhamento Pesquisa"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Card(
            child: Container(
              height: 120,
              width: 450,
              child: InkWell(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: Transform.scale(
                                scale: 0.8,
                                child: Image.asset("assets/cam.png")),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Fotos",
                          style: TextStyle(fontFamily: "QuickSand"),
                        )
                      ],
                    )),
              ),
            ),
          ),
          Card(
              child: Container(
            height: 400,
            width: 400,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detalhes",
                    style: TextStyle(fontFamily: "QuickSand", fontSize: 16),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Nome da Loja: ",
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black87),
                      ),
                      Text(
                        data.nomeLoja,
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black38),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Nome da Rede: ",
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black87),
                      ),
                      Text(
                        data.nomeRede,
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black38),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Status: ",
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black87),
                      ),
                      Text(
                        data.status,
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black38),
                      ),
                    ],
                  ),

                  //Falta modificar a data de conclusão
                  Row(
                    children: [
                      Text(
                        "Data de Conclusão: ",
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black87),
                      ),
                      Text(
                        data.dataFinal,
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black38),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Linha de Produto: ",
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black87),
                      ),
                      Text(
                        data.linhaProduto,
                        style: TextStyle(
                            fontFamily: "QuickSand", color: Colors.black38),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ))
        ],
      )),
    );
  }
}
