import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/third_party_signin_button.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

final _formKeyName = GlobalKey<FormBuilderState>();
final _formKeyUser = GlobalKey<FormBuilderState>();

class _SignupFormState extends State<SignupForm> {
  String email;
  String teamName;
  String pwd;
  String conPwd;
  String name;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool hidePwd;
  bool hideConPwd;
  bool disabled;
  bool loading = false;

  @override
  void initState() {
    hidePwd = true;
    hideConPwd = true;
    disabled = true;
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
                textInputAction: TextInputAction.next,
              ),
            ),
            isPwd ? showHidePwd(name) : Container()
          ]),
    );
  }

  Widget BuildForm() {
    List<Widget> columnChildren = _columnChildrenWithTitle();
    if (disabled) {
      _addNameForm(columnChildren);
    } else {
      _insertNameSummary(columnChildren);
      _addThirdPartyButtons(columnChildren);
    }
    columnChildren.add(_submitButton());
    if (loading)
      columnChildren.add(CircularProgressIndicator());

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: columnChildren,
    );
  }

  List<Widget> _columnChildrenWithTitle() {
    List<Widget> columnChildren = [
      Container(
        child: Text(
            this.disabled ? "Enter Name Details" : "Choose Signup Method",
            style: TextStyle(fontSize: 20)),
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    ];
    return columnChildren;
  }

  void _addNameForm(List<Widget> columnChildren) {
    columnChildren.add(FormBuilder(
      key: _formKeyName,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SignupTextForm("firstName", "First Name *", false,
              keyboard: TextInputType.name),
          SignupTextForm("lastName", "Last Name *", false,
              keyboard: TextInputType.name),
          SignupTextForm("teamName", "Enter Team Name *", false,
              keyboard: TextInputType.name),
        ],
      ),
    ));
  }

  void _addThirdPartyButtons(List<Widget> columnChildren) {
    columnChildren.addAll([
      ThirdPartySigninButton(signUp: true, company: "Google"),
      ThirdPartySigninButton(signUp: true, company: "Facebook"),
      Platform.isIOS
          ? ThirdPartySigninButton(signUp: true, company: "Apple")
          : Container(),
      Container(child: Text("...Or signup with email & password")),
      FormBuilder(
        key: _formKeyUser,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SignupTextForm("email", "Enter Email", false,
                keyboard: TextInputType.emailAddress),
            SignupTextForm("pwd", "Enter Password", hidePwd,
                keyboard: TextInputType.visiblePassword),
            SignupTextForm("conPwd", "Confirm Password", hideConPwd,
                keyboard: TextInputType.visiblePassword),
          ],
        ),
      ),
    ]);
  }

  void _insertNameSummary(List<Widget> columnChildren) {
    columnChildren.insert(
      0,
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        margin: EdgeInsets.only(bottom: 30),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('${this.name} - ${this.teamName}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      alignment: Alignment.center,
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          this.disabled
              ? Container()
              : MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                      this.disabled = true;
                    });
                  },
                ),
          MaterialButton(
            color: Theme.of(context).accentColor,
            child: Text(
              this.disabled ? "Next" : "Submit",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (this.disabled &&
                  _formKeyName.currentState.saveAndValidate()) {
                setState(() {
                  this.name =
                      '${_formKeyName.currentState.value["firstName"]} ${_formKeyName.currentState.value["lastName"]}';
                  this.teamName = _formKeyName.currentState.value["teamName"];
                  this.disabled = false;

                  // Set user details
                  LoggedInUser user =
                      Provider.of<LoggedInUser>(context, listen: false);
                  user.signingUp = true;
                  user.teamName = this.teamName;
                  user.name = this.name;

                  // Dismiss keyboard
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus.unfocus();
                  }
                });
              } else {
                await _submitButtonFn();
              }
            },
          ),
        ],
      ),
    );
  }

  Future _submitButtonFn() async {
    _formKeyUser.currentState.save();
    this.email = _formKeyUser.currentState.value["email"];
    this.pwd = _formKeyUser.currentState.value["pwd"];
    this.conPwd = _formKeyUser.currentState.value["conPwd"];
    if (_formKeyUser.currentState.validate()) {
      setState(() {
        loading = true;
      });
      try {
        UserCredential userCredential =
            await Authentication().signUpUsingEmailAndPassword(email, pwd);
        registerUserOnFirebase(userCredential);

      } on FirebaseAuthException catch (e) {
        _errorHandling(e);
      } catch (e) {
        print(e);
      }
      setState(() {
        loading = false;
      });
    } else {
      print("validation failed");
    }
  }

  void registerUserOnFirebase(UserCredential userCredential) async {
    print("Successful User Registration for ${userCredential.user.email}.");
    Navigator.pushReplacementNamed(context, Routes.Loading);
  }

  void _errorHandling(FirebaseAuthException e) {
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
