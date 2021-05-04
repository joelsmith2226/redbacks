import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class ThirdPartySigninButton extends StatefulWidget {
  bool signUp = false;
  String company = "Google";
  bool disabled = false;

  ThirdPartySigninButton(
      {this.signUp = false, this.company = "Google", this.disabled = false});

  @override
  _ThirdPartySigninButtonState createState() => _ThirdPartySigninButtonState();
}

class _ThirdPartySigninButtonState extends State<ThirdPartySigninButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? CircularProgressIndicator()
        : Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.04,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(_getColor()),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                if (widget.disabled) return;
                setState(() {
                  _isSigningIn = true;
                });

                UserCredential user = await thirdPartyAuthLogin(context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  // Successful third party login!
                  LoggedInUser userProvider = Provider.of<LoggedInUser>(context, listen: false);
                  userProvider.signingUp = widget.signUp;
                  Navigator.pushReplacementNamed(context, Routes.Loading);
                }
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image(
                        image: AssetImage(_getImageString()),
                        height: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '${widget.signUp ? "Sign up" : "Login"} with ${widget.company}',
                        style: TextStyle(
                            fontSize: 14,
                            color: widget.disabled
                                ? Colors.black.withAlpha(100)
                                : (widget.company == "Google"
                                    ? Colors.black
                                    : Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Future<UserCredential> thirdPartyAuthLogin(BuildContext context) async {
    switch (widget.company) {
      case "Google":
        UserCredential user =
            await Authentication().signInWithGoogle(context: context);
        return user;
      case "Facebook":
        UserCredential user =
            await Authentication().signInWithFacebook(context: context);
        return user;
      case "Apple":
        UserCredential user =
            await Authentication().signInWithApple(context: context);
        return user;
      default:
        return null;
    }
  }

  String _getImageString() {
    switch (widget.company) {
      case "Google":
        return "assets/google_logo.png";
      case "Facebook":
        return "assets/facebook_logo.png";
      case "Apple":
        return "assets/apple_logo.png";
      default:
        return "assets/google_logo.png";
    }
  }

  Color _getColor() {
    if (widget.disabled) {
      return Colors.grey.withAlpha(100);
    }
    switch (widget.company) {
      case "Google":
        return Colors.white;
      case "Facebook":
        return Colors.blue;
      case "Apple":
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}
