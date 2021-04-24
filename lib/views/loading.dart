import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loginOnce = true;
  Timer t;

  @override
  void initState() {
    _loadUser();
    _setTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
          child: CircularProgressIndicator()),
      appBar: AppBar(
        title: Text(
          "Loading",
          style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
    );
  }

  void _loadUser() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    user.signingUp ? _initialiseSignup() : _initialiseLogin();
  }

  void _initialiseSignup() async {
    if (this.loginOnce) {
      this.loginOnce = false;
      LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
      await user
          .loadInPlayerAndGWHistoryDB(); // ensures player DB loaded before init
      await user.initialiseUserSignup();
      t.cancel();
      Navigator.pushReplacementNamed(context, Routes.ChooseTeam);
    }
  }

  void _initialiseLogin() async {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    if (this.loginOnce) {
      this.loginOnce = false;
      await user
          .loadInPlayerAndGWHistoryDB(); // ensures player DB loaded before init
      await user.initialiseUserLogin();
      print("Finished Loading, user should be fully initialised");
      t.cancel();
      Navigator.pushReplacementNamed(context, Routes.Home);
    }
  }

  void _setTimer() {
    t = Timer(
      Duration(seconds: 10),
          () => showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                "Login taking longer than usual. Return to login screen and retry or wait here?"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Wait'),
              ),
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, Routes.Login);
                  t.cancel();
                },
                child: Text('Return to Login'),
              )
            ],
          );
        },
      ),
    );
  }
}
