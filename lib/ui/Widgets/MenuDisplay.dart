import 'package:dinefine_app/model/MenuItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../main.dart';

class MenuDisplay extends StatefulWidget {
  const MenuDisplay({
    Key key,
    @required this.menu,
  }) : super(key: key);

  final List<MenuItem> menu;

  @override
  _MenuDisplayState createState() => _MenuDisplayState();
}

class _MenuDisplayState extends State<MenuDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 4)),
        scrollDirection: Axis.vertical,
        itemCount: widget.menu.length,
        itemBuilder: (context, index) {
          MenuItem item = widget.menu[index];
          return Card(
            child: RaisedButton(
              onPressed: () {
                itemPressed(item);
              },
              color: item.isSelected ? Colors.green : Constants.mainYellow,
              child: Column(
                children: [
                  Text(item.name),
                  Text("\$ " + item.price.toString()),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          );
        },
      ),
    );
  }

  itemPressed(MenuItem item) {
    setState(() {
      item.isSelected = !item.isSelected;
    });
    if (item.isSelected) {
      //add to list
      MyAppState.currentUser.orderList.add(item);
    } else {
      //remove item from list
      MyAppState.currentUser.orderList.remove(item);
    }
    print('menu item pressed: ' + item.toString());
    print(MyAppState.currentUser.orderList);
  }
}
