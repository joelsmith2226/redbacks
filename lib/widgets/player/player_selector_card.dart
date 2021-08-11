import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player/player_list.dart';

import '../../globals/constants.dart';

class PlayerSelectorCard {
  TeamPlayer outgoingPlayer;
  TeamPlayer incomingPlayer;
  AlertDialog psc;
  BuildContext context;
  LoggedInUser user;
  List<Player> playerDB;
  double budget;

  PlayerSelectorCard({this.outgoingPlayer, this.context}) {
    user = Provider.of<LoggedInUser>(context, listen: false);
    playerDB = [];
    user.playerDB.forEach((player) {
      if (!user.team.players
          .any((currPlayer) => player.name == currPlayer.name)) {
        playerDB.add(player);
      }
    });
    playerDB.sort((a, b) => a.position.compareTo(b.position));
    budget = user.budget + user.team.removalBudget();
    if (!outgoingPlayer.removed) budget += outgoingPlayer.currPrice;
    // this.psc = dialog(user, playerDB, budget);
  }

  AlertDialog dialog(LoggedInUser user, List<Player> playerDB, double budget) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15.0),
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Select New Player',
        textAlign: TextAlign.center,
      ),
      content: Builder(
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Budget: ${roundToXDecimalPlaces(budget)}m"),
                PlayerList(
                    players: playerDB, outgoingPlayer: this.outgoingPlayer),
              ],
            ),
          );
        },
      ),
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
        return Container(width: MediaQuery.of(context).size.width, child: dialog(user, playerDB, budget));
      },
    );
  }
}
