import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nice_button/NiceButton.dart';

class SelecaoPerfil extends StatelessWidget {
  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: new Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 1, bottom: 1),
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                )),
          ),
          SizedBox(
            height: 60,
          ),
          NiceButton(
            radius: 40,
            padding: const EdgeInsets.all(15),
            text: "Sou Promotor",
            gradientColors: [secondColor, firstColor],
            onPressed: () {
              Navigator.pushNamed(context, "/loginPromotor");
            },
          ),
          SizedBox(
            height: 20,
          ),
          NiceButton(
            radius: 40,
            padding: const EdgeInsets.all(15),
            text: "Sou Empresa",
            gradientColors: [secondColor, firstColor],
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
          )
        ],
      ),
    );
  }
}
