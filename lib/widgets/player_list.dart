import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/widgets/player_list_tile.dart';

class PlayerList extends StatefulWidget {
  List<Player> players;
  TeamPlayer outgoingPlayer;
  String mode;

  PlayerList({this.players, this.outgoingPlayer, this.mode = TRANSFER});

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  String _currCategory;
  bool _ascending;

  @override
  void initState() {
    this.widget.players.sort((a, b) => a.position.compareTo(b.position));
    this._ascending = true;
    this._currCategory = "Pos";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(200),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 1.4,
          child: ListView.builder(
            itemCount: widget.players.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Build category row
                return Column(children: [
                  CategoryListTile(
                      this._onCategoryTap, this._currCategory, this._ascending),
                  PlayerListTile(
                    player: widget.players[index],
                    outgoing: this.widget.outgoingPlayer,
                    mode: this.widget.mode,
                  ),
                ]);
              } else {
                return PlayerListTile(
                  player: widget.players[index],
                  outgoing: this.widget.outgoingPlayer,
                  mode: this.widget.mode,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(String category) {
    setState(() {
      bool _unoReverseCard = false;
      if (_currCategory == category) {
        this._ascending = !this._ascending;
        _unoReverseCard = true;
      }
      this._currCategory = category;
      this.sortByCategory(_unoReverseCard, category);
    });
  }

  void sortByCategory(bool _unoReverseCard, String key) {
    (_unoReverseCard)
        ? this
            .widget
            .players
            .sort((a, b) => a.toMap()[key].compareTo(b.toMap()[key]))
        : this
            .widget
            .players
            .sort((a, b) => b.toMap()[key].compareTo(a.toMap()[key]));
  }
}
