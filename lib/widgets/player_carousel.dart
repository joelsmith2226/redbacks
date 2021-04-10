import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/models/playerGameweek.dart';
import 'package:redbacks/widgets/player_widget.dart';

class PlayerCarousel extends StatefulWidget {
  Gameweek gw;

  PlayerCarousel({this.gw});

  @override
  _PlayerCarouselState createState() => _PlayerCarouselState();
}

class _PlayerCarouselState extends State<PlayerCarousel> {
  @override
  Widget build(BuildContext context) {
    widget.gw.playerGameweeks.sort((a, b) => a.position.compareTo(b.position));
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.11,
      child: ListView.builder(
        itemCount: widget.gw.playerGameweeks.length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          PlayerGameweek currPlayerGW = widget.gw.playerGameweeks[index];
          return Container(
              color: index ==  widget.gw.currPlayerIndex
                  ? Colors.blue.withAlpha(190)
                  : Colors.transparent,
              foregroundDecoration: currPlayerGW.saved
                  ? BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        scale: 0.4,
                        image: AssetImage("assets/tick.png"),
                      ),
                    )
                  : null,
              child: InkWell(
                  child: PlayerWidget(currPlayerGW.player, CAROUSEL),
                  onTap: () {
                    setState(() {
                      widget.gw.currPlayerIndex = index;
                    });
                  }),
              padding: EdgeInsets.symmetric(horizontal: 3));
        },
      ),
    );
  }
}
