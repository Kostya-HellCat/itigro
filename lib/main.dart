import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MyBody extends StatefulWidget {
  @override

  createState() => new MyBodyState();
}

class MyBodyState extends State<MyBody> {
  var controller = new StreamController<List<String>>.broadcast();
  List<String> _array = [''];
  int j = 0;

  arrGenerate() async {
    int i = 0;
    while (i != 5) {
      await Future.delayed(const Duration(seconds: 1));
      _array.add('$i');
      controller.add(_array);
      print('Controller add ${i*2} item');
      i++;
    }
  }

//   getJson(i) async{
//    var response = await http.get('https://randomuser.me/api?results=10'); //https://randomuser.me/api or https://api.github.com/users
//    if (response.statusCode == 200){
//      var _jsonMap = json.decode(response.body);
//      print('${_jsonMap['results'][i]['name']['first']}');
//      if ((_jsonMap['results'].length - 1 >= i)) {
//        _nameArray.addAll(['${_jsonMap['results'][i]['name']['first']}']);
//      }
//    }
//    else{
//      print('Error. Status =  ${response.statusCode} ${response.body}');
//    }
//  }

  @override
  Widget build(BuildContext context) {
    arrGenerate();

    return StreamBuilder<List<String>>(
        stream: controller.stream,
        builder: (context, snapshot) {
          return ListView.builder(itemBuilder: (context, index) {
            if (index.isOdd) return new Divider();
            index = index ~/ 2;
            if (_array[index] != null) {
              print('$index, будет выведено ${_array[index]}');

              return new Text('${_array[index]}');
            }
            else{
              return new Text('');
            }

          });
        }
    );
  }


}

void main() =>  runApp(
    new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(body: new Center(child: new MyBody(),))
    )
);