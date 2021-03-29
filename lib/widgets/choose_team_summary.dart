import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/widgets/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

class ChooseTeamSummary extends StatefulWidget {
  @override
  _ChooseTeamSummaryState createState() => _ChooseTeamSummaryState();
}

class _ChooseTeamSummaryState extends State<ChooseTeamSummary> {
  @override
  Widget build(BuildContext context) {
    var style = GoogleFonts.merriweatherSans();

    return HomepageSummary(
      body: SummaryContainer(
          body: ChooseTeamSummaryContainer("Budget Left:", "\$100.0m",)),
    );
  }


  Widget ChooseTeamSummaryContainer(String category, String value){
    return SummaryContainer(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.2,
              child: Text(category, style: TextStyle(fontSize: 11, color: Colors.white), textAlign: TextAlign.center,),
              color: Colors.black.withAlpha(50),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.2,
              child: Text(value, style: TextStyle(fontSize: 11, color: Colors.white),textAlign: TextAlign.center),
              color: Theme.of(context).primaryColor.withAlpha(150),
            )
          ],
        )
    );
  }
}
