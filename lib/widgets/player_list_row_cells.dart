import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';

class PlayerListRowCells extends StatelessWidget {

  Player p;
  PlayerListRowCells(this.p);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Hello there"));
  }
}
