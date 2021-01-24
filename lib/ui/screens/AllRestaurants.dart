import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/model/restaurant.dart';
import 'package:dinefine_app/ui/screens/Seatbooking.dart';
import 'package:dinefine_app/ui/utils/FirebaseFunctions.dart';
import 'package:dinefine_app/ui/utils/RestaurantInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constants.dart';
import '../../constants.dart';
import '../../main.dart';
import 'RestaurantScreen.dart';

class AllRestaurants extends StatefulWidget {
  final User user;
  AllRestaurants({Key key, @required this.user}) : super(key: key);

  @override
  _AllRestaurantsState createState() => _AllRestaurantsState();
}

class _AllRestaurantsState extends State<AllRestaurants> {
  final db = Firestore.instance;
  final collectionRef = Firestore.instance.collection(Constants.RESTAURANTS);
  String name1 = '';
  var restIds = RestaurantInfo.RESIDS;
  var restArr = [];

  int numOrders1;

  Future<Restaurant> getRestaurant(String id) async {
    String name = '';
    double satVal = 0;
    Restaurant res =
        new Restaurant(); //constructor function --> creates new object
    res.seatMap = Map<String, Map<String, dynamic>>();
    FirebaseFunctions().getSatisfactionValue(id).then((value) {
      res.satVal = value;
    });
    await collectionRef.document(id).get().then((DocumentSnapshot document) {
      res.name = document.data['name'];
      res.numOrders = document.data['numOrders'];
      res.id = id;
      res.imgUrl = document.data['imgUrl'];
      res.qTime = document.data['qTime'];
      res.description = document.data['description'];
      //print(res.numOrders);
    });

    await collectionRef
        .document(id)
        .collection('Seats')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        print("seats are " +
            element.documentID.toString() +
            " : " +
            element.data.toString());
        res.seatMap.putIfAbsent(element.documentID, () => element.data);
      });
      print("final seat map: " + res.seatMap.toString());
    });

    return res; //final return value of function
  }

  void updateSeats(Restaurant res) async {
    print(res.id);
    await collectionRef
        .document(res.id)
        .collection('Seats')
        .document('seats')
        .updateData({"a3": true});
  }

  @override
  void initState() {
    restArr.clear();
    for (String el in restIds) {
      getRestaurant(el).then((value) {
        setState(() {
          restArr.add(value);
        });
      });
    }
    print(restArr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainYellow,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Text(
              "All Restaurants:",
              style: Constants.HEADING,
            ),
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: restArr.length,
                itemBuilder: (context, index) {
                  Restaurant res = restArr[index];
                  return FlatButton(
                    onPressed: () {
                      print('selected restaurant button pressed');
                      MyAppState.currentRes = res;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantScreen()));
                    },
                    child: ListTile(
                      title: Text(res.name),
                      trailing: Text(res.numOrders.toString()),
                      subtitle: Text(res.description),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
