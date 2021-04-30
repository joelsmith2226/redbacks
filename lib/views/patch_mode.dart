import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/login_form.dart';
import 'package:redbacks/widgets/patch_mode.dart';

class PatchModeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patching", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
        actions: [],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        PatchMode(),
      ]),
    );
  }
}
