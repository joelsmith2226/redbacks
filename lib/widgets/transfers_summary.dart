import 'package:flutter/material.dart';
import 'package:redbacks/widgets/homepage_summary.dart';

class TransfersSummary extends StatefulWidget {
  @override
  _TransfersSummaryState createState() => _TransfersSummaryState();
}

class _TransfersSummaryState extends State<TransfersSummary> {
  @override
  Widget build(BuildContext context) {
    return HomepageSummary(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TransfersSummaryContainer("Free Transfers", "1"),
          TransfersSummaryContainer("Wild Card", "Available"),
          TransfersSummaryContainer("Cost", "0"),
          TransfersSummaryContainer("Bank", "\$1.2m"),
        ],
      )
    );
  }

  Widget TransfersSummaryContainer(String category, String value){
    return Container(
      width: MediaQuery.of(context).size.width*0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black38.withAlpha(170),
      ),
      margin: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.2,
            child: Text(category, style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
            color: Colors.black.withAlpha(50),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.2,
            child: Text(value, style: TextStyle(fontSize: 12, color: Colors.white),textAlign: TextAlign.center),
            color: Theme.of(context).primaryColor.withAlpha(150),
          )
        ],
      )
    );
  }
}
