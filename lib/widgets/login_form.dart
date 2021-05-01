import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/third_party_signin_button.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormBuilderState>();
  LoggedInUser user;
  bool _loading = false;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<LoggedInUser>(context);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          alignment: Alignment.center,
          child: BuildForm(),
        ));
  }

  Widget BuildForm() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: Image.asset(
                'assets/spider.png',
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
            Image.asset(
              'assets/title.png',
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            SizedBox(height: 20),
            ThirdPartySigninButton(company: "Google"),
            ThirdPartySigninButton(company: "Facebook"),
            Platform.isIOS
                ? ThirdPartySigninButton(company: "Apple")
                : Container(),
            Container(
              child: Text("...Or login with email & password"),
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  LoginTextForm("email", "Enter Email", false),
                  LoginTextForm("pwd", "Enter password", true),
                ],
              ),
            ),
            MaterialButton(
              color: Theme.of(context).accentColor,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              onPressed: () {
                _formKey.currentState.save();
                attemptLoginOnFirebase();
                user.signingUp = false; // you shouldn't be signing up if you are here
              },
            ),
            _loading ? CircularProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }

  Widget LoginTextForm(String name, String label, bool pwd) {
    var validators = [
      FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)
    ];
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: FormBuilderTextField(
        name: name,
        obscureText: pwd,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: FormBuilderValidators.compose(validators),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  void attemptLoginOnFirebase() async {
    try {
      print("attempting user find? ${_formKey.currentState.value}");
      setState(() {
        _loading = true;
      });
      String email = _formKey.currentState.value["email"];
      String pwd = _formKey.currentState.value["pwd"];
      UserCredential userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      if (userCredentials != null)
        Navigator.pushReplacementNamed(context, Routes.Loading);
      else {
        _errorHandler("ERROR_USER_NOT_FOUND");
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      _errorHandler(e);
      setState(() {
        _loading = false;
      });
    }
  }

  void _errorHandler(error) {
    var errorMessage;
    print(error.code);
    switch (error.code) {
      case "invalid-email":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "wrong-password":
        errorMessage = "Your password is wrong";
        break;
      case "user-not-found":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "user-disabled":
        errorMessage = "User with this email has been disabled.";
        break;
      case "too-many-requests":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "operation-not-allowed":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage =
            "An undefined Error happened. Most likely bad connection to database, please check your internet connection. If problem persists contact developer${error}";
    }
    var sb = SnackBar(
      content: Text(errorMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);
    _loading = false;
  }
}
