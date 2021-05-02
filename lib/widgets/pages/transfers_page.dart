import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/original_models.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/transfers_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class TransfersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    if (user.originalModels == null) {
      user.originalModels = OriginalModels(
        Team(new List.from(user.team.players)),
        user.budget,
        user.freeTransfers,
        user.completedTransfers,
        user.hits,
      );
    }
    return Container(
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TransfersSummary(),
          Expanded(
            child: TeamWidget(
              user.team,
              mode: PRICE,
              bench: false,
            ),
          )
        ],
      ),
    );
  }
}
