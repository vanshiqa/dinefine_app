import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dinefine_app/model/User.dart';
import 'package:dinefine_app/ui/screens/HomeScreen.dart';
import 'package:dinefine_app/ui/services/Authenticate.dart';
import 'package:dinefine_app/ui/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'ui/screens/AuthScreen.dart';
import 'ui/screens/OnBoardingScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(accentColor: Constants.mainYellow),
        debugShowCheckedModeBanner: false,
        color: Constants.mainYellow,
        home: AuthScreen());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}