import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    Widget email = LoginTextForm("Enter Email", false);
    Widget pwd = LoginTextForm("Enter password", true);
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
              'https://www.redbacksoccer.com.au/wp-content/uploads/2019/02/CRFC-Logo-1.png'),
          email,
          pwd,
          SizedBox(
            height: 100,
          ),
          MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
              }),
        ],
      ),
    );
  }

  Widget LoginTextForm(String hint, bool pwd) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextField(
        obscureText: pwd,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}
