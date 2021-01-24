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
              child: Text(user.firstName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.phoneNumber),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 23, 305, 12),
              child: Text('Bookings'),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                user.booked.toString() == '[]'
                    ? 'No bookings yet!'
                    : MyAppState.currentUser.booked[2].toString(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String bookedToString(List booked) {
    return booked[0];
  }
}
