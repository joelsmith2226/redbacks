import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/transfer.dart';

class OriginalModels {
  Team team;
  double budget;
  int freeTransfers;
  List<Transfer> completedTransfers;
  int hits;

  OriginalModels(this.team, this.budget, this.freeTransfers, this.completedTransfers, this.hits);
}