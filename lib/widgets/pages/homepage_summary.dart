import 'package:flutter/material.dart';

class HomepageSummary extends StatefulWidget {
  Widget body;
  double bottomMargin;
  HomepageSummary({this.body, this.bottomMargin=20});

  @override
  _HomepageSummaryState createState() => _HomepageSummaryState();
}

class _HomepageSummaryState extends State<HomepageSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.07,
      margin: EdgeInsets.only(bottom: widget.bottomMargin),
      color: Colors.black.withAlpha(100),
      child: widget.body,
      alignment: Alignment.center,
    );
  }
}
