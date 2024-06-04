import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/user.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  var opt1 = 'https://oauth.reddit.com/r/all/new.json?limit=100&sort=new';
  var opt2 = 'https://oauth.reddit.com/r/all/hot.json?limit=100&sort=new';
  var opt3 = 'https://oauth.reddit.com/r/all/random.json?limit=100&sort=new';
  var opt4 = 'https://oauth.reddit.com/r/all/rising.json?limit=100&sort=new';
  var opt5 = 'https://oauth.reddit.com/r/all/top.json?limit=100&sort=new';
  var opt6 = 'https://oauth.reddit.com/r/all/sort.json?limit=100&sort=new';
  var opt7 = 'https://oauth.reddit.com/r/all/best.json?limit=100&sort=new';
  var opt = 'https://oauth.reddit.com/r/all/new.json?limit=100&sort=new';
  var post = [];
  var title = [];
  var uCom = [];
  var img = [];
  var gif = [];
  var prof = [];
  var users = <String>[
    'New',
    'Hot',
    'Best',
    'top',
    'Rising',
  ];
  late int _user = 0;

  @override
  void initState() {
    super.initState();
    sleep(Duration(seconds: 1));
    feed().then((List buff) => setState(() {
          post = buff;
        }));
  }

  Future<List> feed() async {
    late String url;
    try {
      final response = await Dio()
          .get(opt,
              options: Options(headers: <String, dynamic>{
                'Authorization': 'Bearer ' + context.read<User>().token,
                'Content-Type': 'application/x-www-form-urlencoded',
              }));
      if (response.statusCode == 200) {
        uCom = [];
        title = [];
        img = [];
        var data = (response.data);
        for (var s = 0; s < 100; s++) {
          uCom.add(data["data"]["children"][s]["data"]["selftext"]);
          title.add(data["data"]["children"][s]["data"]["title"]);
          if (data["data"]["children"][s]["data"]["thumbnail"] != null) {
            url = data["data"]["children"][s]["data"]["thumbnail"];
            img.add(url);
          } else
            img.add("nothing");
        }
        return uCom;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.grey[400],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          //Text("TRY"),
          //Text(opt),
          new DropdownButton<String>(
            hint: new Text('Pickup on every'),
            value: _user == null ? null : users[_user],
            items: users.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              //debugPrint("---| VALUE : " + value + "|----");
              setState(() {
                _user = users.indexOf(value!);
                if(value == "New")
                  opt = opt1;
                else if(value == "Hot")
                  opt = opt2;
                else if (value == "Best")
                  opt = opt7;
                else if (value == "Rising")
                  opt = opt4;
                else
                  opt = opt5;
              });
              sleep(Duration(seconds: 1));
              feed().then((List buff) => setState(() {
                post = buff;
              }));
            },
          ),
          IconButton(
              icon: Icon(Icons.settings),
              color: Colors.grey,
              onPressed: () {
                feed().then((List S) => setState(() {
                      post = S;
                    }));
              }),
        ],
      ),
      body: uCom.length != 0
          ? ListView.builder(
              itemCount: uCom.length,
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
                        Text(
                          uCom[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        if (img[index] != "nothing")
                          Image.network(
                            img[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.amber,
                                alignment: Alignment.center,
                                //child: Text(img[index]),
                                child: Text("Picture error"),
                              );
                            },
                          )
                        else
                          Text("----NO PICTURE TO PRINT---"),
                        Text(
                          uCom[index],
                          style: TextStyle(color: Colors.white),
                        ),
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
      backgroundColor: Colors.grey,
    );
  }
}
