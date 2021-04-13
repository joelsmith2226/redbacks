import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/form_widgets.dart';

class AdminActions extends StatefulWidget {
  @override
  _AdminActionsState createState() => _AdminActionsState();
}

class _AdminActionsState extends State<AdminActions> {
  int _currGW;

  @override
  void initState() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    _currGW = user.currGW;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FormWidgets forms = FormWidgets();
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              setCurrentGW(forms, user, context),
              deadlineBtn(context, user)
            ],
          )
        ],
      ),
    );
  }

  Widget deadlineBtn(context, LoggedInUser user) {
    return MaterialButton(
        child: Text(
          "Deadline for curr gw",
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          // Push teams, create new GW history collections
          FirebaseCore().deadlineButton(user.currGW);
          user.currGW++;
          // Shift curr gw forward
          FirebaseCore().pushAdminInfo(user);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("DEADLINE ACTIVATED: new curr gw ${user.currGW}"),
          ));
          setState(() {});
        });
  }

  Widget setCurrentGW(
      FormWidgets forms, LoggedInUser user, BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        forms.NumberForm(
          user.currGW,
          "curr-gw",
          'Current Gameweek',
          onChanged: (val) => setState(() {
            _currGW = val;
          }),
        ),
        MaterialButton(
            child: Text(
              "Set Curr GW",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              user.currGW = _currGW;
              FirebaseCore().pushAdminInfo(user);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("New active currGW: ${user.currGW}"),
              ));
            })
      ]),
    );
  }
}
