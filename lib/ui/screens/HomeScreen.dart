import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinefine_app/ui/screens/AllRestaurants.dart';
import 'package:dinefine_app/ui/screens/ProfileScreen.dart';
import 'package:dinefine_app/ui/screens/categorypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dinefine_app/constants.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/ui/screens/AuthScreen.dart';
import 'package:dinefine_app/ui/utils/Authenticate.dart';
import 'package:dinefine_app/ui/utils/helper.dart';

import '../../main.dart';
import '../../main.dart';
import '../../main.dart';
import 'AllRestaurants.dart';

FireStoreUtils _fireStoreUtils = FireStoreUtils();

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
  }
}

class _HomeState extends State<HomeScreen> {
  final User user;
  int _currentIndex = 0;

  _HomeState(this.user);

  List ScreenList = [
    AllRestaurants(user: MyAppState.currentUser),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(Constants.COLOR_PRIMARY),
              ),
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              leading: Transform.rotate(
                  angle: pi / 1,
                  child: Icon(Icons.exit_to_app, color: Colors.black)),
              onTap: () async {
                user.active = false;
                user.lastOnlineTimestamp = Timestamp.now();
                _fireStoreUtils.updateCurrentUser(user, context);
                await FirebaseAuth.instance.signOut();
                MyAppState.currentUser = null;
                pushAndRemoveUntil(context, AuthScreen(), false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ScreenList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Constants.mainYellow,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.explore, size: 40),
            title: Text(''),
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 40,
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
