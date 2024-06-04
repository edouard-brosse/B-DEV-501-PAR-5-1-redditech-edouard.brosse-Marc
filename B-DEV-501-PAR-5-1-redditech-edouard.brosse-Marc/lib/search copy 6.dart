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
  
  String url1 = "https://oauth.reddit.com/r/";
  String url2 = "/search.json?q=test&restrict_sr=on";
  String urlFinal= "";
  final myController = TextEditingController();
  late var txt = "enter";
  String input = "";
  String checkTxt = "";
  var subR = [];
  var title = [];
  var name = [];
  var author = [];
  var subId = [];
  var id = [];
  var parmalink = []; //
  var suscriber = [];
  var picture = [];

  @override
  void initState() {
    super.initState();
    sleep(Duration(seconds: 1));
    //feed().then((List buff) => setState(() {
    //      post = buff;
    //    }));
  }

  Future<List> feed() async {
    late String url;
    debugPrint("------------|"+urlFinal+"|-----------------");
    try {
      final response = await Dio()
          .get(urlFinal,
              options: Options(headers: <String, dynamic>{
                'Authorization': 'Bearer ' + context.read<User>().token,
                'Content-Type': 'application/x-www-form-urlencoded',
              }));
      if (response.statusCode == 200) {
        var data = (response.data);
        //debugPrint("-------| SUCCES |--------");
        //debugPrint(data["kind"]);
        debugPrint("---| SECOND TRY |---");
        var s = 0;
        debugPrint("Subredit :" + data["data"]["children"][s]["data"]["subreddit"]);
        debugPrint("Title :" + data["data"]["children"][s]["data"]["title"]);
        debugPrint("name :" + data["data"]["children"][s]["data"]["name"]);
        debugPrint("subreddit_id :" + data["data"]["children"][s]["data"]["subreddit_id"]);
        debugPrint("id :" + data["data"]["children"][s]["data"]["id"]);
        debugPrint("author :" + data["data"]["children"][s]["data"]["author"]);
        debugPrint("permalink :" + data["data"]["children"][s]["data"]["permalink"]);
        debugPrint("subreddit_subscribers :" + data["data"]["children"][s]["data"]["subreddit_subscribers"].toString());
        for (var s = 0; s < 50; s++) {
          subR.add(data["data"]["children"][s]["data"]["subreddit"]);
          title.add(data["data"]["children"][s]["data"]["title"]);
          name.add(data["data"]["children"][s]["data"]["name"]);
          subId.add(data["data"]["children"][s]["data"]["subreddit_id"]);
          id.add(data["data"]["children"][s]["data"]["id"]);
          author.add(data["data"]["children"][s]["data"]["author"]);
          suscriber.add(data["data"]["children"][s]["data"]["subreddit_subscribers"].toString());
          if(data["data"]["children"][s]["data"]["thumbnail"] != null) {
            url = data["data"]["children"][s]["data"]["thumbnail"];
            debugPrint("picture :" + data["data"]["children"][s]["data"]["thumbnail"]);
            picture.add(url);
          } else {
            picture.add("nothing");
          }
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
  Widget build(BuildContext context) { //<<
    var isPortrait = (MediaQuery.of(context).size.width);

    if (MediaQuery.of(context).orientation == Orientation.portrait){ // is portrait
      isPortrait = (MediaQuery.of(context).size.width);
    }else{ // is landscape
      isPortrait = (MediaQuery.of(context).size.width);
    }
    return Scaffold(// <<
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: ListView( // <<
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 5,
                      ),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 3,
                      right: 10,
                      ),
                    width: (isPortrait - 70),
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(1),
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                      onChanged: (str) {
                        setState(() {
                          txt = str;
                          input = str;
                        });
                      },
                    ),
                  ), //
                  Container(
                    //color: Colors.red, 
                    margin: EdgeInsets.only(
                      left: (isPortrait - 60), 
                      right: 1.0,
                      ),
                    height: 50,//
                    width: 50,
                    child: ElevatedButton( 
                      onPressed: () {
                        //checkTxt = input;
                      debugPrint("TEST size");
                      setState(() {
                            checkTxt = input;
                            //debugPrint(
                            //  subR.length
                            //);
                          });
                        sleep(Duration(seconds: 1));
                        urlFinal = url1 + checkTxt + url2;
                        feed().then((List buff) => setState(() {
                          //post = buff;
                        }));
                      }, 
                      child: Icon(
                        Icons.search, 
                        color: Colors.white
                        ), 
                      style: ElevatedButton.styleFrom( 
                        shape: CircleBorder(), 
                        padding: EdgeInsets.all(20), 
                        primary: Colors.blue, // <-- Button color onPrimary: Colors.red, // <-- Splash color 
                        ), 
                      ),
                  ),
              ],
            ),
          ),
          Text("entrée : " + checkTxt
              + " size subR : " + (subR.length.toString())),//
          subR.length != 0
          ? ListView.builder(
              itemCount: subR.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Padding(
                  padding: EdgeInsets.all(0),
                  child: Card(
                    elevation: 0,
                    color: Colors.black,
                    child: Column(
                      children: <Widget>[
                        Text(title[index] + "\n",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.10,
                              fontWeight: FontWeight.bold,
                            )),
                        //Text(
                        //  subR[index],
                        //  style: TextStyle(color: Colors.white),
                        //),
                        //if (picture[index] != "nothing")
                        //  Image.network(
                        //    picture[index],
                        //    //fit: BoxFit.cover,
                        //    errorBuilder: (context, error, stackTrace) {
                        //      return Container(
                        //        color: Colors.amber,
                        //        alignment: Alignment.center,
                        //        child: Text("Picture error"),
                        //      );
                        //    },
                        //  )
                        //else
                        //  Text("----NO PICTURE TO PRINT---"),
                        //Text(
                        //  suscriber[index],
                        //  style: TextStyle(color: Colors.white),
                        //),
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Text(
                "Loading",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ], //
      ), //<<
    );//<<
  } //<<
}
