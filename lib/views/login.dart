import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/login_form.dart';
import 'package:redbacks/widgets/patch_mode.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoggedInUser user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loadedAdmin;
  bool _patching = false;

  @override
  void initState() {
    _loadedAdmin = false;
    this.user = Provider.of<LoggedInUser>(context, listen: false);
    this.user.getAdminInfo().then(
          (_) => setState(
            () {
              _loadedAdmin = true;
              _patching = user.patchMode == null ? false : user.patchMode;
            },
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<LoggedInUser>(context);
    // Be sneaky and load players here
    if (user.playerDB == null) {
      user.loadInPlayerAndGWHistoryDB();
    }

    // For persistent logins
    if (_loadedAdmin)
      isLoggedIn().then((bool isSignedIn) => isSignedIn
          ? SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, Routes.Loading);
            })
          : null);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
        actions: [],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        _loadedAdmin && _patching ? PatchMode() : LoginForm(),
      ]),
      floatingActionButton: !_patching
          ? FloatingActionButton(
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
              onPressed: () {
                Navigator.pushNamed(context, Routes.Signup);
              },
            )
          : Container(),
    );
  }

  Future<bool> isLoggedIn() async {
    var isSignedIn = Authentication().isLoggedIn();
    if (isSignedIn == null) {
      return false;
    }
    return isSignedIn && !user.signingUp;
  }
}
