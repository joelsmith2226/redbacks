import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/models/rfl_chip.dart';
import 'package:redbacks/widgets/confirmed_transfer_summary.dart';

class ChipsContainer extends StatelessWidget {
  List<RFLChip> chips;
  ChipsContainer({this.chips});

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
                itemCount: this.chips.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChipsContainerRow(chips[index], context);
                },
              ),
            ),
          ),
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
            children: [
              TextSpan(text: "Availability")
            ],
          ),
        ),
      ),
    );
  }

  Widget ChipsContainerRow(RFLChip c, BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      height: 30,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${c.name}",
            style: GoogleFonts.merriweatherSans(),
            children: [
              TextSpan(text: "Player Incoming")
            ],
          ),
        ),
      ),
    );
  }
}
