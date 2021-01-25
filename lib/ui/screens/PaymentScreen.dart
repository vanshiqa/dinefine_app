import 'package:dinefine_app/constants.dart';
import 'package:dinefine_app/main.dart';
import 'package:dinefine_app/ui/screens/HomeScreen.dart';
import 'package:dinefine_app/ui/utils/FirebaseFunctions.dart';
import 'package:dinefine_app/ui/utils/RestaurantInfo.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Payment screen");
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Payment Screen",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          RaisedButton(
            child: Text(
              "Return to Home Screen",
              style: TextStyle(fontSize: 16),
            ),
            color: Constants.mainYellow,
            elevation: 2,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(user: MyAppState.currentUser)));
            },
          ),
          // RaisedButton(
          //     child: Text("Update Firebase"),
          //     onPressed: () {
          //       FirebaseFunctions().updateFirebase(RestaurantInfo.info);
          //       FirebaseFunctions()
          //           .updateSeatsForM(RestaurantInfo.MseatsTimings);
          //     })
        ],
      )),
    );
  }
}
