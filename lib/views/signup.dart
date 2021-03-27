import 'package:flutter/material.dart';
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
    );
  }
}
