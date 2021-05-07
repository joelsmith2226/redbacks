import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/form_widgets.dart';

class UserView extends StatefulWidget {
  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(30),
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  userDetailRow("Team\nName", user.teamName),
                  userDetailRow("Overall\nRank", '${user.overallRank()}'),
                  userDetailRow("Total\nPoints", '${user.totalPts}'),
                  userDetailRow("Chips\nRemaining", user.chipsRemaining()),
                  userDetailRow("Chips\nUsed", user.chipsUsed()),
                  userDetailRow("Email", user.email ?? "-"),
                ],
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "${user.name}",
          style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget userDetailRow(String key, String value) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Text(key,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.left,
          ),
        ),
        key == "Email" && value == '-'
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: MaterialButton(
                  child: Text("Update\nEmail?"),
                  color: Theme.of(context).accentColor,
                  onPressed: () => _linkEmailDialog(),
                ),
              )
            : Container(),
      ]),
    );
  }


  void _linkEmailDialog() async {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          TextEditingController _controller = new TextEditingController();
          return AlertDialog(
            title: Text("Update Email"),
            content: FormWidgets().TextForm(
                "email", "Enter your email", this.context,
                controller: _controller),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () async {
                  String email = _controller.value.text;
                  try {
                    await Authentication().linkEmailToAccount(email);
                    Navigator.pop(context, true); // exit app
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Updated email: $email")));
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${e}")));
                  }
                },
                child: Text('OK'),
              ),
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () async {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }
}
