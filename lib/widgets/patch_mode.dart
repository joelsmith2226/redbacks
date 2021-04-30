import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class PatchMode extends StatefulWidget {
  @override
  _PatchModeState createState() => _PatchModeState();
}

class _PatchModeState extends State<PatchMode> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white.withAlpha(240),
        alignment: Alignment.center,
        margin: EdgeInsets.all(60),
        padding: EdgeInsets.all(20),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            "Patch Underway",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            'assets/spiderPatchmode.png',
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          Text(
              "A patch is currently underway. The app will be available shortly! Please check in later!"),
          checkIfStillPatching(context),
          loading ? CircularProgressIndicator() : Container(),
        ]));
  }

  Widget checkIfStillPatching(BuildContext context) {
    return MaterialButton(
      color: Color(0xFF6200EE),
      textColor: Colors.white,
      onPressed: () async {
        // pull from admin
        LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
        setState(() {
          loading = true;
        });
        await FirebaseCore().getAdminInfo(user);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(user.patchMode
                ? "Still patching, RFL will be back shortly!"
                : "All patched, ready to sign in!")));
        if (!user.patchMode){
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.Root, (route) => false);
        }
        setState(() {
          loading = false;
        });
      },
      child: Text('Check if still patching'),
    );
  }
}
