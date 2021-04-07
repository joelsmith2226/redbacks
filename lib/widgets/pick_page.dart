import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/points_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';


class PickPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          TeamWidget(user.team, bench: true, mode: PICK),
        ],
      ),
    );
  }
}
