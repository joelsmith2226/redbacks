import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redbacks/globals/rFirebase/firebaseGWHistory.dart';
import 'package:redbacks/globals/rFirebase/firebaseLeaderboard.dart';
import 'package:redbacks/globals/rFirebase/firebaseUsers.dart';
import 'package:redbacks/models/leaderboard_list_entry.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/models/user_GW.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';

import 'firebasePlayers.dart';

class FirebaseCore {
  FirebasePlayers firebasePlayers = FirebasePlayers();
  FirebaseGWHistory firebaseGWHistory = FirebaseGWHistory();
  FirebaseLeaderboard firebaseLeaderboard = FirebaseLeaderboard();
  FirebaseUsers firebaseUsers = FirebaseUsers();

  // make instance accessible via constructor
  FirebaseCore();

  // User management
  User isSignedIn() {
    return FirebaseAuth.instance.currentUser;
  }

  // Player Management
  Future<void> addPlayer(Player p) {
    return firebasePlayers.addPlayer(p);
  }

  Future<void> getPlayers(List<Player> playerModels) {
    return firebasePlayers.getPlayers(playerModels);
  }

  void addAllPlayers(List<Player> players) {
    return firebasePlayers.addAllPlayers(players);
  }

  // Pushes the user's current team to the Firebase DB
  Future<void> pushTeamToDB(Team team, String uid) {
    return firebaseUsers.pushTeamToDB(team, uid);
  }

  Future<Team> getTeam(String uid, List<Player> players) {
    return firebaseUsers.getTeam(uid, players);
  }

  Future<void> addPlayerToTeamInDB(
      TeamPlayer p, int index, DocumentReference doc) {
    return firebaseUsers.addPlayerToTeamInDB(p, index, doc);
  }

  //---- Manage USERS ----//

  Future<void> checkUserInDB(String uid) {
    return firebaseUsers.checkUserInDB(uid);
  }

  Future<void> addUserToDB(String uid) {
    firebaseUsers.addUserToDB(uid);
  }

  Future<void> addUserGWHistoryToDB(
      QueryDocumentSnapshot doc, int currGw) async {
    return firebaseGWHistory.addUserGWHistoryToDB(doc, currGw);
  }

  Future<void> updateUserGWHistoryInDB(
      QueryDocumentSnapshot doc, Gameweek gw) async {
    return firebaseGWHistory.updateUserGWHistoryInDB(doc, gw);
  }

  Future<List<UserGW>> getCompleteUserGWHistory(
      String uid, List<Gameweek> globalGWHistory) {
    return firebaseGWHistory.getCompleteUserGWHistory(uid, globalGWHistory);
  }

  Future<void> pushMiscFieldsToDB(LoggedInUser user) {
    return firebaseUsers.pushMiscFieldsToDB(user);
  }

  Future<DocumentSnapshot> getMiscDetails(String uid) {
    return firebaseUsers.getMiscDetails(uid);
  }

  // GLOBAL ADMIN INFO
  Future<void> getAdminInfo(LoggedInUser user) {
    return firebaseUsers.getAdminInfo(user);
  }

  Future<void> pushAdminInfo(LoggedInUser user) {
    return firebaseUsers.pushAdminInfo(user);
  }

  // GW History Management

  void getGWHistory(List<Gameweek> gwHistory, List<Player> players) async {
    await firebaseGWHistory.getGWHistory(gwHistory, players);
  }

  Future<void> getPlayerGWs(
      List<Gameweek> gwModels, List<Player> players) async {
    await firebaseGWHistory.getPlayerGWs(gwModels, players);
  }

  Future<void> addGWToDB(Gameweek gw) async {
    await this.addGW(gw);
    await this.addAllPlayerGWs(gw);
  }

  Future<void> addGW(Gameweek gw) async {
    await firebaseGWHistory.addGW(gw);
    return;
  }

  Future<void> addAllPlayerGWs(Gameweek gw) async {
    await firebaseGWHistory.addAllPlayerGWs(gw);
    return;
  }

  Future<void> addPlayerGW(PlayerGameweek gw, int gwNumber) {
    return firebaseGWHistory.addPlayerGW(gw, gwNumber);
  }

  // User + GW history
  Future<void> updateUsersGW(Gameweek gw) {
    // update user-GW-history with 1) gwpts achieved 2) add gwPts to totalPts
    print("After all the player GW added pls");
    performMethodOnAllUsers(
        (QueryDocumentSnapshot val) => updateUserGWHistoryInDB(val, gw));
  }

  // User + GW history
  Future<void> deadlineButton(int currGW) {
    // get a list of users
    // create a GW-History with 1) locked in team (with cap/vice)
    // 2) num transfers
    // 3) hits/chips used todo
    // 4) reset hits/chips. Add free transfer
    performMethodOnAllUsers((QueryDocumentSnapshot val) async {
      await addUserGWHistoryToDB(val, currGW);
      await firebaseUsers.resetMiscDetailsForNewWeek(val.reference.id);
    });
  }

  // Helper Functions

  Future<void> performMethodOnAllUsers(Function fn) async {
    // get a list of users
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    QuerySnapshot user = await users.get();
    user.docs.forEach((doc) {
      if (doc.id != 'admin') fn(doc);
    });
  }

  Future<void> copyCollection(
      CollectionReference collection, DocumentReference target) {
    print("Attempting to copy ${collection.id} into ${target.id}");
    collection.get().then((QuerySnapshot query) {
      query.docs.forEach((collectionDocToMove) {
        target
            .collection(collection.id)
            .doc(collectionDocToMove.id)
            .set(collectionDocToMove.data());
      });
    }).catchError((error) => print("Failed to copy collection: ${error}"));
  }

}
