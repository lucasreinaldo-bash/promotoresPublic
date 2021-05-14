import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void configFCM(BuildContext context) {
  if (Platform.isIOS) {
    final fcm = FirebaseMessaging();

    fcm.requestNotificationPermissions(
        const IosNotificationSettings(provisional: true));

    fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
      },
      onMessage: (Map<String, dynamic> message) async {
        showNotification(message['notification']['title'] as String,
            message['notification']['body'] as String, context);
      },
    );
  } else {
    final fcm = FirebaseMessaging();

    fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
      },
      onMessage: (Map<String, dynamic> message) async {
        print("Recebi alguma mensagem");
        showNotification(message['notification']['title'] as String,
            message['notification']['body'] as String, context);
      },
    );
  }
}

void showNotification(String title, String message, BuildContext context) {
  Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.deepPurpleAccent,
      duration: const Duration(seconds: 6),
      icon: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset("assets/logo.png"),
            )),
      )).show(context);
}
