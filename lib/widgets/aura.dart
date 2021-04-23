import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';

class Aura extends StatelessWidget {
  Widget child;
  TeamPlayer teamPlayer;
  Player player;

  Aura({this.child, this.teamPlayer, this.player});

  @override
  Widget build(BuildContext context) {
    Color aura = Colors.transparent;
    Color border = _inConsideration() ? Colors.blue.withAlpha(200) : Colors.transparent;

    aura =
        this.player == null ? auraFromTeamPlayer(aura) : auraFromPlayer(aura);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: border, width: 5),
      ),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: aura, width: 5),
            color: aura,
          ),
          child: child
      ),
    );
  }

  Color auraFromTeamPlayer(Color aura) {
    if (teamPlayer.flag != null) {
      aura = teamPlayer.flag.severity == 1
          ? Colors.yellow.withAlpha(200)
          : Colors.red.withAlpha(200);
    } else if (teamPlayer.inConsideration) {
      aura = Colors.blue.withAlpha(200);
    }
    return aura;
  }

  Color auraFromPlayer(Color aura) {
    if (player.flag != null) {
      aura = player.flag.severity == 1
          ? Colors.yellow.withAlpha(200)
          : Colors.red.withAlpha(200);
    } else if (player.inConsideration) {
      aura = Colors.blue.withAlpha(200);
    }
    return aura;
  }

  bool _inConsideration() {
    if (this.player == null) {
      return this.teamPlayer.inConsideration;
    } else {
      return this.player.inConsideration;
    }
  }
}
