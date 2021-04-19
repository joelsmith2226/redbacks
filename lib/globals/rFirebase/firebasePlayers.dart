import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class FirebasePlayers{

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
      'flagged': p.flagged,
      'transferredIn': p.transferredIn,
      'transferredOut': p.transferredOut,
      'gwPts': p.currPts,
      'totalPts': p.totalPts,
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

  Future<void> addPlayerGWs(Gameweek gw) async{
    // Loop over players
    // go to GW history collection
    // add/reset correct gw
    // add pgw, score is irrelevant
    // adjust global curr pts and total points
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    QuerySnapshot playersSnapshot = await players.get();
    for (int i=0; i < playersSnapshot.docs.length; i++){
      
    }

  }

  Future<void> addPlayerGW(PlayerGameweek pgw, int gwNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    // Find corr player doc for pgw
    QuerySnapshot currPlayer = await players.where('name', isEqualTo: pgw.id).get();
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
}