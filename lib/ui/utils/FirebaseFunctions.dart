import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dinefine_app/main.dart';
import 'package:dinefine_app/model/MenuItem.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/model/restaurant.dart';

import '../../constants.dart';
import 'RestaurantInfo.dart';

class FirebaseFunctions {
  final db = Firestore.instance;
  final collectionRef = Firestore.instance.collection(Constants.RESTAURANTS);
  final userCollectionRef = Firestore.instance.collection(Constants.USERS);

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
    booked.add(MyAppState.currentRes.name);
    booked.add(time);
    booked.add(selectedSeats);
    print("booked is: " + MyAppState.currentUser.booked.toString());
    userCollectionRef
        .document(MyAppState.currentUser.userID)
        .updateData({Constants.BOOKEDSEATS: booked.toString()});
    MyAppState.currentUser.booked = booked;
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
        print('in getMenu(), each snapshot doc is: ' + el.metadata.toString());

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

  Future<void> updateCustomers(Restaurant res) async {
    final customer = collectionRef
        .document(res.id)
        .collection('Customers')
        .document(MyAppState.currentUser.userID);
    final snapshot = await customer.get();
    if (snapshot != null) {
      //customer has ordered before because his document exists
      customer.updateData({
        "numTimesVisited": FieldValue.increment(1),
      });
    } else {
      customer.setData({
        "numTimesVisited": 1,
      });
    }
    collectionRef
        .document(res.id)
        .updateData({"numOrders": FieldValue.increment(1)});
  }

  Future<double> getSatisfactionValue(String id) async {
    //get total customers = totalCust
    //for each customer, check how many times they have revisited.
    //If each numVisits = 1 --> no revists
    //If each numVisits 2 or 3  --> add 1 to numRevisits
    //If each numVisits > 3 --> increment extraVisits
    //satVal  = numVisited/totalCust * 100
    //satVal * 1.03 * extraVisits (more weightage)
    //Floor satVal at 100 show it can be shown as percentage dial
    int totalCust = 0;
    int numRevisited = 0;
    int extraVisits = 0;
    double satVal;
    await collectionRef
        .document(id)
        .collection('Customers')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((el) {
        print("Customer data in getSatVal: " + el.data.toString());
        int visits = el.data["numTimesVisited"];
        totalCust++;

        if (visits == 2 || visits == 3) {
          numRevisited++;
        } else if (visits > 3) {
          numRevisited++;
          extraVisits++;
        }
      });
    });
    // print(totalCust);
    // print(numRevisited);
    satVal = (numRevisited / totalCust) * 100;
    print("satVal before extra: " + satVal.toString());
    satVal += extraVisits * 1.03;
    if (satVal > 100) {
      satVal = 100;
    }
    print("satVal: " + satVal.toString());
    return satVal;
  }

  Future<void> updateOrderList(List orderList) async {
    await userCollectionRef
        .document(MyAppState.currentUser.userID)
        .updateData({Constants.ORDERLIST: orderList.toString()});
    await collectionRef
        .document(MyAppState.currentRes.id)
        .collection('Customers')
        .document(MyAppState.currentUser.userID)
        .updateData({Constants.ORDERLIST: orderList.toString()});
  }

  //ignore this
  updateFirebase(List ls) async {
    for (var el in RestaurantInfo.info) {
      print(el);
      var res = await collectionRef.document(el[0]);
      res.setData({
        'name': el[1],
        'qTime': el[2],
        'numOrders': el[3],
        'description': el[4]
      });
    }
  }

  //ignore this
  updateSeatsForM(List ls) async {
    var res = await collectionRef
        .document('DowijYsMAGyhOgYxTrT0')
        .collection('Seats');
    Map<String, dynamic> seatMap = {};
    for (int j = 0; j < 50; j++) {
      seatMap.addAll({("a" + j.toString()): "false"});
    }
    for (int i = 0; i < ls.length; i++) {
      res.document(ls[i]).setData(seatMap);
    }
  }
}
