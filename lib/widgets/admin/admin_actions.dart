import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/initial_data.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/globals/rFirebase/firebasePlayers.dart';
import 'package:redbacks/globals/rFirebase/firebaseUsers.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/form_widgets.dart';

class AdminActions extends StatefulWidget {
  @override
  _AdminActionsState createState() => _AdminActionsState();
}

class _AdminActionsState extends State<AdminActions> {
  int _currGW;
  bool wc = false;
  bool tc = false;
  bool fh = false;

  @override
  void initState() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    _currGW = user.currGW;
    wc = false;
    tc = false;
    fh = false;
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
              setFlagButton(),
              activatePatchModeBtn(context, user),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              setCurrentGW(forms, user, context),
              deadlineBtn(context, user)
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [initPlayerDBBtn(), resetChips()]),
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
          FirebaseCore().pushAdminCurrGW(user);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("DEADLINE ACTIVATED: new curr gw ${user.currGW}"),
          ));
          setState(() {});
        });
  }

  // This button will activate patchmode, logging out all users and allow deadline/point entry to occur
  // It will also revert patch mode
  Widget activatePatchModeBtn(context, LoggedInUser user) {
    String msg = user.patchMode
        ? "Deactivating patchmode will allow users back into app. Are you sure?"
        : "Activating patchmode will logout all users, backup DB, ready for "
            "deadline button to be pressed and points entered. Are you sure?";

    return MaterialButton(
        child: Text(
          "${user.patchMode ? "Deactivate" : "Activate"} Patch Mode",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.black,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Toggle Patch mode'),
                  content: Text(msg),
                  actions: [
                    MaterialButton(
                      textColor: Color(0xFF6200EE),
                      onPressed: () {
                        user.patchMode = !user.patchMode;
                        FirebaseCore().pushPatchMode(user);
                        Authentication().logoutAllNonAdmin();
                        FirebaseCore().backupDB();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Patch Mode ${user.patchMode ? "ACTIVATED" : "DEACTIVATED"}"),
                        ));
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text(user.patchMode ? "Deactivate" : "Activate"),
                    ),
                    MaterialButton(
                      textColor: Color(0xFF6200EE),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                );
              });
        });
  }

  Widget setFlagButton() {
    return MaterialButton(
        child: Text(
          "Manage Flags",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.purple,
        onPressed: () {
          Navigator.pushNamed(context, Routes.Flag);
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
              FirebaseCore().pushAdminCurrGW(user);
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
                content: Text(
                    "Are you sure you want to reinitialise playerDB? Go delete collection first or youll have double ups!"),
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

  Widget resetChips() {
    return MaterialButton(
        child: Text(
          "Reset Chips",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.black,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Reset Chips?'),
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(children: [
                      Text("Which chips do you want to reset?"),
                      checkBoxWithLabel("Wildcard", wc, setState),
                      checkBoxWithLabel("Triple Cap", tc, setState),
                      checkBoxWithLabel("Free Hit", fh, setState),
                    ]);
                  }),
                  actions: [
                    MaterialButton(
                      textColor: Color(0xFF6200EE),
                      onPressed: () {
                        FirebaseUsers().resetChips(wc, tc, fh);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Chips reset'),
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
        });
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

  Widget checkBoxWithLabel(String name, bool val, StateSetter setter) {
    return Row(children: [
      Text(name),
      Checkbox(
        value: val,
        onChanged: (checkVal) => setter(() {
          _setCheck(checkVal, name);
        }),
      ),
    ]);
  }

  void _setCheck(bool checkVal, String name) {
    switch (name) {
      case "Wildcard":
        wc = checkVal;
        break;
      case "Free Hit":
        fh = checkVal;
        break;
      case "Triple Cap":
        tc = checkVal;
        break;
    }
  }
}
