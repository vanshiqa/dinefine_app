import 'package:dinefine_app/model/restaurant.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/ui/screens/HomeScreen.dart';
import 'package:dinefine_app/ui/utils/Authenticate.dart';
import 'package:dinefine_app/ui/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'ui/screens/AuthScreen.dart';
import 'ui/screens/AuthScreen.dart';
import 'ui/screens/HomeScreen.dart';
import 'ui/screens/HomeScreen.dart';
import 'ui/screens/OnBoardingScreen.dart';
import 'ui/utils/Authenticate.dart';
import 'ui/utils/Authenticate.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static User currentUser;
  static Restaurant currentRes;
  static List orderList;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FireStoreUtils _fireStoreUtils = FireStoreUtils();

  Future<User> getUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    String uid = currentUser.uid;
    DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
        .collection(Constants.USERS)
        .document(uid)
        .get();
    User user;
    if (documentSnapshot != null && documentSnapshot.exists) {
      user = User.fromJson(documentSnapshot.data);
      user.active = true;
      await _fireStoreUtils.updateCurrentUser(user, context);
      hideProgress();
      MyAppState.currentUser = user;
    } else {
      user = null;
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    print("current user:");
    print(MyAppState.currentUser);
    return MaterialApp(
        theme: ThemeData(accentColor: Constants.mainYellow),
        debugShowCheckedModeBanner: false,
        color: Constants.mainYellow,
        home: currentUser != null
            ? HomeScreen(
                user: currentUser,
              )
            : AuthScreen());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getUser().then((value) {
      setState(() {
        currentUser = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
