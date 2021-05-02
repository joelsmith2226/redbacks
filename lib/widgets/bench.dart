import 'package:flutter/material.dart';
import 'package:redbacks/widgets/player/player_widget.dart';

class Bench extends StatefulWidget {
  PlayerWidget player;

  Bench({this.player});

  @override
  _BenchState createState() => _BenchState();
}

class _BenchState extends State<Bench> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.12,
        color: Colors.black.withAlpha(100),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.event_seat,
              size: 100,
              color: Colors.white,
            ),
            widget.player,
          ],
        ),
        alignment: Alignment.center,
    );
  }
}
