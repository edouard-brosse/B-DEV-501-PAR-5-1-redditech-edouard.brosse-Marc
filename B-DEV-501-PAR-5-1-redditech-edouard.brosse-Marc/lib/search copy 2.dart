import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:redditech/user.dart';
import 'dart:io';
//import 'package:http/http.dart' as http;

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Text',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  late var txt = "enter";
  String input = "";
  String STxt = "";
  var subR = [];
  var post = [];

  @override
  void initState() {
    super.initState();
    //sleep(Duration(seconds: 1));
    //feed().then((List buff) => setState(() {
    //      post = buff;
    //    }));
  }

  Future<List> feed() async {
    late String url;
    try {
      final response = await Dio()
          .get('https://oauth.reddit.com/r/all/new.json?limit=20&sort=new',
              options: Options(headers: <String, dynamic>{
                'Authorization': 'Bearer ' + context.read<User>().token,
                'Content-Type': 'application/x-www-form-urlencoded',
              }));
      if (response.statusCode == 200) {
        var data = (response.data);
        for (var s = 0; s < 20; s++) {
          subR.add(data["data"]["children"][s]["data"]["selftext"]);
        }
        return subR;
      } else {
        throw Exception(
            'Error ${response.statusCode} :' + response.statusMessage!);
      }
    } catch (error) {
      print(error);
      return List.empty();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            //shrinkWrap: true,
            //children: <Widget>[
              child: Stack(
                children: [
                  Container(
                    TextField(
                      keyboardType: TextInputType.text,
                  //maxLength: 20,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(1),
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                      onChanged: (str) {
                        setState(() {
                          txt = str;
                        });
                        input = str;
                      },
                    ),
                  ),
                  ElevatedButton( 
                    onPressed: () {}, 
                    child: Icon(
                      Icons.menu, 
                      color: Colors.white
                      ), 
                    style: ElevatedButton.styleFrom( 
                      shape: CircleBorder(), 
                      padding: EdgeInsets.all(20), 
                      primary: Colors.blue, // <-- Button color onPrimary: Colors.red, // <-- Splash color 
                      ), 
                    )
              ],
            ),
            
            //],
          ),
          Text("entrée : " + input + "\n2 : " + txt + "\nFINAL : " + checkTxt),
          //ListView(
          //  //physics: Scrollable,
          //),
          //ListView(
          //  physics: NeverScrollableScrollPhysics(),
          //  children: <Widget>[
          //    Expanded(
          //      //child: TextField(
          //      //  onChanged: (str) {
          //      //    setState(() {
          //      //      txt = str;
          //      //    });
          //      //  },
          //      //  controller: myController,
          //      //),
          //    ),
          //  ],
          //),
          //Expanded(
          //  child: subR.length != 0
          //      ? ListView.builder(
          //          itemCount: subR.length,
          //          itemBuilder: (BuildContext ctx, int index) {
          //            return Padding(
          //              padding: EdgeInsets.all(0),
          //              child: Card(
          //                elevation: 0,
          //                color: Colors.black,
          //                child: Column(
          //                  children: <Widget>[
          //                    Text(
          //                      subR[index],
          //                      style: TextStyle(color: Colors.white),
          //                    ),
          //                  ],
          //                ),
          //              ),
          //            );
          //          })
          //      : Center(
          //          child: Text(
          //            "Loading",
          //            textAlign: TextAlign.center,
          //            style: TextStyle(color: Colors.red),
          //          ),
          //        ),
          //),
        ], //
      ),
    );
  }
}
