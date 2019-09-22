import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _getUser(i) async{
    var response = await http.get('https://randomuser.me/api?results=10'); //https://randomuser.me/api or https://api.github.com/users
    if (response.statusCode == 200){
      var _jsonMap = json.decode(response.body);
      if (_jsonMap['results'][i] != null) {
        setState(() {
          return _createItem(_jsonMap['results'][i]['name']['first']);
        });
      }

    }
    else{
      print('Status[$i] =  ${response.statusCode} ${response.body}');
    }
  }

  Widget _createItem(userLogin){
    return new GestureDetector(
      onTap: () {},
      child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Color(0xFFEEEEEE)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Container(
                          decoration: new BoxDecoration(
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.center,
                                image: new NetworkImage('http://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9'),
                              )
                          ),
                          width: 75,
                          height: 75,
                        )
                    )
                ),

                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userLogin.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Flutter\'s hot reload helps you quickly and easily experiment, build UIs, add features, and fix bug faster. Experience sub-second reload times, without losing state, on emulators, simulators, and hardware for iOS and Android.',
                        style: TextStyle(color: Color(0xFF757575)),),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  var userLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index < 5) {
            return _getUser(index);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        itemCount: 5 + 1,
      ),
    );
  }
}
