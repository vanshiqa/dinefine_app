import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinefine_app/main.dart';
import 'package:dinefine_app/model/MenuItem.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/model/restaurant.dart';
import 'package:dinefine_app/ui/utils/Authenticate.dart';
import 'package:flutter/cupertino.dart';

import '../../constants.dart';

class FirebaseFunctions {
  final db = Firestore.instance;
  final collectionRef = Firestore.instance.collection(Constants.RESTAURANTS);

  Future<List<dynamic>> updateSeats(Restaurant res,
      Map<String, dynamic> selectedSeats, User user, String time) async {
    print(res.id);
    var retArr = [];
    await collectionRef
        .document(res.id)
        .collection('Seats')
        .document(time)
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

    //update user's booked variable
    List booked = new List();
    booked.add(time);
    booked.add(selectedSeats);
    MyAppState.currentUser.booked = booked;
    print("booked is: " + MyAppState.currentUser.booked.toString());
    return retArr;
  }

  Future<List<MenuItem>> getMenu(Restaurant res) async {
    List<MenuItem> menu = [];
    await collectionRef
        .document(res.id)
        .collection('Menu')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      // print(snapshot.toString());
      snapshot.documents.forEach((el) {
        print('in getMenu(), each snapshot doc is: ' + el.toString());
        MenuItem item = new MenuItem();
        item.id = el.documentID;
        item.name = el.data['name'];
        item.price = el.data['price'].toDouble();
        item.popularity = el.data['numOrders'];
        print('item is: ' + item.toString());
        menu.add(item);
        print('In firebasefunction, menu is: ' + menu.toString());
        //todo: name printed after initState of restaurant.
      });
    });
    return menu;
  }
}
