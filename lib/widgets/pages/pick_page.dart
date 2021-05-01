import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebaseUsers.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/pick_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PickPage extends StatefulWidget {
  @override
  _PickPageState createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  LoggedInUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LoggedInUser>(context);

    // Ensure captain is good
    user.team.checkCaptain();
    return Container(
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PickSummary(
            summaryDialogFn: () => null //tripleCapDialog(context),
          ),
          TeamWidget(user.team, bench: true, mode: PICK),
        ],
      ),
    );
  }

  void tripleCapDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          bool tripCapStatus = user.chips[2].active;
          return AlertDialog(
            title: Text(
                "${tripCapStatus ? "Deactivate" : "Activate"} Triple Captain"),
            content: Text(
                "Triple captain allows your captain to score triple points this week. "
                "If they do not play, your vice will receive triple points. "
                "Do you wish to ${tripCapStatus ? "deactivate" : "activate"} this chip? You can ${tripCapStatus ? "reactivate" : "deactivate"} before the deadline"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  setState(() {
                    user.chips[2].active = !tripCapStatus;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Triple Captain ${tripCapStatus ? "Deactivated" : "Activated"}!'),
                    ));
                    FirebaseUsers().activateDeactivateChip(
                        user.uid, "triple-cap", !tripCapStatus);
                    Navigator.pop(context);
                  });
                },
                child: Text('${tripCapStatus ? "Deactivate" : "Activate"}'),
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
  }
}
