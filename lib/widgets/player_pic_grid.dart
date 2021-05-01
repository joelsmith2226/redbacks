import 'package:flutter/material.dart';

class PlayerPicGrid extends StatelessWidget {
  List<String> playerAssets = [
    "assets/profilepics/AW.png",
    "assets/profilepics/BW.png",
    "assets/profilepics/CJ.png",
    "assets/profilepics/CK.png",
    "assets/profilepics/CM.png",
    "assets/profilepics/HV.png",
    "assets/profilepics/JC.png",
    "assets/profilepics/JC2.png",
    "assets/profilepics/JL.png",
    "assets/profilepics/JN.png",
    "assets/profilepics/LJ.png",
    "assets/profilepics/NC.png",
    "assets/profilepics/TB.png",
    "assets/profilepics/TD.png",
    "assets/profilepics/WL.png",
  ];

  @override
  Widget build(BuildContext context) {
    playerAssets.shuffle();

    return Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.4,
        child: GridView.count(
          crossAxisCount: 5,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: playerAssets
              .map((p) => ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.asset(
                      p,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ))
              .toList(),
        ));
  }
}
