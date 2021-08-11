import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

import '../../globals/rFirebase/firebaseUsers.dart';

class TransfersSummary extends StatefulWidget {
  @override
  _TransfersSummaryState createState() => _TransfersSummaryState();
}

class _TransfersSummaryState extends State<TransfersSummary> {
  String fts;
  String budget;

  @override
  void initState() {
    super.initState();
    ftsAndBudget();
  }

  void ftsAndBudget() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    this.fts = user.freeTransfers == UNLIMITED
        ? UNLIMITED_SYMBOL
        : '${user.freeTransfers}';

    this.budget = user.budget == UNLIMITED
        ? UNLIMITED_SYMBOL
        : '\$${roundToXDecimalPlaces(user.budget)}m';
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    return Column(children: [
      HomepageSummary(
        bottomMargin: 0,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TransfersSummaryContainer("Free Transfers", fts),
            TransfersSummaryContainer("Hits Taken", "${user.hits}"),
            TransfersSummaryContainer(
                "Bank", "${budget}"),
          ],
        ),
      ),
      this.TransfersFooter()
    ]);
  }

  Widget TransfersSummaryContainer(String category, String value) {
    return SummaryContainer(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            category,
            style: TextStyle(fontSize: 11, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          color: Colors.black.withAlpha(50),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(value,
              style: TextStyle(fontSize: 11, color: Colors.white),
              textAlign: TextAlign.center),
          color: Theme.of(context).primaryColor.withAlpha(150),
        )
      ],
    ));
  }

  Widget TransfersFooter() {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
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
        onPress: chipIndex == 0
            ? () => wildcardDialog(context)
            : () => freehitDialog(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                chipIndex == 0 ? "Wildcard" : "Limitless",
                style: TextStyle(fontSize: 11, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: Colors.black.withAlpha(50),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(_containerText(chipIndex),
                  style: TextStyle(fontSize: 11, color: Colors.white),
                  textAlign: TextAlign.center),
              color: _containerColor(chipIndex),
            )
          ],
        ));
  }

  void wildcardDialog(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    if (user.anyChipsActive()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Cannot activate Wildcard while other chips active or cannot deactivate once popped'),
      ));
      return; //cannot deactivate once active or if WC active
    }
    if (!user.chips[0].available) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'You\'ve already used your wildcard!'),
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          bool wcStatus = user.chips[0].active;
          return AlertDialog(
            title: Text("Activate Wildcard?"),
            content: Text(
                "Wildcard allows you to make unlimited transfers for one week with no "
                    "hits applied. You only get one per season and once active you can't deactivate. Are you sure you want to activate?"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  if (wcStatus) {
                    FirebaseUsers().activateDeactivateChip(
                        user.uid, "wildcard", !wcStatus);
                    FirebaseUsers()
                        .availableUnavailableChip(user.uid, "wildcard", true);
                    FirebaseUsers().unlimitedTransfers(user.uid, number: 1);
                    this.fts = '1';
                    Navigator.pop(context);
                    setState(() {});
                  } else {
                    setState(() {
                      user.chips[0].active = !wcStatus;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Wildcard Activated!'),
                      ));
                      FirebaseUsers().activateDeactivateChip(
                          user.uid, "wildcard", !wcStatus);
                      FirebaseUsers().availableUnavailableChip(
                          user.uid, "wildcard", false);
                      FirebaseUsers().unlimitedTransfers(user.uid);
                      this.fts = UNLIMITED_SYMBOL;
                      Navigator.pop(context);
                    });
                  }
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
    if (user.anyChipsActive()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Cannot activate Limitless while other chips active or cannot deactivate once popped'),
      ));
      return;
    }
    if (!user.chips[1].available) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'You\'ve already used your limitless!'),
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          bool fhStatus = user.chips[1].active;
          return AlertDialog(
            title: Text("Activate Limitless?"),
            content: Text(
                "Limitless allows you to make unlimited transfers with unlimited budget for one week with no "
                    "hits applied and then your team returns to your current team prior to activating."
                    " You only get one per season and once active you can't deactivate. Are you sure you want to activate?"),
            actions: [
              MaterialButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  setState(() {
                    user.chips[1].active = !fhStatus;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Limitless Activated!'),
                    ));
                    FirebaseUsers().activateDeactivateChip(
                        user.uid, "free-hit", !fhStatus);
                    FirebaseUsers()
                        .availableUnavailableChip(user.uid, "free-hit", false);
                    FirebaseUsers().unlimitedTransfers(user.uid);
                    FirebaseUsers().unlimitedBudget(user.uid);
                    user.freeTransfers = UNLIMITED;
                    user.budget = UNLIMITED_BUDGET; // to load in immediately
                    user.originalModels.budget = UNLIMITED_BUDGET;
                    user.originalModels.freeTransfers = UNLIMITED;
                    this.fts = UNLIMITED_SYMBOL;
                    user.chips[1].available = false;
                    this.budget = UNLIMITED_SYMBOL;
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
    if (user.chips[chipIndex].active) {
      return "Active";
    } else if (user.anyChipsActive()) {
      return "Not Available";
    }else if (!user.chips[chipIndex].available) {
      return "Used";
    } else {
      return "Available";
    }
  }

  Color _containerColor(int chipIndex) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    if (user.chips[chipIndex].active) {
      return Colors.green;
    } else if (!user.chips[chipIndex].available || user.anyChipsActive()) {
      return Colors.grey;
    } else {
      return Theme.of(context).primaryColor.withAlpha(150);
    }
  }
}
