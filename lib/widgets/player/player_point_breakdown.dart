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
    return Container(
      padding: EdgeInsets.all(10),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(this.show ? 0 : 10))),
              child: InkWell(
                onTap: _onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    categoryContainer("GW-${widget.gw.id}", 0.15),
                    categoryContainer("${widget.gw.opposition}", 0.3),
                    categoryContainer("${widget.gw.gameScore}", 0.15),
                    categoryContainer('${pgw.gwPts}pts', 0.15),
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
      ),
    );
  }

  Widget categoryContainer(String text, double width) {
    TextStyle style =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w400);

    return Container(
        width: MediaQuery.of(context).size.width * width,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: style,
          ),
        ));
  }

  Widget pointBreakdown(PlayerGameweek pgw) {
    List<Widget> pbrs = [];
    pgw.pointBreakdown.pointBreakdownRows.sort((a, b) => a.category.compareTo(b.category));
    pgw.pointBreakdown.pointBreakdownRows.forEach((pbr) {
      if (pbr.points != 0)
        pbrs.add(pointBreakdownRows(pbr));
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: pbrs,
      ),
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
