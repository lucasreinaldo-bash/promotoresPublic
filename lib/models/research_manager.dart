import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../menu_principal/datas/pesquisaData.dart';
import '../menu_principal/datas/pesquisaData.dart';
import '../menu_principal/datas/pesquisaData.dart';

class ResearchManager extends ChangeNotifier {
  PesquisaData data;
  ResearchManager({this.data});

  String _titleScreen = "Área de Venda";
  bool _selectedResearch = false;
  get selectedResearch => _selectedResearch;

  set selectedResearch(bool value){
    _selectedResearch = value;
    notifyListeners();
  }

  set titleScreen(String title) {
    _titleScreen = title;
    print(_titleScreen);
    notifyListeners();
  }

  String get titleScreen => _titleScreen;

  void setResearch(PesquisaData data) {
    this.data = data;
    notifyListeners();
  }
}
