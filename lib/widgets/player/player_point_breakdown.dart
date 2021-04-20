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
    PlayerGameweek pgw;
    try {
      pgw = widget.gw.playerGameweeks
          .firstWhere((pgw) => pgw.id == widget.p.name, orElse: null);
    } catch (e) {
      return Container();
    }
    TextStyle style =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w400);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(this.show ? 0 : 10))),
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
    TextStyle style =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w400);
    return ListTile(
      tileColor: Theme.of(context).accentColor,
      visualDensity: VisualDensity.compact,
      dense: true,
      leading: Container(width: 100, child: Text(pbr.category, style: style)),
      title: Text('${pbr.value}', textAlign: TextAlign.center, style: style),
      trailing: Text('${pbr.points}', style: style),
    );
  }

  void _onPressed() {
    this.show = !this.show;
    setState(() {});
  }
}
