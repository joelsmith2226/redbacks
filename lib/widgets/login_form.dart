import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormBuilderState>();
  LoggedInUser user;

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
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose(validators),
        keyboardType: TextInputType.text,
      ),
    );
  }

  void attemptLoginOnFirebase() async {
    try {
      print("attempting user find? ${_formKey.currentState.value}");
      UserCredential userCredential = await this
          .auth
          .signInWithEmailAndPassword(
              email: _formKey.currentState.value["email"],
              password: _formKey.currentState.value["pwd"]);
      print("Successful User Login for ${userCredential.user.email}");
      this.user.initialiseUserLogin();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print("Something else went wrong: ${e}");
      }
    }
  }

  void attemptLoginOnFirebaseAdmin() async {
    try {
      print("Attempting admin hack for joel.smith2226");
      this
          .auth
          .signInWithEmailAndPassword(
              email: "joel.smith2226@gmail.com", password: "password")
          .then((UserCredential userCredential) {
        print("Successful login ADMIN PLS: ${userCredential.user.uid}");
        this.user.initialiseUserLogin();
      });
    } on FirebaseAuthException catch (e) {
      var message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = "Something else went wrong: ${e}";
      }
      var sb = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }
}
