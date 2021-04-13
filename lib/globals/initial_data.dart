import 'package:redbacks/models/player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'rFirebase/firebaseCore.dart';

class InitialData {
  List<Player> players = [];

  InitialData() {
    Player tBenfield = Player.initial("Tom Benfield", 7.5, "DEF");
    Player nCallanan = Player.initial("Noah Callanan", 22.5, "MID");
    Player jCunneen = Player.initial("James Cunneen", 7.5, "DEF");
    Player jCutcliffe = Player.initial("Josh Cutcliffe", 17.5, "MID");
    Player tDavid = Player.initial("Tom David", 15, "MID");
    Player cJames = Player.initial("Cameron James", 37.5, "FWD");
    Player lJames = Player.initial("Lachlan James", 17.5, "MID");
    Player jLozell = Player.initial("Jamie Lozell", 7.5, "DEF");
    Player bWalkerden = Player.initial("BJ Walkerden", 10, "MID");
    Player jNewton = Player.initial("Jonah Newton", 12.5, "DEF");
    Player cMoss = Player.initial("Cameron Moss", 22.5, "MID");
    Player cKennedy = Player.initial("Charlie Kennedy", 20, "DEF");
    Player wLudmon = Player.initial("Will Ludmon", 10, "DEF");
    Player hVial = Player.initial("Hadrian Vial", 10, "MID");
    Player aWalia = Player.initial("Alvin Walia", 30, "MID");

    players.addAll([
      tBenfield,
      nCallanan,
      jCunneen,
      jCutcliffe,
      tDavid,
      cJames,
      lJames,
      jLozell,
      bWalkerden,
      jNewton,
      cMoss,
      cKennedy,
      wLudmon,
      hVial,
      aWalia,
    ]);

    //addAll Players to DB DO NOT RUN AGAIN
    FirebaseCore rFirebase = FirebaseCore();


    // rFirebase.getPlayers().then((players) => players.forEach((element) {
    //       print(element.name);
    //     })).onError((error, stackTrace) => print(error));
  }
}
