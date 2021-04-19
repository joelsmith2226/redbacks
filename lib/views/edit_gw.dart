import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/widgets/gameweek_form.dart';

class EditGWView extends StatefulWidget {
  @override
  _EditGWViewState createState() => _EditGWViewState();
}

class _EditGWViewState extends State<EditGWView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Gameweek GW;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (GW == null) {
      GW = ModalRoute.of(context).settings.arguments as Gameweek;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit GW", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: GameweekForm(loadedGW: GW),
      ),
    );
  }
}
