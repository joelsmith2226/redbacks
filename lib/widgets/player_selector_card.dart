import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/player_list.dart';

class PlayerSelectorCard {
  Player outgoingPlayer;
  Player incomingPlayer;
  AlertDialog psc;
  BuildContext context;

  PlayerSelectorCard({this.outgoingPlayer, this.context}) {
    this.psc = AlertDialog(
      title: Text('Select New Player', textAlign: TextAlign.center,),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayerList(players: [Player.template(), Player.template(), Player.template()]),
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
