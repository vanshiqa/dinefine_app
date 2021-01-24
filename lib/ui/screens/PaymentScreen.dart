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
        children: [
          Text("Payment Screen"),
          RaisedButton(
            child: Text("Go to Home Screen"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(user: MyAppState.currentUser)));
            },
          ),
          RaisedButton(
              child: Text("Update Firebase"),
              onPressed: () {
                FirebaseFunctions().updateFirebase(RestaurantInfo.info);
              })
        ],
      )),
    );
  }
}
