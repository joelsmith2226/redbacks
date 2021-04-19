import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

final _formKey = GlobalKey<FormBuilderState>();

class _SignupFormState extends State<SignupForm> {
  String email;
  String teamName;
  String pwd;
  String conPwd;
  String name;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: BuildForm(),
      ),
    );
  }

  Widget SignupTextForm(String name, String label, bool pwd,
      {String initial = ""}) {
    var validators = [
      FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)
    ];
    // if (name == "conPwd") {
    //   validators.add(FormBuilderValidators.equal(context, this.pwd, errorText: "Passwords do not match"));
    // }
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: FormBuilderTextField(
        initialValue: initial,
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

  Widget BuildForm() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SignupTextForm("firstName", "First Name", false, initial: "Joel"),
            SignupTextForm("lastName", "Last Name", false, initial: "Smith"),
            SignupTextForm("teamName", "Enter Team Name", false,
                initial: "LADmin"),
            SignupTextForm("email", "Enter Email", false,
                initial: "joel.smith2226@gmail.com"),
            SignupTextForm("pwd", "Enter Password", true, initial: "password"),
            SignupTextForm("conPwd", "Confirm Password", true,
                initial: "password"),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: MaterialButton(
          color: Theme.of(context).accentColor,
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _formKey.currentState.save();
            this.name =
                '${_formKey.currentState.value["firstName"]} ${_formKey.currentState.value["lastName"]}';
            this.teamName = _formKey.currentState.value["teamName"];
            this.email = _formKey.currentState.value["email"];
            this.pwd = _formKey.currentState.value["pwd"];
            this.conPwd = _formKey.currentState.value["conPwd"];
            if (_formKey.currentState.validate()) {
              registerUserOnFirebase();
            } else {
              print("validation failed");
            }
          },
        ),
      ),
      SizedBox(width: 20),
    ]);
  }

  void registerUserOnFirebase() async {
    try {
      UserCredential userCredential = await this
          .auth
          .createUserWithEmailAndPassword(
              email: this.email, password: this.conPwd);
      print("Successful User Registration for ${userCredential.user.email}.");
      // Set user to signup mode
      LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
      user.signingUp = true;
      user.teamName = this.teamName;
      user.name = this.name;
      Navigator.pushReplacementNamed(context, Routes.Loading);
    } on FirebaseAuthException catch (e) {
      var message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = "Something else went wrong: ${e}";
      }
      var sb = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(sb);
    } catch (e) {
      print(e);
    }
  }
}
