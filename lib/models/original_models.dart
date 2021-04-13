import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/transfer.dart';

class OriginalModels {
  Team team;
  double budget;
  int freeTransfers;
  List<Transfer> completedTransfers;

  OriginalModels(this.team, this.budget, this.freeTransfers, this.completedTransfers);
}