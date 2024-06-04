import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
          Expanded(
            child: TextField(
              onChanged: (str) {
                setState(() {
                  txt = str;
                });
              },
              controller: myController,
            ),
          ),
          //Container(
          //  child: Text(txt),
          //),
        ], //
      ),
      /*floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              txt = myController.text;
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the lopes!',
        child: const Icon(Icons.text_fields),
      ),*/
    );
  }
}

/*
class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Search();
  }
}
*/
//class _Search extends State<Search> {
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("User Search"),
//        backgroundColor: Colors.grey[400],
//        automaticallyImplyLeading: false,
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.settings), color: Colors.grey, onPressed: () {}),
//        ],
//      ),
//      body: Center(
//        child: Text('comming Soon'),
//      ),
//      //backgroundColor: Colors.orange[400],
//      //backgroundColor: Colors.red,
//    );
//  }
//}
