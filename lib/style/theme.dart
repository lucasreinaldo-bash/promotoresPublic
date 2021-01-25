import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFFFFFFF);
  static const Color loginGradientEnd = const Color(0xFFFFFFFF);

  //Cores utilizadas na screen "Responder Pesquisa"
  static const Color colorCard = const Color(0xFF365BE5);
  static const Color colorBackground = const Color(0xFF365BE5);

  static LinearGradient primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
