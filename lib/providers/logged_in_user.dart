import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/models/team.dart';

class LoggedInUser extends ChangeNotifier {
  String email;
  String pwd;
  String uid;
  bool admin;
  Team team;

  LoggedInUser({this.email, this.pwd, this.uid}){
    this.admin = admins.contains(this.email);
    this.team = RedbacksFirebase().getTeam(this.uid);
  }


}