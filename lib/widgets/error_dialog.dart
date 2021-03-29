import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/player_list.dart';

class ErrorDialog {
  String body;
  AlertDialog alert;
  BuildContext context;

  ErrorDialog({this.body, this.context}) {
    this.alert = AlertDialog(
      title: Text('Error Occurred', textAlign: TextAlign.center,),
      content: Text(this.body),
      actions: [
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  void displayCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this.alert;
      },
    );
  }
}
