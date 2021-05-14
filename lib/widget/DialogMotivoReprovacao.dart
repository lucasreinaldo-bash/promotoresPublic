import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';

class DialogMotivoReprovacao extends StatefulWidget {
  PesquisaData data;

  DialogMotivoReprovacao(this.data);
  @override
  _DialogMotivoReprovacaoState createState() =>
      _DialogMotivoReprovacaoState(this.data);
}

class _DialogMotivoReprovacaoState extends State<DialogMotivoReprovacao> {
  final _comentario = TextEditingController();
  PesquisaData data;

  _DialogMotivoReprovacaoState(this.data);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _comentario.text = data.observacao;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                maxLines: 10,
                enabled: false,
                controller: _comentario,
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 13.0,
                    color: Colors.black),
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.info),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Motivo da Reprovação",
                  hintText: "Sua pesquisa foi reprovada pelo seguinte motivo:",
                  hintStyle:
                      TextStyle(fontFamily: "QuickSandRegular", fontSize: 12.0),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: _comentario.text.length > 1
                      ? () async {
                          Navigator.pop(context);
                        }
                      : null,
                  color: Color(0xFFF26868),
                  textColor: Colors.white,
                  child: Text("Fechar",
                      style: TextStyle(
                          fontSize: 14, fontFamily: "QuickSandRegular")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
