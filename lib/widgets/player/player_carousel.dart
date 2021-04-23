import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/widgets/aura.dart';
import 'package:redbacks/widgets/player/player_widget.dart';

class PlayerCarousel extends StatefulWidget {
  Gameweek gw;
  List<Player> playerDB;
  int currIndex;
  Function callback;

  PlayerCarousel({this.gw});

  PlayerCarousel.fromPlayerDB({this.playerDB, this.currIndex = 0, this.callback});

  @override
  _PlayerCarouselState createState() => _PlayerCarouselState();
}

class _PlayerCarouselState extends State<PlayerCarousel> {
  @override
  Widget build(BuildContext context) {
    return widget.gw != null
        ? carouselFromGW(context)
        : carouselFromDB(context);
  }

  Container carouselFromGW(BuildContext context) {
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
            padding: EdgeInsets.symmetric(horizontal: 3),
            color: index == widget.gw.currPlayerIndex
                ? Colors.blue.withAlpha(190)
                : Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.gw.currPlayerIndex = index;
                });
              },
              child: Aura(
                player: currPlayerGW.player,
                child: Stack(
                  children: [
                    PlayerWidget(currPlayerGW.player, CAROUSEL),
                    currPlayerGW.saved
                        ? Container(
                            height: 100,
                            child: Opacity(
                                child: Image.asset(
                                  "assets/tick.png",
                                ),
                                opacity: 0.7),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  carouselFromDB(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.11,
      child: ListView.builder(
        itemCount: widget.playerDB.length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3),
            color: index == widget.currIndex
                ? Colors.blue.withAlpha(190)
                : Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.currIndex = index;
                  widget.callback(index);
                });
              },
              child: Aura(
                player: widget.playerDB[index],
                child: Stack(
                  children: [
                    PlayerWidget(widget.playerDB[index], CAROUSEL),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
