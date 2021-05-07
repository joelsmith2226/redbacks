import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/widgets/third_party_signin_button.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

final _formKeyUser = GlobalKey<FormBuilderState>();

class _SignupFormState extends State<SignupForm> {
  String email;
  String pwd;
  String conPwd;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool hidePwd;
  bool hideConPwd;
  bool loading = false;

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
      {TextInputType keyboard = TextInputType.text, String initial = ""}) {
    var validators = [
      FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)
    ];

    bool isPwd = ["pwd", "conPwd"].contains(name);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: FormBuilderTextField(
            initialValue: initial,
            name: name,
            textCapitalization: keyboard == TextInputType.text
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
    _addThirdPartyButtons(columnChildren);

    columnChildren.add(_submitButton());
    if (loading) columnChildren.add(CircularProgressIndicator());

    return Container(
      height: MediaQuery.of(context).size.height * 1.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: columnChildren
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(8),
                child: e,
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _columnChildrenWithTitle() {
    List<Widget> columnChildren = [
      Container(
        child: Text("Choose Signup Method", style: TextStyle(fontSize: 20)),
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    ];
    return columnChildren;
  }

  void _addThirdPartyButtons(List<Widget> columnChildren) {
    columnChildren.addAll([
      ThirdPartySigninButton(
        signUp: true,
        company: "Google",
        successCallback: () => setState(() {
          Navigator.pushReplacementNamed(context, Routes.NameSignup);
        }),
      ),
      ThirdPartySigninButton(
          signUp: true,
          company: "Facebook",
          successCallback: () => setState(() {
                Navigator.pushReplacementNamed(context, Routes.NameSignup);
              })),
      Platform.isIOS
          ? ThirdPartySigninButton(
              signUp: true,
              company: "Apple",
              successCallback: () => setState(() {
                    Navigator.pushReplacementNamed(context, Routes.NameSignup);
                  }))
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

  Widget _submitButton() {
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          "Next",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () async {
          await _submitButtonFn();
        },
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
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
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
    Navigator.pushReplacementNamed(context, Routes.NameSignup);
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
    return Positioned.directional(
        textDirection: TextDirection.ltr,
        end: 0,
        child: IconButton(
            icon: Icon(showHide ? Icons.visibility_off : Icons.visibility),
            onPressed: onPress));
  }
}
