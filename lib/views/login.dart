import 'package:flutter/material.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/widgets/login_form.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), centerTitle: true,),
      body: Container(child: LoginForm(),),
      floatingActionButton: FloatingActionButton(
        child: Text("Sign Up", style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
        onPressed: () {Navigator.pushNamed(context, Routes.Signup);},
      ),
    );
  }
}

