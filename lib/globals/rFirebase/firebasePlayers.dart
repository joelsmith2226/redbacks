import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/providers/gameweek.dart';

class FirebasePlayers {
  // Player Management
  Future<void> addPlayer(Player p) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    // Call the user's CollectionReference to add a new user
    return players
        .add({
          'name': p.name,
          'price': p.price,
          'position': p.position,
          'flagged': p.flag == null ? null : p.flag.toMap(),
          'transferredIn': p.transferredIn,
          'transferredOut': p.transferredOut,
          'gwPts': p.currPts,
          'totalPts': p.totalPts,
          'picture': p.pic,
        })
        .then((value) => print("Player Added: ${p.name}"))
        .catchError((error) => print("Failed to add player: $error"));
  }

  Future<void> getPlayers(List<Player> playerModels) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    QuerySnapshot qs = await players.get();
    // Ensure playerModels is empty
    // playerModels = [];
    qs.docs.forEach((doc) {
      playerModels.add(Player.fromData(doc.data(), uid: doc.id));
      print("Player ${doc.data()["name"]} added to list");
    });
    return;
  }

  void addAllPlayers(List<Player> players) {
    players.forEach((p) {
      print("Attempting to add ${p.name}");
      this.addPlayer(p);
    });
  }

  void removePlayersCollection() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('players');
  }

  Future<void> addPlayerGWs(Gameweek gw) async {
    // Loop over players
    // go to GW history collection
    // add/reset correct gw
    // add pgw, score is irrelevant
    // adjust global curr pts and total points
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    QuerySnapshot playersSnapshot = await players.get();
    for (int i = 0; i < playersSnapshot.docs.length; i++) {}
  }

  Future<void> addPlayerGW(PlayerGameweek pgw, int gwNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    // Find corr player doc for pgw
    QuerySnapshot currPlayer =
        await players.where('name', isEqualTo: pgw.id).get();
    return players
        .doc(currPlayer.docs[0].id)
        .collection('GW-History')
        .doc('GW-${gwNumber}')
        .set({
          'appearance': pgw.appearance,
          'position': pgw.position,
          'goals': pgw.goals,
          'assists': pgw.assists,
          'saves': pgw.saves,
          'goals-conceded': pgw.goalsConceded,
          'quarter-clean': pgw.quarterClean,
          'half-clean': pgw.halfClean,
          'full-clean': pgw.fullClean,
          'yellow': pgw.yellowCards,
          'red': pgw.redCards,
          'owns': pgw.ownGoals,
          'pens': pgw.penaltiesMissed,
          'bonus': pgw.bonus,
          'saved': pgw.saved,
          'gw-pts': pgw.gwPts,
          'point-breakdown': pgw.pointBreakdown.toMap(),
        })
        .then((value) => print("Player GW Added: ${pgw.id}"))
        .catchError((error) => print("Failed to add player GW: $error"));
  }

  Future<void> calculatePlayerGlobalPts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    QuerySnapshot playersQS = await players.get();
    for (int i = 0; i < playersQS.docs.length; i++) {
      await calculateIndividualPlayerGlobalPts(playersQS.docs[i].id);
    }
  }

  Future<void> calculateIndividualPlayerGlobalPts(String playerId) async {
    // Calculate totalpts by adding all pgws and maintain the last pgw as curr pts
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot gwQS = await firestore
        .collection('players')
        .doc(playerId)
        .collection('GW-History')
        .get();

    int totalPts = 0;
    int currPts = 0;
    for (int i = 0; i < gwQS.docs.length; i++) {
      currPts = await gwQS.docs[i].get('gw-pts');
      totalPts += currPts;
    }

    // Set global curr pts & total pts
    firestore
        .collection('players')
        .doc(playerId)
        .set({'gwPts': currPts, 'totalPts': totalPts}, SetOptions(merge: true));
  }

  Future<void> repushAllGWs() async {
    // repush all exists GWs

  }

  Future<void> setFlag(Player p) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Get correct player doc
    QuerySnapshot player = await firestore.collection('players').where('name', isEqualTo: p.name).limit(1).get();

    firestore.collection('players').doc(player.docs[0].id).set({
      'flagged': p.flag == null ? null : p.flag.toMap(),
    }, SetOptions(merge: true));
  }
}
