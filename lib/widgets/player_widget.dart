import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';

class PlayerWidget extends StatefulWidget {
  Player player;
  PlayerWidget(this.player);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/avatar.png"),
    );
  }
}
