import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';

class RedbacksFirebase {
  // make instance accessible via constructor
  RedbacksFirebase();

  // User management
  User isSignedIn() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<Team> getTeam(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user = firestore.collection('users').doc(uid);
    return user
        .collection("Team")
        .get()
        .then((QuerySnapshot playerData) => 
        Team.fromData(playerData.docs))
    .onError((error, stackTrace) {
      print("Error! ${error}");
      return null;});
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
      print("Error in getPlayers: ${error}");
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
    DocumentReference user = firestore.collection('users').doc(uid);
    // First check if the doc already exists then update, otherwise add
    team.players.asMap().forEach((index, player) {
      addPlayerToTeamInDB(player, index, user);
    });
  }

  Future<void> addPlayerToTeamInDB(
      Player p, int index, DocumentReference user) {
    return user
        .collection("Team")
        .doc("Player-${index}")
        .set({
          'name': p.name,
          'price': p.price,
          'position': p.position,
          'flagged': p.flagged,
          'transferredIn': p.transferredIn,
          'transferredOut': p.transferredOut,
          'gwPts': p.currPts,
          'totalPts': p.totalPts,
        })
        .then((value) => print("Team Updated with player ${p.name}"))
        .catchError((error) => print("Failed to update team: $error"));
  }

  Future<void> checkUserInDB(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    // add a new user if the user is not in users
    return users
        .doc(uid)
        .get()
        .then((DocumentSnapshot doc) {
          print("${uid} 1");
          if (!doc.exists) {
            addUserToDB(uid);
          }
        })
        .then((value) => print("User SOrted out: ${uid}"))
        .catchError((error) => print("Failed to sort out user: $error"));
  }

  Future<void> addUserToDB(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return users
        .doc(uid)
        .set({})
        .then((value) => print("User Added: ${uid}"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addGWHistoryToDB(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user = firestore.collection('users').doc(uid);

    return user
        .collection("GW-History")
        .doc("GW-0")
        .set({
          "gw-pts": 0,
          "total-pts": 0,
          "hits-taken": 0,
          "chips-used": "",
        })
        .then((value) => print("GW history added"))
        .catchError((error) => print("Failed to add gw history: $error"));
  }

  Future<void> pushMiscFieldsToDB(String uid, double budget, double teamValue,
      String email, int gwPts, int totalPts, String teamName) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference user = firestore.collection('users');

    return user
        .doc(uid)
        .set({
          "email": email,
          "budget": budget,
          "team-value": teamValue,
          "gw-pts": gwPts,
          "total-pts": totalPts,
          "team-name": teamName,
        })
        .then((value) => print("User Misc Details Added: ${uid}"))
        .catchError(
            (error) => print("Failed to add user misc details: $error"));
  }

  Future<DocumentSnapshot> getMiscDetails(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference user = firestore.collection('users');

    return user
        .doc(uid)
        .get()
        .then((data) { return data;})
        .catchError(
            (error) => print("Failed to add user misc details: $error"));
  }
}
