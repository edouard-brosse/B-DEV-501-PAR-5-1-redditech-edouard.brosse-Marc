import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:redditech/profile.dart';
import 'package:redditech/dashboard.dart';
import 'package:redditech/search.dart';
import 'package:redditech/NWPost.dart';

class Home extends StatefulWidget {
  @override
  Home();
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  _Home();
  int idx = 0;
  Widget getPage(int index) {
    if (index == 0) {
      return Dashboard();
    } else if (index == 1) {
      return Search();
    } else if (index == 2) {
      return NWPost();
    } else if (index == 3) {
      return Profile();
    }
    return Dashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getPage(idx),
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Colors.black,
          backgroundColor: Colors.grey,
          color: Colors.black,
          items: <Widget>[
            Icon(Icons.dashboard, size: 20, color: Colors.white),
            Icon(Icons.search, size: 20, color: Colors.white),
            Icon(Icons.speaker_notes, size: 20, color: Colors.white),
            Icon(Icons.supervised_user_circle, size: 20, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              idx = index;
            });
          },
        ));
  }
}
