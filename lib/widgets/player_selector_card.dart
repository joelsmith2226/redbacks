import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_list.dart';

class PlayerSelectorCard {
  TeamPlayer outgoingPlayer;
  TeamPlayer incomingPlayer;
  AlertDialog psc;
  BuildContext context;

  PlayerSelectorCard({this.outgoingPlayer, this.context}) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen:false);
    List<Player> playerDB = [];
    user.playerDB.forEach((player) {
      if (!user.team.players
          .any((currPlayer) => player.name == currPlayer.name)) {
        playerDB.add(player);
      }
    });
    playerDB.sort((a, b) => a.position.compareTo(b.position));
    double budget = user.budget + user.team.removalBudget();
    if (!outgoingPlayer.removed) budget += outgoingPlayer.currPrice;
    this.psc = dialog(user, playerDB, budget);
  }

  AlertDialog dialog (LoggedInUser user, List<Player> playerDB, double budget){
    return AlertDialog(
      title: Text(
        'Select New Player',
        textAlign: TextAlign.center,
      ),
      content: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Budget: ${budget}m"),
            PlayerList(players: playerDB, outgoingPlayer: this.outgoingPlayer),
          ]),
      actions: [
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pop(context, this.outgoingPlayer);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void displayCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this.psc;
      },
    );
  }
}
