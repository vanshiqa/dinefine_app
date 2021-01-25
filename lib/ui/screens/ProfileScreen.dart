import 'package:dinefine_app/model/MenuItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../model/User.dart';
import '../utils/helper.dart';
import 'AllRestaurants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User user = MyAppState.currentUser;
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            displayCircleImage(user.profilePictureURL, 125, false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Name: " + user.firstName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Email: " + user.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Phone Number: " + user.phoneNumber),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 23, 305, 12),
              child: Text(
                'Bookings:',
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                user.booked.toString() == '[]'
                    ? 'No bookings yet!'
                    : "Restaurant: " +
                        user.booked[0].toString() +
                        "\nTime: " +
                        user.booked[1] +
                        "\n Seats: " +
                        getSeats(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                user.orderList.toString() == '[]'
                    ? 'No order yet!'
                    : "Order: " + getOrder(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getSeats() {
    Map map = MyAppState.currentUser.booked[2];
    List ls = [];
    map.forEach((key, value) {
      if (value == MyAppState.currentUser.userID) {
        ls.add(key);
      }
    });
    return ls.toString();
  }

  String getOrder() {
    List ls = MyAppState.currentUser.orderList;
    List orderLs = new List();
    for (MenuItem el in ls) {
      orderLs.add(el.name);
    }
    return orderLs.toString();
  }
}
