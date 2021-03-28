import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';

class RedbacksFirebase {
  // make instance accessible via constructor
  RedbacksFirebase();

  // User management
  bool isSignedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      return user == null;
    });
  }

  Team getTeam(String uid) {
    return Team.blank();
  }

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

  void getPlayers() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    List<Player> playerModels = [];

    players.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Player p = Player.blank();
        playerModels.add(p);
        print(p.price);
      });
    }).onError((error, stackTrace) {print(error + "Error in getPlayers");});
  }

  void addAllPlayers(List<Player> players){
    players.forEach((p) {
      print("Attempting to add ${p.name}");
      this.addPlayer(p);
    });
  }
}
