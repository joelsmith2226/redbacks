import 'package:flutter/material.dart';

class PatchMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(240),
      alignment: Alignment.center,
      margin: EdgeInsets.all(60),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Patch Underway", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          Image.asset(
            'assets/spiderPatchmode.png',
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          Text("A patch is currently underway. The app will be available shortly! Please check in later!"),
        ]
      )
    );
  }
}
