import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';

class ProdutosTile extends StatefulWidget {
  ProductData data;

  ProdutosTile(this.data);
  @override
  _ProdutosTileState createState() => _ProdutosTileState(this.data);
}

class _ProdutosTileState extends State<ProdutosTile> {
  ProductData data;

  _ProdutosTileState(this.data);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          trailing: Card(
            color: Color(0xFF4FCEB6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Concluída",
                style: TextStyle(
                    color: Colors.white, fontFamily: "QuickSandRegular"),
              ),
            ),
          ),
          title: Text(
            "" + data.nomeProduto,
            style: TextStyle(
                fontFamily: "QuickSand",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.start,
          ),
          subtitle: Text(
            "Toque para editar a pesquisa",
            style: TextStyle(
                fontFamily: "QuickSandRegular",
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
            textAlign: TextAlign.start,
          ),
        ));
  }
}
