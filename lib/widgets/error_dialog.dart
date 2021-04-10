import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  String body;
  String btn1 = "OK";
  String btn2;
  AlertDialog alert;
  BuildContext context;
  Function fn1;
  Function fn2;

  ErrorDialog(
      {this.body, this.fn1, this.fn2, this.btn1, this.btn2, this.context});

  @override
  Widget build(BuildContext context) {
    if (this.context == null) this.context = context;
    if (btn1 == "OK" && btn2 == null && fn1 == null) {
      return defaultAlert();
    }
    return AlertDialog(
      title: Text(
        'Error Occurred',
        textAlign: TextAlign.center,
      ),
      content: Text(this.body),
      actions: [
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: fn1 == null
              ? () {
                  Navigator.pop(context);
                }
              : () {
                  fn1();
                },
          child: Text("${btn1}"),
        ),
        btn2 != null
            ? MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: fn2 == null
                    ? () {
                        Navigator.pop(context);
                      }
                    : () {
                        fn2();
                      },
                child: Text("${btn2}"),
              )
            : Container(),
      ],
    );
  }

  AlertDialog defaultAlert() {
    return AlertDialog(
      title: Text(
        'Error Occurred',
        textAlign: TextAlign.center,
      ),
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
      context: this.context,
      builder: (BuildContext context) {
        return this.alert;
      },
    );
  }
}
