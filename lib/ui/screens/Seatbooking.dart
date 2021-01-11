import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/model/restaurant.dart';
import 'package:dinefine_app/ui/Widgets/LabeledCheckBox.dart';
import 'package:dinefine_app/ui/screens/HomeScreen.dart';
import 'package:dinefine_app/ui/utils/FirebaseFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Seatbooking extends StatefulWidget {
  final User user;
  final Restaurant res;
  Seatbooking({Key key, @required this.user, @required this.res})
      : super(key: key);

  @override
  _SeatbookingState createState() => _SeatbookingState();
}

class _SeatbookingState extends State<Seatbooking> {
  String restId = 'NqHOLN9BF7sIur7NKZEb';
  List seatList = List();
  var arr = ['1', '2', '3'];
  bool isSelected = true;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              // onPressed: () {
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => HomeScreen(
              //                 user: widget.user,
              //               )),
              //       (Route<dynamic> route) => false);
              // },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    for (String el in widget.res.seatMap.keys) {
      if (widget.res.seatMap[el] == 'false') {
        seatList.add(el);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          height: 600,
          child: ListView.builder(
            itemCount: seatList.length,
            itemBuilder: (context, index) {
              var el = seatList[index];
              return LabeledCheckbox(
                label: el,
                value: widget.res.seatMap[el] == 'false' ? false : true,
                padding: EdgeInsets.all(8),
                onChanged: (bool newValue) {
                  print(widget.res.seatMap);
                  setState(() {
                    widget.res.seatMap.update(
                        el,
                        (value) =>
                            value == 'false' ? widget.user.userID : 'false');
                  });
                },
              );
            },
          ),
        ),
        RaisedButton(
          onPressed: () {
            FirebaseFunctions()
                .updateSeats(widget.res, widget.res.seatMap, widget.user)
                .then((value) {
              setState(() {
                widget.user.booked = value;
              });
            }).whenComplete(() => _showMyDialog());
          },
          child: Text('Finish Payment'),
        ),
        Image.asset('assets/images/facebook_logo.png')
      ],
    ));
  }
}
