import 'package:flutter/material.dart';

class backgroundContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/fundo_colors.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: null /* add child content content here */,
    );
  }
}

//Metodo para setar os buttons
Widget _indicator(bool isActive) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    height: 8.0,
    width: isActive ? 24.0 : 16.0,
    decoration: BoxDecoration(
      color: isActive ? Colors.white : Colors.purple,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
}
