import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class TitleModel extends Model {
  String title = "Observação";

  void setTitle(String texto) {
    this.title = texto;
  }

  String getTitle() {
    return title;
  }
}
