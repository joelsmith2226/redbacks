import 'package:flutter/material.dart';
import 'package:redbacks/models/team_player.dart';

class Aura extends StatelessWidget {
  Widget child;
  TeamPlayer teamPlayer;
  Aura({this.child, this.teamPlayer});

  @override
  Widget build(BuildContext context) {
    Color aura = Colors.transparent;
    if (teamPlayer.flagged != ''){
      aura = Colors.yellow;
    } else if (teamPlayer.inConsideration) {
      aura = Colors.blue.withAlpha(200);
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: aura, width: 5),
        color: aura,
      ),
      child: child,
    );
  }
}
