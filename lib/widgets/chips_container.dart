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
                itemCount: this.widget.chips.length,
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
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        height: 30,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(width: 100, child: Text(c.name, textAlign: TextAlign.center,)),
          MaterialButton(
            child: Text(c.available ? (c.active ? 'Active' : 'Inactive') : 'Unavailable'),
            color: c.active ? Colors.green : Colors.red,
            onPressed: () => setState(() {
              c.active = !c.active;
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

    return Column(
      children:
        [
          Row(
            children: [
              Container(
                width: 100,
                child: Text('Free Transfers:')
              ),
              Container(
                  width: 100,
                  child: Text('${user.unlimitedTransfersActive() ? UNLIMITED_SYMBOL : user.freeTransfers}')
              )
            ]
          ),
          Row(
            children: [
              Container(
                  width: 100,
                  child: Text('Cost: ')
              ),
              Container(
                  width: 100,
                  child: Text('${user.unlimitedTransfersActive() ? 0 : freshHits}pts')
              ),
            ],
          )
        ]
    );
  }
}
