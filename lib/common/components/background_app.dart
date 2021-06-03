import 'package:flutter/material.dart';

class BackgroundApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF796DEA), Color(0xFFCC73FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        color: Colors.blue,
      ),
      child: null /* add child content content here */,
    );
  }
}
