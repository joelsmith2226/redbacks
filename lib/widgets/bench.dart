import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/player_widget.dart';

class Bench extends StatefulWidget {
  Player player;
  String secondary;

  Bench({this.player, this.secondary});

  @override
  _BenchState createState() => _BenchState();
}

class _BenchState extends State<Bench> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      color: Colors.black.withAlpha(100),
      child: Stack(
        children: [
          Icon(Icons.event_seat, size: 80, color: Colors.white,),
          PlayerWidget(
            widget.player,
            widget.secondary,
            benched: true,
          ),
        ],
      ),
      alignment: Alignment.center,
    );
  }
}
