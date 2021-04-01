import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/widgets/signup_form.dart';

class SignupView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Signup", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SignupForm(),
      ),
    );
  }
}
