import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/team_widget.dart';
import 'package:redbacks/widgets/transfers_summary.dart';

class TransfersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    if (user.originalTeam == null) {
      user.originalTeam = Team(new List.from(user.team.players));
    }
    user.originalTeam.players.forEach((element) {print(element.name);});
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TransfersSummary(),
          TeamWidget(
            user.team,
            mode: PRICE,
            bench: false,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ],
      ),
    );
  }
}
