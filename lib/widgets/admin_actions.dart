import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/form_widgets.dart';

class AdminActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FormWidgets forms = FormWidgets();
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                setCurrentGW(forms, user, context),
                deadlineBtn(context, user)
              ],
            )
          ],
        ),
    );
  }

  Widget deadlineBtn(context, LoggedInUser user) {
    return MaterialButton(
        child: Text(
          "Deadline for curr gw",
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          RedbacksFirebase().deadlineButton(user.currGW);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("DEADLINE ACTIVATED"),
          ));
        });
  }

  Widget setCurrentGW(FormWidgets forms, LoggedInUser user, BuildContext context){
    return Container(
      color: Colors.white,
      child: forms.NumberForm(user.currGW, "curr-gw", 'Current Gameweek', onChanged: (val) => null,),
    );
  }
}
