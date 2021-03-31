import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/login_form.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoggedInUser user;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<LoggedInUser>(context);
    // Be sneaky and load players here
    if (user.playerDB == null){
      user.loadInCurrentPlayerDatabase();
    }

    if (user.isLoggedIn()){
      Navigator.pushReplacementNamed(context, Routes.Home);
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
