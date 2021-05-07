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
  bool cancelLoading = false;

  @override
  void initState() {
    _loadUser();
    _setTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFEB6BE),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.asset("assets/spider.png")),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cancelLoading ? Container() : CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
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
          .loadInGlobalDBCollections(); // ensures player DB loaded before init
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
          .loadInGlobalDBCollections(); // ensures player DB loaded before init
      String result = await user.initialiseUserLogin();
      print("result: ${result}");
      if (result == "") {
        print("Finished Loading, user should be fully initialised");
        t.cancel();
        Navigator.pushReplacementNamed(context, Routes.Home);
      } else {
        t.cancel();
        setState(() {
          cancelLoading = true;
        });
        _areYouANewUserDialog();
      }
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

  void _areYouANewUserDialog() {
      showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("New user"),
            content: Text(
                "Hi there!\n\nAre you a new user? We can't seem to find a team"
                    "\n\nPress Sign Up below to create a new team or return back to the login screen"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, Routes.Login);
                },
                child: Text('Back to Login'),
              ),
              FloatingActionButton(
                heroTag: "signUpPopUp",
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.Login);
                  Navigator.pushNamed(context, Routes.NameSignup);
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Sign\nup",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
    );
  }
}
