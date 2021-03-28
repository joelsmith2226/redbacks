import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/widgets/login_form.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var signedIn = RedbacksFirebase().isSignedIn();
    if (signedIn != null && signedIn) {
      print('User is signed in! Reroute to home!');
      Navigator.pushReplacementNamed(context, Routes.Home);
    } else {
      print('User is currently signed out! Continue with login');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: LoginForm(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          Navigator.pushNamed(context, Routes.Signup);
        },
      ),
    );
  }
}
