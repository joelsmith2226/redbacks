import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class ConfirmTransfersView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                // Transfer list

                // chip options
                // confirm
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "Confirm Transfers",
          style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
      persistentFooterButtons: [
        MaterialButton(
          child: Text("Back"),
          onPressed: () => Navigator.pop(context),
        ),
        _confirmButton(user, context)
      ],
    );
  }

  MaterialButton _confirmButton(LoggedInUser user, BuildContext context) {
    return MaterialButton(
      child: Text("Confirm"),
      onPressed: () {
        String route = user.signingUp ? Routes.Login : Routes.Home;
        user.confirmTransfersButtonPressed();
        if (route == Routes.Home) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.popUntil(context, (popRoute) => popRoute.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("All signed up! Please login with your details!")));
        }
        return;
      },
    );
  }
}
