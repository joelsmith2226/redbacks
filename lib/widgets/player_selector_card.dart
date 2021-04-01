import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_list.dart';

class PlayerSelectorCard {
  Player outgoingPlayer;
  Player incomingPlayer;
  AlertDialog psc;
  BuildContext context;

  PlayerSelectorCard({this.outgoingPlayer, this.context}) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    List<Player> playerDB = new List.from(user.playerDB);
    playerDB.removeWhere((element) => user.team.players.contains(element));
    playerDB.sort((a, b) => a.position.compareTo(b.position));

    this.psc = AlertDialog(
      title: Text('Select New Player', textAlign: TextAlign.center,),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayerList(players: playerDB),
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
