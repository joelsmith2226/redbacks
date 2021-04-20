import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/initial_data.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/globals/rFirebase/firebasePlayers.dart';
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
          calcTotalCurrPtsPlayersBtn(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              setCurrentGW(forms, user, context),
              deadlineBtn(context, user)
            ],
          ),
          initPlayerDBBtn(),
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

  Widget initPlayerDBBtn() {
    return MaterialButton(
      child: Text(
        "Reinitialise Player DB",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.black,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Reset player DB?'),
                content: Text("Are you sure you want to reinitialise playerDB? Go delete collection first or youll have double ups!"),
                actions: [
                  MaterialButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {
                      InitialData();
                      // FirebasePlayers().repushAllGWs(); CEEBS
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Players reset'),
                      ));
                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  ),
                  MaterialButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                ],
              );
            });
      },
    );
  }

  Widget calcTotalCurrPtsPlayersBtn() {
    return MaterialButton(
        child: Text(
          "Calculate Player Pts",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
        onPressed: () {
          FirebasePlayers().calculatePlayerGlobalPts();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Players Pts totalled!')));
        });
  }
}
