import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:redditech/connection.dart';
import 'package:provider/provider.dart';
import 'package:redditech/user.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class UserInfo {
  final String avatar;
  final String username;
  final String description;

  UserInfo({
    required this.avatar,
    required this.username,
    required this.description,
  });

  String trimImagelink() {
    return '';
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    String url = json['subreddit']['icon_img'];
    final imgUrlexp = new RegExp(
        r'https://styles.redditmedia.com/t5_557cz2/styles/([a-zA-Z0-9\-_]+).((jpg)|(png)|(jpeg))');
    final Iterable<RegExpMatch> matches = imgUrlexp.allMatches(url);

    if (imgUrlexp.hasMatch(url)) {
      matches.forEach((match) {
        url = url.substring(match.start, match.end);
      });
    } else
      url = 'https://i.redd.it/130am13nj6201.png';
    return UserInfo(
      avatar: url,
      username: json['subreddit']['display_name_prefixed'],
      description: json['subreddit']['public_description'],
    );
  }
}

class _Profile extends State<Profile> {
  _Profile();
  late Future<UserInfo> myData;

  @override
  void initState() {
    super.initState();
    myData = getIdentity();
  }

  Future<UserInfo> getIdentity() async {
    late final response;
    Map<String, dynamic> myHeader = <String, dynamic>{
      'Authorization': 'Bearer ' + context.read<User>().token,
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    try {
      response = await Dio().get('https://oauth.reddit.com/api/v1/me',
          options: Options(headers: myHeader));
      if (response.statusCode == 200) {
        return UserInfo.fromJson(response.data);
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('StatusCode ' + response.statusCode);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.orange[500]!;
    }
    return Colors.red;
  }

  Widget build(BuildContext context) {
    UserInfo userInfo = UserInfo(
        avatar: 'https://i.redd.it/130am13nj6201.png',
        username: 'Username',
        description: 'Bio');
    return FutureBuilder<UserInfo>(
      future: myData,
      builder: (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
        if (snapshot.hasError) {
          debugPrint("----|ERROR|------" + '${snapshot.error}' + "----------");
          return Text('${snapshot.error} error');
        } else if (snapshot.hasData)
          userInfo = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(userInfo.username),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: Image(image: NetworkImage(userInfo.avatar)))
              ],
            ),
            body: Center(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Text(userInfo.description, style: TextStyle(fontSize: 30, color: Colors.black)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ConnectPage(title: ("Redditech"))));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      child: Text("Disconnect")),
                ],
              ),
            ),
          );
      },
    );
  }
}
