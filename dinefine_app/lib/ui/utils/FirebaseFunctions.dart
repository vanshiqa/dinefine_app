import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/model/restaurant.dart';
import 'package:dinefine_app/ui/services/Authenticate.dart';
import 'package:flutter/cupertino.dart';

import '../../constants.dart';

class FirebaseFunctions {
  final db = Firestore.instance;
  final collectionRef = Firestore.instance.collection(Constants.RESTAURANTS);

  Future<List<dynamic>> updateSeats(
      Restaurant res, Map<String, dynamic> selectedSeats, User user) async {
    print(res.id);
    var retArr = [];
    await collectionRef
        .document(res.id)
        .collection('Seats')
        .document('seats')
        .updateData(selectedSeats)
        .then((value) {
      for (String element in selectedSeats.keys) {
        String val = selectedSeats[element];
        String currUID = user.userID;
        if (val == currUID) {
          retArr.add(element);
        }
      }
    });
    return retArr;
  }
}
