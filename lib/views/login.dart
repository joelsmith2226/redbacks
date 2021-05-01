import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/form_widgets.dart';
import 'package:redbacks/widgets/login_form.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoggedInUser user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => exitDialog(),
      child: Scaffold(
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
          LoginForm(),
          Positioned(
            left: 10,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.purple.withAlpha(150),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Forgot\nMy\nPassword",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onPressed: () {
                forgotPwdDialog();
              },
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
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
        ),
      ),
    );
  }

  Future<bool> exitDialog() async {
    bool result = await showDialog<bool>(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
                Text("Are you sure you want to exit Redbacks Fantasy League?"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  Navigator.pop(context, true);
                  SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'); // exit app
                },
                child: Text('Exit'),
              ),
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () async {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
    return result;
  }

  void forgotPwdDialog() async {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          TextEditingController _controller = new TextEditingController();
          return AlertDialog(
            title: Text("Forgot your password?"),
            content: FormWidgets().TextForm("email", "Enter your email", this.context, controller: _controller),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  String email = _controller.value.text;
                  Authentication().sendForgotPwdEmail(email);
                  Navigator.pop(context, true);// exit app
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Reset password sent to $email")));
                },
                child: Text('OK'),
              ),
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () async {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }
}
