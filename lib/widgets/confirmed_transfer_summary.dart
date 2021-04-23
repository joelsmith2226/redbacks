import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/models/transfer.dart';
import 'package:redbacks/widgets/player/player_widget.dart';

class ConfirmedTransferSummary extends StatelessWidget {
  Transfer transfer;

  ConfirmedTransferSummary({this.transfer});

  @override
  Widget build(BuildContext context) {
    TeamPlayer p1 = transfer.outgoing;
    TeamPlayer p2 = transfer.incoming;
    return Container(
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
            [
              PlayerWidget.fromTeamPlayer(p1, CAROUSEL),
              Icon(Icons.double_arrow, size: 20, color: Theme.of(context).primaryColor,),
              PlayerWidget.fromTeamPlayer(p2, CAROUSEL),
            ]
        )
    );
  }
}
