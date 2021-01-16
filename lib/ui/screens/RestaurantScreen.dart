import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinefine_app/model/MenuItem.dart';
import 'package:dinefine_app/ui/screens/Seatbooking.dart';
import 'package:dinefine_app/ui/utils/DateTimePicker.dart';
import 'package:dinefine_app/ui/utils/FirebaseFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../model/User.dart';

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
        //   setTopThree(menu);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('In RestaurantScreen.dart, in build function, menu is: ' +
    //    menu.toString());
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ToggleButton(
                          showAnalysis: showAnalysis,
                          title: 'Menu',
                          toggleBool: () {
                            setState(() {
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
                    RaisedButton(
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

class AnalysisDisplay extends StatelessWidget {
  const AnalysisDisplay({
    Key key,
    @required this.topThree,
    @required this.topPrice,
  }) : super(key: key);

  final List<MenuItem> topThree;
  final List<MenuItem> topPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: Row(
            children: [
              Container(
                height: 100,
                width: 150,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    MenuItem el = topThree[index];
                    return Container(
                      child: Row(
                        children: [
                          Text(
                            index.toString() + '. ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(el.name),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 100,
                width: 150,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    MenuItem el = topPrice[index];
                    return Container(
                      child: Row(
                        children: [
                          Text(el.name + " - \$"),
                          Text(
                            el.price.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Text("Number of customers: " +
            MyAppState.currentRes.numOrders.toString()),
        Text("Satisfaction Level: " + MyAppState.currentRes.satVal.toString()),
      ],
    );
  }
}

class MenuDisplay extends StatelessWidget {
  const MenuDisplay({
    Key key,
    @required this.menu,
  }) : super(key: key);

  final List<MenuItem> menu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menu.length,
        itemBuilder: (context, index) {
          MenuItem item = menu[index];
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Constants.mainYellow,
                    border: Border.all(
                      color: Constants.mainYellow,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 50,
                child: Column(
                  children: [
                    Text(item.name),
                    Text("\$ " + item.price.toString()),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
