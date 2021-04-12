import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

class ChooseTeamSummary extends StatefulWidget {
  @override
  _ChooseTeamSummaryState createState() => _ChooseTeamSummaryState();
}

class _ChooseTeamSummaryState extends State<ChooseTeamSummary> {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    double removalBudget = user.team.removalBudget();
    return HomepageSummary(
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        ChooseTeamSummaryContainer(
          "Free Transfer",
          "${user.freeTransfers}",
        ),
        ChooseTeamSummaryContainer(
          "Wildcard",
          "Available",
        ),
        ChooseTeamSummaryContainer(
          "Cost",
          "0",
        ),
        ChooseTeamSummaryContainer(
          "Budget Left:",
          "\$${user.budget + removalBudget}m",
        ),
      ]),
    );
  }

  Widget ChooseTeamSummaryContainer(String category, String value) {
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
}
