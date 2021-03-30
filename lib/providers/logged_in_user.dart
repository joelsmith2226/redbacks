import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/transfer.dart';

class LoggedInUser extends ChangeNotifier {
  String _email;
  String _pwd = ""; // don't think we can access this
  String _uid;
  bool _admin;
  Team _team;
  int _totalPts;
  int _gwPts;
  Transfer _pendingTransfer;
  double _teamValue;
  double _budget;
  List<Player> _playerDB;

  LoggedInUser();

  void initialiseUser() {
    User user = RedbacksFirebase().isSignedIn(); // FirestoreAuth User
    if (user != null) {
      this.email = user.email;
      this.uid = user.uid;
      this.admin = admins.contains(this.email);
      this.team = RedbacksFirebase().getTeam(this.uid);
      this.calculateTeamValue();
      print("Loaded user successfully. Should proceed to home page");
      notifyListeners();
    } else {
      print('User is currently signed out! Continue with login');
    }
  }

  void setInitialTeam() {
    this.team = Team.blank();
    this.budget = 100.0;
  }

  void beginTransfer(Player outgoing) {
    this.pendingTransfer = Transfer();
    this.pendingTransfer.outgoing = outgoing;
  }

  bool completeTransfer(Player incoming) {
    this.pendingTransfer.incoming = incoming;
    if (this.team.transfer(this.pendingTransfer)) {
      if (this.adjustBudget()) {
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // Checks if user can afford to make the pending transfer
  // Assumes only runs after confirming that both players are viable
  // for transfer
  bool adjustBudget(){
    Player incoming = this.pendingTransfer.incoming;
    Player outgoing = this.pendingTransfer.outgoing;
    if (this.budget - incoming.price + outgoing.price >= 0){
      this.budget -= incoming.price;
      this.budget += outgoing.price;
      return true;
    }
    return false;
  }

  bool isLoggedIn() {
    return this.email != null;
  }

  void calculateTeamValue(){
    this.teamValue = this.team.teamValue(); // todo seems bad style
  }

  void loadInCurrentPlayerDatabase() {
    this.playerDB = [];
    RedbacksFirebase().getPlayers(this.playerDB);
    //   (players) {
    //   this.playerDB = players;
    //   if(this.playerDB != null) {
    //     print("Loaded in playerDB => ${this.playerDB.length}");
    //   } else {
    //     print("Jks loading in playerDB failed");
    //   }
    // });
  }

  void pushUserDetailsToDB() {
    // new user in users if needed
    print("adding user to db");
    RedbacksFirebase().addUserToDB(this.uid);
    // new gw history in users/{user}/gw history if needed
    // RedbacksFirebase().addGWHistoryToDB(this.uid);
    // // new/update team in users/{user}/team
    // RedbacksFirebase().pushTeamToDB(this.team, this.uid);
    // // new/update other fields required to track
    // RedbacksFirebase().pushMiscFieldsToDB(this.uid, this.budget, this.teamValue, this.email, this.gwPts, this.totalPts);

  }


  void pushTeamToDB() {
    RedbacksFirebase().pushTeamToDB(this.team, this.uid);

  }


  // GETTERS & SETTERS
  int get gwPts => _gwPts;

  set gwPts(int value) {
    _gwPts = value;
  }

  int get totalPts => _totalPts;

  set totalPts(int value) {
    _totalPts = value;
  }

  Team get team => _team;

  set team(Team value) {
    _team = value;
  }

  bool get admin => _admin;

  set admin(bool value) {
    _admin = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get pwd => _pwd;

  set pwd(String value) {
    _pwd = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  Transfer get pendingTransfer => _pendingTransfer;

  set pendingTransfer(Transfer value) {
    _pendingTransfer = value;
  }

  double get budget => _budget;

  set budget(double value) {
    _budget = value;
  }

  double get teamValue => _teamValue;

  set teamValue(double value) {
    _teamValue = value;
  }

  List<Player> get playerDB => _playerDB;

  set playerDB(List<Player> value) {
    _playerDB = value;
  }


}
