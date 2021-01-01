import 'package:flutter/material.dart';

class ExibirImagem extends StatelessWidget {
  String url, descricao;

  ExibirImagem(this.url, this.descricao);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: descricao == "1"
              ? Column(children: [
                  Text(
                    "Aréa de Venda",
                    style: TextStyle(fontFamily: "QuickSandRegular"),
                  ),
                  Text(
                    "(antes da reposição)",
                    style: TextStyle(fontFamily: "QuickSandRegular"),
                  ),
                ])
              : descricao == "2"
                  ? Column(children: [
                      Text(
                        "Ponto Extra",
                        style: TextStyle(fontFamily: "QuickSandRegular"),
                      ),
                    ])
                  : Column(children: [
                      Text(
                        "Aréa de Venda",
                        style: TextStyle(fontFamily: "QuickSandRegular"),
                      ),
                      Text(
                        "(após a reposição)",
                        style: TextStyle(fontFamily: "QuickSandRegular"),
                      ),
                    ]),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Card(
              elevation: 10,
              child: Image.network(
                url,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ));
  }
}
