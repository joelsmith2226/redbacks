import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/error_dialog.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loginOnce = true;

  @override
  Widget build(BuildContext context) {
    _loadUser();

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
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    // Timer(Duration(seconds: 1), () {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text('Bear with me for a sec, taking longer than normal')));
    //   Timer(Duration(seconds: 1), () {
    //     ErrorDialog errorDialog = ErrorDialog(
    //         body: "Loading took too long, retry?",
    //         context: context,
    //         btn1: "Retry",
    //         btn2: "Wait",
    //         fn1: () => setState((){}));
    //     errorDialog.displayCard();
    //   });
    // });
    user.signingUp ? _initialiseSignup() : _initialiseLogin();
  }

  void _initialiseSignup() async {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    await user.initialiseUserSignup(user.teamName);
    Navigator.pushReplacementNamed(context, Routes.ChooseTeam);
  }

  void _initialiseLogin() async {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    if (this.loginOnce) {
      this.loginOnce = false;
      await user.loadInPlayerAndGWHistoryDB(); // ensures player DB loaded before init
      await user.initialiseUserLogin().whenComplete(() {
        print("Finished Loading, user should be fully initialised");
        Navigator.pushReplacementNamed(context, Routes.Home);
      }).onError((error, stackTrace) {
        ErrorDialog err = ErrorDialog(body: "Error in loading user");
        err.displayCard();
        return;
      });
    }
  }
}
