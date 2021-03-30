import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';

class RedbacksFirebase {
  // make instance accessible via constructor
  RedbacksFirebase();

  // User management
  User isSignedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      return user;
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

  void getPlayers(List<Player> playerModels) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    print("Going into getPlayers");
    players.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        playerModels.add(Player.fromData(doc.data()));
        print("Player ${doc.data()["name"]} added to list");
      });
    }).onError((error, stackTrace) {
      print(error + "Error in getPlayers");
    });
  }

  void addAllPlayers(List<Player> players) {
    players.forEach((p) {
      print("Attempting to add ${p.name}");
      this.addPlayer(p);
    });
  }

  // Pushes the user's current team to the Firebase DB
  Future<void> pushTeamToDB(Team team, String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference teams = firestore.collection('teams');
    // First check if the doc already exists then update, otherwise add
    return teams
        .doc(uid)
        .update({}).then((value) => print("Team Updated"))
        .catchError((error) => print("Failed to update team: $error"));
  }

  Future<void> addUserToDB(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    // add a new user if the user is not in users
    return users.doc(uid).get().then((DocumentSnapshot doc){
      print("${uid} 1");
      if (!doc.exists) {
        print("${uid}");
        users
            .doc(uid)
            .set({})
            .then((value) => print("User Added: ${uid}"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    }).then((value) => print("User SOrted out: ${uid}"))
        .catchError((error) => print("Failed to sort out user: $error"));;

  }

  void addGWHistoryToDB(String uid) {

  }

  void pushMiscFieldsToDB(String uid, double budget, double teamValue, String email, int gwPts, int totalPts) {

  }
}
