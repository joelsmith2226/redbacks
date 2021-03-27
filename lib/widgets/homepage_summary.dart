import 'package:flutter/material.dart';

class HomepageSummary extends StatefulWidget {
  Widget body;
  HomepageSummary({this.body});

  @override
  _HomepageSummaryState createState() => _HomepageSummaryState();
}

class _HomepageSummaryState extends State<HomepageSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(bottom: 50),
      color: Colors.black.withAlpha(100),
      child: widget.body,
      alignment: Alignment.center,
    );
  }
}
