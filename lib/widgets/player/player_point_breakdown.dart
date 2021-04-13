import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/models/point_breakdown.dart';
import 'package:redbacks/providers/gameweek.dart';

class PlayerPointBreakdown extends StatefulWidget {
  Gameweek gw;
  Player p;

  PlayerPointBreakdown(this.gw, this.p);

  @override
  _PlayerPointBreakdownState createState() => _PlayerPointBreakdownState();
}

class _PlayerPointBreakdownState extends State<PlayerPointBreakdown> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    PlayerGameweek pgw =
        widget.gw.playerGameweeks.firstWhere((pgw) => pgw.id == widget.p.name);
    TextStyle style =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w400);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: InkWell(
              onTap: _onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "GW-${widget.gw.id}",
                    style: style,
                  ),
                  Text(
                    'Score: ${widget.gw.gameScore}',
                    style: style,
                  ),
                  Text(
                    '${pgw.gwPts}pts',
                    style: style,
                  ),
                  this.show
                      ? Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.arrow_drop_up,
                          size: 30,
                          color: Colors.white,
                        ),
                ],
              ),
            ),
          ),
          this.show ? pointBreakdown(pgw) : Container(),
        ],
      ),
    );
  }

  Widget pointBreakdown(PlayerGameweek pgw) {
    List<Widget> pbrs = [];
    pgw.pointBreakdown.pointBreakdownRows.forEach((pbr) {
      pbrs.add(pointBreakdownRows(pbr));
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: pbrs,
    );
  }

  Widget pointBreakdownRows(PointBreakdownRow pbr) {
    return ListTile(
      leading: Container(width: 100, child: Text(pbr.category)),
      title: Text(
        '${pbr.value}',
        textAlign: TextAlign.center,
      ),
      trailing: Text('${pbr.points}'),
    );
  }

  void _onPressed() {
    this.show = !this.show;
    setState(() {});
  }
}
