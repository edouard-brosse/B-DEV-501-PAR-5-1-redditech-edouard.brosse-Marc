import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:redditech/user.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ConnectPage> createState() => _ConnectPage();
}

class _ConnectPage extends State<ConnectPage> {
  final String uri =
      'https://www.reddit.com/api/v1/authorize.compact?client_id=zdWUb8ZKzjiBOCM_IQvJGw&response_type=code&state=lorem&redirect_uri=http://localhost:39659/&duration=permanent&scope=identity read';
  final success = new RegExp(
      r'http://localhost:39659/\?state=lorem&code=([a-zA-Z0-9\-_]+)#_');
  final tokenReg = new RegExp(r'[a-zA-Z0-9\-_]+');
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void postCode(String postToken) async {
    try {
      String username = 'zdWUb8ZKzjiBOCM_IQvJGw';
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:'));
      final response = await Dio().post(
          'https://www.reddit.com/api/v1/access_token',
          options: Options(
            headers: <String, dynamic>{
              'Authorization': basicAuth,
              'content-Type': 'application/x-www-form-urlencoded',
            },
          ),
          data:
              "grant_type=authorization_code&code=$postToken&redirect_uri=http://localhost:39659/");
      Provider.of<User>(context, listen: false).setToken(response.data["access_token"]);
      Navigator.popAndPushNamed(context, '/home');
    } catch (error) {
      print(error);
    }
  }

  void parseCode(String uri) async {
    final Iterable<RegExpMatch> matches = tokenReg.allMatches(uri);
    if (success.hasMatch(uri)) {
      matches.forEach((match) {
        if (uri.substring(match.start, match.end).length == 30) {
          postCode(uri.substring(match.start, match.end));
        }
      });
    } else if (uri.contains('&error=access_denied#_')) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ConnectPage(title: 'Redditech')));
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.lightBlue[400],
        automaticallyImplyLeading: false,
      ),
      body: WebView(
            initialUrl: uri,
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageStarted: (String uri) {
              print('Page started loading');
              parseCode(uri);
            },
            onPageFinished: (String uri) {
              print('Page finished loading');
            },
            onProgress: (int progress) {
              print('Loading: $progress');
            },
            gestureNavigationEnabled: true,
      )
    );
  }
}
