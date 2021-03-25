import 'package:flutter/material.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/widgets/signup_form.dart';

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"), centerTitle: true,
      ),
      body: Container(
        child: SignupForm(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Submit",
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
