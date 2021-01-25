import 'package:dinefine_app/main.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/model/restaurant.dart';
import 'package:dinefine_app/ui/Widgets/LabeledCheckBox.dart';

import 'package:dinefine_app/ui/screens/PaymentScreen.dart';
import 'package:dinefine_app/ui/utils/FirebaseFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Seatbooking extends StatefulWidget {
  Seatbooking({Key key}) : super(key: key);

  @override
  _SeatbookingState createState() => _SeatbookingState();
}

class _SeatbookingState extends State<Seatbooking> {
  List seatList = List();
  bool isSelected = true;
  User user = MyAppState.currentUser;
  Restaurant res = MyAppState.currentRes;
  TimeOfDay selectedTime;
  Map<String, dynamic> selectedSeatMap;
  List userBooked = [];

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Is your booking correct?'),
                Text('Proceed to payment'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Make payment'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    setState(() {
      selectedTime = TimeOfDay.fromDateTime(DateTime(1, 2, 1, 9, 0));
      print(selectedTime);
      selectedSeatMap = res.seatMap[selectedTime
          .toString()
          .replaceAll("TimeOfDay(", "")
          .replaceAll(")", "")];
    });
    for (String el in selectedSeatMap.keys) {
      if (selectedSeatMap[el] == 'false') {
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
          height: 30,
        ),
        RaisedButton(
          child: Text('Select a Time'),
          color: Constants.mainYellow,
          onPressed: () {
            timingPopUp();
            print(selectedTime);
          },
        ),
        Text(
          selectedTime
              .toString()
              .replaceAll("TimeOfDay(", "")
              .replaceAll(")", ""),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Image.asset(
          'assets/images/seat_layout.png',
          width: 610,
        ),
        Container(
          height: 250,
          child: Scrollbar(
            isAlwaysShown: true,
            controller: new ScrollController(),
            child: ListView.builder(
              itemCount: seatList.length,
              itemBuilder: (context, index) {
                var el = seatList[index];
                return LabeledCheckbox(
                  label: el,
                  value: selectedSeatMap[el] == 'false' ? false : true,
                  padding: EdgeInsets.all(8),
                  onChanged: (bool newValue) {
                    print(selectedSeatMap);
                    setState(() {
                      selectedSeatMap.update(el,
                          (value) => value == 'false' ? user.userID : 'false');
                    });
                  },
                );
              },
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            _showMyDialog();
            FirebaseFunctions()
                .updateSeats(
                    res,
                    selectedSeatMap,
                    user,
                    selectedTime
                        .toString()
                        .replaceAll("TimeOfDay(", "")
                        .replaceAll(")", ""))
                .then((value) {});
          },
          child: Text('Finish Payment'),
          color: Colors.yellow.shade100,
        ),
      ],
    ));
  }

  Future<void> timingPopUp() async {
    TimeOfDay picked =
        await showTimePicker(context: this.context, initialTime: selectedTime);
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        selectedTime.replacing(minute: 00);
        selectedSeatMap = res.seatMap[selectedTime
            .toString()
            .replaceAll("TimeOfDay(", "")
            .replaceAll(")", "")];
      });
      seatList.clear();
      print(selectedSeatMap.keys);
      for (String el in selectedSeatMap.keys) {
        if (selectedSeatMap[el] == 'false') {
          seatList.add(el);
        }
      }
      print(seatList);
      print('Selected time is: ' +
          selectedTime
              .toString()
              .replaceRange(0, 10, '')
              .replaceFirst(")", ""));
      //TODO: show seat timings according to this time.

    }
  }
}
