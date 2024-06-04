import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class NWPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NWPost();
  }
}

class _NWPost extends State<NWPost> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        backgroundColor: Colors.grey[400],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings), color: Colors.grey, onPressed: () {}),
        ],
      ),
      body: Center(
        child: Text('comming Soon'),
      ),
      backgroundColor: Colors.orange[400],
      //backgroundColor: Colors.red,
    );
  }
}
