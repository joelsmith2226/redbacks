import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/widgets/name_signup_form.dart';

class NameSignupView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Signup", style: GoogleFonts.merriweatherSans()),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: []
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: NameSignupForm(),
          ),
        ),
      ),
    );
  }
}
