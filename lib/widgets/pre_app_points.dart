import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/points_summary.dart';

class PreAppPoints extends StatelessWidget {
  Function callback;
  int preAppPoints;

  PreAppPoints({@required this.callback, this.preAppPoints});

  @override
  Widget build(BuildContext context) {
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
                "${this.preAppPoints}",
                style: TextStyle(
                    fontSize: 50,
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
