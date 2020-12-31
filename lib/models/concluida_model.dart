import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class ConcluidaModel extends Model {
  String result = "não";

  void setResult(String texto) {
    this.result = texto;
  }

  String getResult() {
    return result;
  }
}
