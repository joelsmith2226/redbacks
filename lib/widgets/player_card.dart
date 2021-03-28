import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';

class PlayerCard {
  Player player;
  AlertDialog pc;
  BuildContext context;

  PlayerCard({this.player, this.context}) {
    this.pc = AlertDialog(
      title: Text('Player Card', textAlign: TextAlign.center,),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/avatar-nobg.png",
                width: MediaQuery.of(context).size.width * 0.3),
            SizedBox(height:30),
            Text(
                'Name: ${this.player.name}\nValue: \$${this.player.price}\nTotal Points: ${this.player.totalPts}\n'),
          ]),
      actions: [
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  void displayCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this.pc;
      },
    );
  }
}
