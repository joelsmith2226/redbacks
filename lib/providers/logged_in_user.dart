import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/models/team.dart';

class LoggedInUser extends ChangeNotifier {
  String _email;
  String _pwd = ""; // don't think we can access this
  String _uid;
  bool _admin;
  Team _team;
  int _totalPts;
  int _gwPts;

  LoggedInUser(){
    initialiseUser();
  }

  void initialiseUser(){
    User user = RedbacksFirebase().isSignedIn(); // FirestoreAuth User
    if (user != null) {
      this.email = user.email;
      this.uid = user.uid;
      this.admin = admins.contains(this.email);
      this.team = RedbacksFirebase().getTeam(this.uid);
      print("Loaded user successfully. Should proceed to home page");
      notifyListeners();
    } else {
      print('User is currently signed out! Continue with login');
    }

  }

  void setInitialTeam(){
    this.team = Team.blank();
  }

  bool isLoggedIn(){
    return this.email != null;
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
}