import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/points_summary.dart';

class PreAppPoints extends StatelessWidget {
  Function callback;

  PreAppPoints({@required this.callback});

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PointsSummary(null, 0, (val) => this.callback(val)),
          Container(
            margin: EdgeInsets.all(50),
            color: Colors.white,
            height: MediaQuery.of(context).size.height*0.4,
            padding: EdgeInsets.all(15),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Text(
                "Points acquired before app launch: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "${user.preAppPoints}",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              Text(
                "Don't worry if this says 0, it will just take some time to transition pre-existing points",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
        ],
      ),
    );
  }
}
