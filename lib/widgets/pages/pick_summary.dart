import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

import '../../globals/rFirebase/firebaseUsers.dart';

class PickSummary extends StatefulWidget {
  Function summaryDialogFn;

  PickSummary({this.summaryDialogFn});

  @override
  _PickSummaryState createState() => _PickSummaryState();
}

class _PickSummaryState extends State<PickSummary> {
  @override
  Widget build(BuildContext context) {
    return HomepageSummary(
        body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [TripCapContainer(), DeadlineContainer()]
        ));
  }

  Widget TripCapContainer() {
    return SummaryContainer(
        onPress: widget.summaryDialogFn,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.2,
              child: Text("Triple Captain",
                style: TextStyle(fontSize: 11, color: Colors.white),
                textAlign: TextAlign.center,),
              color: Colors.black.withAlpha(50),
            ),
            Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.2,
                child: Text(_containerText(),
                    style: TextStyle(fontSize: 11, color: Colors.white),
                    textAlign: TextAlign.center),
                color: _containerColor(),
            )
          ],
        )
    );
  }

  Widget DeadlineContainer() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);

    return SummaryContainer(
        onPress: widget.summaryDialogFn,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.2,
              child: Text(
                "Deadline", style: TextStyle(fontSize: 11, color: Colors.white),
                textAlign: TextAlign.center,),
              color: Colors.black.withAlpha(50),
            ),
            Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.2,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text("Saturday ${user.deadlineTime}",
                      style: TextStyle(fontSize: 11, color: Colors.white),
                      textAlign: TextAlign.center),),
                color: Colors.red.withAlpha(200) //_containerColor(),
            )
          ],
        )
    );
  }

  String _containerText() {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    if (user.chips[2].active) {
      return "Active";
    } else if (user.anyChipsActive()) {
      return "Not Available";
    } else if (!user.chips[2].available) {
      return "Used";
    } else {
      return "Available";
    }
  }

  Color _containerColor() {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    if (user.chips[2].active) {
      return Colors.green;
    } else if (!user.chips[2].available || user.anyChipsActive()) {
      return Colors.grey;
    } else {
      return DEFAULT_COLOR.withAlpha(150);
    }
  }
}
