import 'package:redbacks/globals/constants.dart';
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
  // Checks a captain and vice cap have been set, otherwise defaults.
  void checkCaptain() {
    int vice = -1;
    int cap = -1;
    this.players.forEach((player) {
      if (player.rank == VICE){
        vice = this.players.indexOf(player);
      } else if (player.rank == CAPTAIN) {
        cap = this.players.indexOf(player);
      }
    });

    // If none set or bench player is cap/vice, randomly select cap/vice
    List<int> badIndexes = [-1, 5];
    if (badIndexes.contains(vice)) {
      vice = cap == 0 ? 1 : 0; // sets vice to 0 if cap not 0
    }

    if (badIndexes.contains(cap)) {
      cap = vice == 0 ? 1 : 0; // sets vice to 0 if cap not 0
    }

    // Ensure cap/vice set
    this.players[cap].rank = CAPTAIN;
    this.players[vice].rank = VICE;
    print("Captain: ${this.players[cap].name}, Vice: ${this.players[vice].name}");
  }

  void updateCaptaincy(Player updatePlayer, String rank) {
    if (updatePlayer.rank == CAPTAIN && rank == VICE){
      // switch captain/vice
      Player oldVice = this.players.firstWhere((player) => player.rank == VICE);
      oldVice.rank = CAPTAIN;
    } else if (updatePlayer.rank == VICE && rank == CAPTAIN) {
      // switch captain/vice
      Player oldCap = this.players.firstWhere((player) => player.rank == CAPTAIN);
      oldCap.rank = VICE;
    } else {
      // find current captain/vice. Remove rank. Update current
      Player oldCap = this.players.firstWhere((player) => player.rank == rank);
      oldCap.rank = "";
    }
    Player newCap = this.players.firstWhere((player) => player.name == updatePlayer.name);
    newCap.rank = rank;
  }
}
