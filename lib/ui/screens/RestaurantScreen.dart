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
                      child: Text("Margherita's", style: Constants.HEADING),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      width: 350,
                      child: Image.network(
                          'https://www.google.com/maps/uv?pb=!1s0x31da1a234cb3f8b1%3A0xe1da5ec575538156!3m1!7e115!4shttps%3A%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOwHnER7GFXiMLdoxS6sS238pfZX2uK5eA0nQiQ%3Dw480-h320-k-no!5smargheritas%20-%20Google%20Search!15sCgIgAQ&imagekey=!1e10!2sAF1QipOwHnER7GFXiMLdoxS6sS238pfZX2uK5eA0nQiQ&hl=en&sa=X&ved=2ahUKEwjvqfuOzJPuAhWWXSsKHe8oCTkQoiowEnoECCgQAw#'),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
