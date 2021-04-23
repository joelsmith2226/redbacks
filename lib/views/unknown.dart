import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/globals/router.dart';

class UnknownView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unknown", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(20),
          color: Colors.white70.withAlpha(240),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Landed somewhere strange... Go back?'),
              MaterialButton(
                child: Text("Back", style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () =>
                    Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
