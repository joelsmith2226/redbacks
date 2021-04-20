import 'package:redbacks/models/player.dart';

import 'rFirebase/firebaseCore.dart';

class InitialData {
  List<Player> players = [];

  InitialData() {
    Player tBenfield = Player.initial("Tom Benfield", 7.5, "DEF", 'TB.png');
    Player nCallanan = Player.initial("Noah Callanan", 22.5, "MID", 'NC.png');
    Player jCunneen = Player.initial("James Cunneen", 7.5, "DEF", 'JC2.png');
    Player jCutcliffe = Player.initial("Josh Cutcliffe", 17.5, "MID", 'JC.png');
    Player tDavid = Player.initial("Tom David", 15, "MID", 'TD.png');
    Player cJames = Player.initial("Cameron James", 37.5, "FWD", 'CJ.png');
    Player lJames = Player.initial("Lachlan James", 17.5, "MID", 'LJ.png');
    Player jLozell = Player.initial("Jamie Lozell", 7.5, "DEF", 'JL.png');
    Player bWalkerden = Player.initial("BJ Walkerden", 10, "MID", 'BW.png');
    Player jNewton = Player.initial("Jonah Newton", 12.5, "DEF", 'JN.png');
    Player cMoss = Player.initial("Cameron Moss", 22.5, "MID", 'CM.png');
    Player cKennedy = Player.initial("Charlie Kennedy", 20, "DEF", 'CK.png');
    Player wLudmon = Player.initial("Will Ludmon", 10, "DEF", 'WL.png');
    Player hVial = Player.initial("Hadrian Vial", 10, "MID", 'HV.png');
    Player aWalia = Player.initial("Alvin Walia", 30, "MID", 'AW.png');

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
    FirebaseCore().addAllPlayers(players);

    // rFirebase.getPlayers().then((players) => players.forEach((element) {
    //       print(element.name);
    //     })).onError((error, stackTrace) => print(error));
  }
}
