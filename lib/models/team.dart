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

  bool transfer(Transfer pendingTransfer){
    Player incoming = pendingTransfer.incoming;
    Player outgoing = pendingTransfer.outgoing;
    int indexOfOutgoing = this._players.indexWhere((player) => player == outgoing);
    if (indexOfOutgoing == null){
      return false; // something went wrong, player doesn't exist
    } else {
      this._players[indexOfOutgoing] = incoming;
      return true;
    }
  }

  double teamValue(){
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
}
