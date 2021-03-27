import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/widgets/login_form.dart';

class LoginView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out! Continue with login');
      } else {
        print('User is signed in! Reroute to home!');
        Navigator.pushReplacementNamed(context, Routes.Home);
      }
    });

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

