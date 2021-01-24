import 'package:dinefine_app/constants.dart';
import 'package:dinefine_app/model/MenuItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../main.dart';

class AnalysisDisplay extends StatelessWidget {
  const AnalysisDisplay({
    Key key,
    @required this.topThree,
    @required this.topPrice,
  }) : super(key: key);

  final List<MenuItem> topThree;
  final List<MenuItem> topPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Most Ordered",
                  style: TextStyle(
                      fontSize: 25,
                      color: Constants.mainYellow,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 100,
                  width: 150,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      MenuItem el = topThree[index];
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (index + 1).toString() + '. ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(el.name),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Text("Highest-Priced",
                    style: TextStyle(
                        fontSize: 25,
                        color: Constants.mainYellow,
                        fontWeight: FontWeight.bold)),
                Container(
                  height: 100,
                  width: 150,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      MenuItem el = topPrice[index];
                      return Container(
                        child: Row(
                          children: [
                            Text(el.name + " - \$",
                                style: TextStyle(fontSize: 14)),
                            Text(
                              el.price.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Text(
              "   Number of customers: " +
                  MyAppState.currentRes.numOrders.toString(),
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Column(
          children: [
            CircularPercentIndicator(
              radius: 140.0,
              lineWidth: 10.0,
              percent: MyAppState.currentRes.satVal / 100,
              center: Text(
                MyAppState.currentRes.satVal.toString(),
                style: TextStyle(fontSize: 25),
              ),
              progressColor: Constants.mainYellow,
            ),
            Text("Customer Satisfaction: "),
          ],
        )
      ],
    );
  }
}
