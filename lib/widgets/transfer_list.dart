import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/models/transfer.dart';
import 'package:redbacks/widgets/confirmed_transfer_summary.dart';

class TransferList extends StatelessWidget {
  List<Transfer> transferList;

  TransferList({this.transferList});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.white.withAlpha(200),
      child: Column(
        children: [
          _transferSummaryHeading(context),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.6,
              child: ListView.builder(
                itemCount: this.transferList.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConfirmedTransferSummary(
                      transfer: this.transferList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transferSummaryHeading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      height: 30,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Player Outgoing   ",
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
