import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/transfer.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/chips_container.dart';
import 'package:redbacks/widgets/transfer_list.dart';

class ConfirmTransfersView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    print("hmm");
    List<Transfer> pendings = user.currentTransfersInProgress();
    print('hi there');

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Transfer list
                TransferList(transferList: pendings),
                // chip options
                ChipsContainer(chips: user.chips),
                // confirm
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "Confirm Transfers",
          style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      persistentFooterButtons: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                child: Text("Back"),
                onPressed: () => Navigator.pop(context),
                color: Colors.black,
              ),
              _confirmButton(user, context)
            ],
          ),
        ),
      ],
    );
  }

  MaterialButton _confirmButton(LoggedInUser user, BuildContext context) {
    return MaterialButton(
      child: Text("Confirm"),
      color: Color(0xFF008000),
      onPressed: () async {
        String route = user.signingUp ? Routes.Login : Routes.Home;
        user.confirmTransfersButtonPressed();
        if (route == Routes.Home) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pushReplacementNamed(context, Routes.Login);
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("All signed up! Please login with your details!")));
        }
        return;
      },
    );
  }
}
