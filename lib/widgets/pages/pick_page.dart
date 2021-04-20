import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PickPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    // Ensure captain is good
    user.team.checkCaptain();

    return Container(
      height: MediaQuery.of(context).size.height*0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 70,),
          TeamWidget(user.team, bench: true, mode: PICK),
        ],
      ),
    );
  }
}
