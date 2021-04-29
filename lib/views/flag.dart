import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/flag.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/admin/edit_flag.dart';
import 'package:redbacks/widgets/player/player_carousel.dart';

class FlagView extends StatefulWidget {
  @override
  _FlagViewState createState() => _FlagViewState();
}

class _FlagViewState extends State<FlagView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currIndex;

  @override
  void initState() {
    _currIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    Function callback = (index) => setState((){this._currIndex = index;});
    print(this._currIndex);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Manage flags", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
          PlayerCarousel.fromPlayerDB(
              playerDB: user.playerDB, currIndex: _currIndex, callback: callback),
              SizedBox(height: 20),
              EditFlag(
              flag: user.playerDB[_currIndex].flag == null
                  ? Flag.empty()
                  : user.playerDB[_currIndex].flag,
              player: user.playerDB[_currIndex]
          ),
        ]),
      ),
    );
  }
}
