import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebaseUsers.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

class TransfersFooter extends StatefulWidget {
  @override
  _TransfersFooterState createState() => _TransfersFooterState();
}

class _TransfersFooterState extends State<TransfersFooter> {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    String fts = user.freeTransfers == UNLIMITED
        ? UNLIMITED_SYMBOL
        : '${user.freeTransfers}';
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: HomepageSummary(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChipSummary(0),
            ChipSummary(1),
          ],
        ),
      ),
    );
  }

  Widget ChipSummary(int chipIndex) {
    return SummaryContainer(
        // onPress: chipIndex == 0 UNCOMMENT WHEN READY FOR chips todo
        //     ? () => wildcardDialog(context)
        //     : () => freehitDialog(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                chipIndex == 0 ? "Wildcard" : "Free Hit",
                style: TextStyle(fontSize: 11, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: Colors.black.withAlpha(50),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text("Coming Soon", //_containerText(chipIndex),
                  style: TextStyle(fontSize: 11, color: Colors.white),
                  textAlign: TextAlign.center),
              color: Colors.grey //_containerColor(chipIndex),
            )
          ],
        ));
  }

  void wildcardDialog(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    if (user.chips[1].active || user.chips[0].active) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Cannot activate Wildcard while on Free Hit or cannot deactivate once popped'),
      ));
      return; //cannot deactivate once active or if WC active
    }
    showDialog(
        context: context,
        builder: (context) {
          bool wcStatus = user.chips[0].active;
          return AlertDialog(
            title: Text("Activate Wildcard?"),
            content: Text(
                "Wildcard allows you to make unlimited transfers for one week with no"
                "hits applied. You only get one per season. Are you sure you want to activate?"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  setState(() {
                    user.chips[0].active = !wcStatus;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Wildcard Activated!'),
                    ));
                    FirebaseUsers().activateDeactivateChip(
                        user.uid, "wildcard", !wcStatus);
                    Navigator.pop(context);
                  });
                },
                child: Text('${wcStatus ? "Deactivate" : "Activate"}'),
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

  void freehitDialog(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    if (user.chips[1].active || user.chips[0].active) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Cannot activate Free Hit while on Wildcard or cannot deactivate once popped'),
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          bool fhStatus = user.chips[1].active;
          return AlertDialog(
            title: Text("Activate Freehit?"),
            content: Text(
                "Freehit allows you to make unlimited transfers for one week with no"
                "hits applied and then your team returns to your current team prior to activating."
                " You only get one per season. Are you sure you want to activate?"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  setState(() {
                    user.chips[1].active = !fhStatus;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Freehit Activated!'),
                    ));
                    FirebaseUsers()
                        .activateDeactivateChip(user.uid, "freehit", !fhStatus);
                    Navigator.pop(context);
                  });
                },
                child: Text('Activate'),
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

  String _containerText(int chipIndex) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    if (!user.chips[chipIndex].available) {
      return "Used";
    } else if (user.chips[chipIndex].active) {
      return "Active";
    } else {
      return "Available";
    }
  }

  Color _containerColor(int chipIndex) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    if (!user.chips[chipIndex].available) {
      return Colors.grey;
    } else if (user.chips[chipIndex].active) {
      return Colors.green;
    } else {
      return Theme.of(context).primaryColor.withAlpha(150);
    }
  }
}
