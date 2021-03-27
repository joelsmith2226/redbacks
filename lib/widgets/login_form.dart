import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}
final _formKey = GlobalKey<FormBuilderState>();

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    Widget email = LoginTextForm("email", "Enter Email", false);
    Widget pwd = LoginTextForm("pwd", "Enter password", true);
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
              'https://www.redbacksoccer.com.au/wp-content/uploads/2019/02/CRFC-Logo-1.png'),
          FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                email,
                pwd,
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
                print("Login pressed");
                attemptLoginOnFirebase();
              }),
        ],
      ),
    );
  }

  Widget LoginTextForm(String name, String label, bool pwd) {
    var validators = [FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)];
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

  void attemptLoginOnFirebase() async{
    try {
      print("attempting user find?");
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _formKey.currentState.value["email"],
          password:  _formKey.currentState.value["pwd"]
      );
      print("Successful User Login for ${userCredential.user.email}");
      Navigator.pushReplacementNamed(context, "/home");
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
}
