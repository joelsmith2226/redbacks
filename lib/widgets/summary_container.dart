import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  Widget body;

  SummaryContainer({this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black38.withAlpha(170),
      ),
      margin: EdgeInsets.all(3),
      child: body,
    );
  }
}
