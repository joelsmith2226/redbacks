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
  bool hidePwd;
  bool hideConPwd;

  @override
  void initState() {
    hidePwd = true;
    hideConPwd = true;
    super.initState();
  }

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
      {TextInputType keyboard = TextInputType.text}) {
    var validators = [
      FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)
    ];

    bool isPwd = ["pwd", "conPwd"].contains(name);
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * (isPwd ? 0.52 : 0.65),
              child: FormBuilderTextField(
                name: name,
                textCapitalization: keyboard == TextInputType.name
                    ? TextCapitalization.words
                    : TextCapitalization.none,
                obscureText: pwd,
                decoration: InputDecoration(
                  labelText: label,
                ),
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose(validators),
                keyboardType: keyboard,
              ),
            ),
            isPwd ? showHidePwd(name) : Container()
          ]),
    );
  }

  Widget BuildForm() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SignupTextForm("firstName", "First Name", false,
                keyboard: TextInputType.name),
            SignupTextForm("lastName", "Last Name", false,
                keyboard: TextInputType.name),
            SignupTextForm("teamName", "Enter Team Name", false,
                keyboard: TextInputType.name),
            SignupTextForm("email", "Enter Email", false,
                keyboard: TextInputType.emailAddress),
            SignupTextForm("pwd", "Enter Password", hidePwd,
                keyboard: TextInputType.visiblePassword),
            SignupTextForm("conPwd", "Confirm Password", hideConPwd,
                keyboard: TextInputType.visiblePassword),
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

  Widget showHidePwd(String name) {
    bool showHide;
    showHide = name == 'pwd' ? hidePwd : hideConPwd;
    Function onPress = name == 'pwd'
        ? () => (setState(() => hidePwd = !hidePwd))
        : () => (setState(() => hideConPwd = !hideConPwd));
    return IconButton(
        icon: Icon(showHide ? Icons.visibility_off : Icons.visibility),
        onPressed: onPress);
  }
}
