import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/homepage_summary.dart';
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
    int freshHits = user.hits;
    if (user.originalModels != null) {
      freshHits = (user.hits - user.originalModels.hits) * 4;
    }
    String fts = user.freeTransfers == UNLIMITED ? UNLIMITED_SYMBOL : '${user.freeTransfers}';
    return HomepageSummary(
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        ChooseTeamSummaryContainer(
          "Free Transfer",
          fts,
        ),
        user.signingUp ? Container() : ChooseTeamSummaryContainer(
          "Wildcard",
          "Available",
        ),
        user.signingUp ? Container() : ChooseTeamSummaryContainer(
          "Cost",
          "${freshHits}",
        ),
        ChooseTeamSummaryContainer(
          "Budget Left:",
          "\$${roundToXDecimalPlaces(user.budget + removalBudget)}m",
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
