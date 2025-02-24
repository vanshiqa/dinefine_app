import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinefine_app/model/MenuItem.dart';
import 'package:dinefine_app/ui/Widgets/AnalysisDisplay.dart';
import 'package:dinefine_app/ui/Widgets/MenuDisplay.dart';
import 'package:dinefine_app/ui/screens/Seatbooking.dart';
import 'package:dinefine_app/ui/utils/DateTimePicker.dart';
import 'package:dinefine_app/ui/utils/FirebaseFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../model/User.dart';
import 'PaymentScreen.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  User user = MyAppState.currentUser;
  List<MenuItem> menu = [];
  List<MenuItem> topThree = [];
  List<MenuItem> topPrice = [];
  bool showAnalysis = false;

  @override
  void initState() {
    // TODO: create an array of menu items
    menu.clear();
    FirebaseFunctions().getMenu(MyAppState.currentRes).then((value) {
      setState(() {
        menu = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                color: Constants.mainYellow,
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(MyAppState.currentRes.name,
                          style: Constants.HEADING),
                    ),
                    Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: 300,
                        child: Image.network(MyAppState.currentRes.imgUrl)),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Text("Queue Time: " +
                        MyAppState.currentRes.qTime.toString() +
                        " mins"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ToggleButton(
                          showAnalysis: showAnalysis,
                          title: 'Menu',
                          toggleBool: () {
                            setState(() {
                              MyAppState.currentUser.orderList.clear();
                              showAnalysis = false;
                            });
                          },
                        ),
                        ToggleButton(
                          showAnalysis: !showAnalysis,
                          title: 'Analysis',
                          toggleBool: () {
                            setState(() {
                              showAnalysis = true;
                              setTopThree(menu);
                              setTopPriced(menu);
                            });
                          },
                        )
                      ],
                    ),
                    showAnalysis
                        ? AnalysisDisplay(
                            topThree: topThree,
                            topPrice: topPrice,
                          )
                        : MenuDisplay(menu: menu),
                    !showAnalysis
                        ? RaisedButton(
                            child: Text('Book Seats'),
                            onPressed: () {
                              FirebaseFunctions()
                                  .updateCustomers(MyAppState.currentRes);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Seatbooking()));
                            },
                          )
                        : Container(),
                    !showAnalysis ? Text("OR") : Container(),
                    !showAnalysis
                        ? RaisedButton(
                            child: Text('Place Order'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentScreen()));
                              FirebaseFunctions().updateOrderList(
                                  MyAppState.currentUser.orderList);
                            },
                          )
                        : Container()
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void setTopThree(List<MenuItem> menu) {
    //Make a copy of menu
    List<MenuItem> temp = [];
    print('menu in setTopThree is: ' + menu.toString());
    menu.forEach((element) {
      temp.add(element);
    });
    temp.sort((a, b) => a.popularity.compareTo(b.popularity));
    print('temp is: ' + temp.toString());
    print(temp[0].popularity);
    setState(() {
      topThree = temp.sublist(0, 3);
    });
  }

  void setTopPriced(List<MenuItem> menu) {
    List<MenuItem> temp = [];
    menu.forEach((el) {
      temp.add(el);
    });
    temp.sort((a, b) => b.price.compareTo(a.price));
    setState(() {
      topPrice = temp.sublist(0, 3);
    });
  }
}

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    Key key,
    @required this.showAnalysis,
    @required this.title,
    this.toggleBool,
  }) : super(key: key);

  final bool showAnalysis;
  final String title;
  final Function toggleBool;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        title,
        style: showAnalysis ? TextStyle(fontSize: 18) : Constants.SUBHEADING,
      ),
      onPressed: toggleBool,
    );
  }
}
