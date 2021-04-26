import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/rfl_chip.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class ChipsContainer extends StatefulWidget {
  List<RFLChip> chips;

  ChipsContainer({this.chips});

  @override
  _ChipsContainerState createState() => _ChipsContainerState();
}

class _ChipsContainerState extends State<ChipsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.white.withAlpha(200),
      child: Column(
        children: [
          _ChipSummaryHeading(context),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.6,
              child: ListView.builder(
                itemCount: this.widget.chips.length - 1,
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChipsContainerRow(widget.chips[index], context);
                },
              ),
            ),
          ),
          Divider(),
          _ftHitSummary(),
        ],
      ),
    );
  }

  Widget _ChipSummaryHeading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      height: 30,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Chip   ",
            style: GoogleFonts.merriweatherSans(),
            children: [TextSpan(text: "Availability")],
          ),
        ),
      ),
    );
  }

  Widget ChipsContainerRow(RFLChip c, BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        // color: Theme.of(context).primaryColor,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all()),
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              width: 100,
              child: Text(
                c.name,
                textAlign: TextAlign.center,
              )),
          MaterialButton(
            child: Text("N/A"),
                // ? (c.active ? 'Active' : 'Inactive') todo
                // : 'Unavailable'),
            color: Colors.grey,//c.active ? Colors.green : Colors.red,
            onPressed: () => setState(() {
             // c.active = !c.active;
            }),
          )
        ]));
  }

  Widget _ftHitSummary() {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    int freshHits = user.hits;
    if (user.originalModels != null) {
      freshHits = (user.hits - user.originalModels.hits) * 4;
    }

    return Container(
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all()),
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text('Free Transfers:')),
              Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                      '${user.unlimitedTransfersActive() || user.freeTransfers == UNLIMITED ? UNLIMITED_SYMBOL : user.freeTransfers}'))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text('Cost: ')),
                Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                        '${user.unlimitedTransfersActive() ? 0 : freshHits}pts')),
              ],
            )
          ]),
    );
  }
}
