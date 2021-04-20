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
  void initState() {
    _loadUser();
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
      Navigator.pushReplacementNamed(context, Routes.Home);
    }
  }
}
