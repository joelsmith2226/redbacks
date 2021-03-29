import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:redbacks/globals/router.dart';

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
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      alignment: Alignment.center,
      child: BuildForm(),
    );
  }

  Widget SignupTextForm(String name, String label, bool pwd) {
    var validators = [FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)];
    // if (name == "conPwd") {
    //   validators.add(FormBuilderValidators.equal(context, this.pwd, errorText: "Passwords do not match"));
    // }
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

  Widget BuildForm() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
      FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SignupTextForm("teamName", "Enter Team Name", false),
            SignupTextForm("email", "Enter Email", false),
            SignupTextForm("pwd", "Enter Password", true),
            SignupTextForm("conPwd", "Confirm Password", true),
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
            this.teamName = _formKey.currentState.value["teamName"];
            this.email = _formKey.currentState.value["email"];
            this.pwd = _formKey.currentState.value["pwd"];
            this.conPwd = _formKey.currentState.value["conPwd"];
            print(this.pwd + " " +  this.conPwd);
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
      UserCredential userCredential = await this.auth.createUserWithEmailAndPassword(
          email: this.email,
          password: this.conPwd
      );
      print("Successful User Registration for ${userCredential.user.email}. Heading to team selection");
      Navigator.pushReplacementNamed(context, Routes.ChooseTeam);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print("Something else went wrong: ${e}");
      }
    } catch (e) {
      print(e);
    }
  }
}
