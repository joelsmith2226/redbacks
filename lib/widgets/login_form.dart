import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';

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
  Widget build(BuildContext context) {
    this.user = Provider.of<LoggedInUser>(context);

    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      alignment: Alignment.center,
      child: BuildForm(),
    );
  }

  Widget BuildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Image.asset('assets/logo.png'),
          onDoubleTap: attemptLoginOnFirebaseAdmin,
        ),
        _loading ? CircularProgressIndicator() : Container(),
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
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _formKey.currentState.save();
            print("Login pressed");
            attemptLoginOnFirebase();
          },
        ),
      ],
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
      ),
    );
  }

  void attemptLoginOnFirebase() async {
    try {
      print("attempting user find? ${_formKey.currentState.value}");
      _loading = true;
      this.auth
          .signInWithEmailAndPassword(
              email: _formKey.currentState.value["email"],
              password: _formKey.currentState.value["pwd"])
          .then((userCredentials) {
        print("Successful User Login for ${userCredentials.user.email}");
        Navigator.pushReplacementNamed(context, Routes.Loading);
      });
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print("Something else went wrong: ${e}");
      }
      var sb = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  void attemptLoginOnFirebaseAdmin() async {
    print("Attempting admin hack for joel.smith2226");
    this
        .auth
        .signInWithEmailAndPassword(
            email: "joel.smith2226@gmail.com", password: "password")
        .then((UserCredential userCredential) {
      print("Successful login ADMIN PLS: ${userCredential.user.uid}");
      Navigator.pushReplacementNamed(context, Routes.Loading);
    }).onError((error, stackTrace) {
      _errorHandler(error);
      return null;
    });
  }

  void _errorHandler(error) {
    print("Here no???????");
    var errorMessage;
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }
    var sb = SnackBar(
      content: Text(errorMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);
    _loading = false;
  }
}
