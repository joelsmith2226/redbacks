import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/transfer.dart';

class Team {
  List<Player> _players;

  Team.blank() {
    this._players = [
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
    ];
  }

  Team.fromData(teamData) {
    if (this.players != null) {
      this.players.asMap().forEach((index, player) {
        print(index);
        this.players[index] = Player.fromData(teamData[index].data());
      });
    } else {
      this.players = [];
      teamData.forEach(
          (playerData) => this.players.add(Player.fromData(playerData.data())));
    }
  }

  bool transfer(Transfer pendingTransfer) {
    Player incoming = pendingTransfer.incoming;
    Player outgoing = pendingTransfer.outgoing;
    int indexOfOutgoing =
        this._players.indexWhere((player) => player.name == outgoing.name);
    print(indexOfOutgoing);
    if (indexOfOutgoing < 0) {
      return false; // something went wrong, player doesn't exist
    } else {
      this._players[indexOfOutgoing] = incoming;
      return true;
    }
  }

  double teamValue() {
    double value = 0;
    this.players.forEach((player) {
      value += player.price;
    });

    return value;
  }

  List<Player> get players => _players;

  set players(List<Player> value) {
    _players = value;
  }

  bool isComplete() {
    this.players.forEach((player) {
      if (player.name == "") {
        return false;
      }
    });
    return true;
  }

  void benchPlayer(Player benchwarmer) {
    int index =
        this.players.indexWhere((player) => player.name == benchwarmer.name);
    this.players[index] = this.players[5];
    this.players[5] = benchwarmer;
  }
}
