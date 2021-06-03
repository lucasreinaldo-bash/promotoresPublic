import 'package:flutter/material.dart';

class BuildIndicatorBefore extends ChangeNotifier {
  BuildIndicatorBefore(this._pageController);

  final PageController _pageController;

  int page = 0;
  void setPage(int value) {
    if (value == page) return;
    page = value;

    _pageController.jumpToPage(value);
    debugPrint(value.toString());
  }
}