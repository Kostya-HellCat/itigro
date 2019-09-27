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
  List<String> _array = [];
  int j = 0;

//  arrGenerate() async {
//    int i = 0;
//    while (i != 10) {
//      await Future.delayed(const Duration(seconds: 1));
//      _array.add('Name$i');
//      controller.add(_array);
//      print('Controller add Name$i item');
//      i++;
//    }
//  }

   getJson(i) async{
    var response = await http.get('https://randomuser.me/api?results=10'); //https://randomuser.me/api or https://api.github.com/users
    if (response.statusCode == 200){
      var _jsonMap = json.decode(response.body);
      print('${_jsonMap['results'][i]['name']['first']}');
      if ((_jsonMap['results'].length - 1 >= i)) {
        _array.add('${_jsonMap['results'][i]['name']['first']}');
        controller.add(_array);
      }
    }
    else{
      print('Error. Status =  ${response.statusCode} ${response.body}');
    }
  }

  @override

  Widget build(BuildContext context) {

     getJson(1);
     
     return RefreshIndicator(child: StreamBuilder<List<String>>(
         stream: controller.stream,
         builder: (context, snapshot) {
           if (snapshot.data != null) {
             return ListView.builder(
                 physics: const AlwaysScrollableScrollPhysics(),
                 itemBuilder: (context, index) {
                   if (index.isOdd) return new Divider();
                   index = index ~/ 2;
                   //getJson(index);
                   //print('$index, будет выведено ${snapshot.data[index]}');
                   return Text('${snapshot.data[index]}');
                 },
                 itemCount: snapshot.data.length*2);
           }
           else{
             return Container();
           }
         }
     ),
         onRefresh: () => getJson(2));
  }
  
//  Widget build(BuildContext context) {
//
//    getJson(0);
//
//    return StreamBuilder<List<String>>(
//        stream: controller.stream,
//        builder: (context, snapshot) {
//          if (snapshot.data != null) {
//            return ListView.builder(
//                physics: const AlwaysScrollableScrollPhysics(),
//                itemBuilder: (context, index) {
//                if (index.isOdd) return new Divider();
//                index = index ~/ 2;
//                //getJson(index);
//                //print('$index, будет выведено ${snapshot.data[index]}');
//                return Text('${snapshot.data[index]}');
//            },
//              itemCount: snapshot.data.length*2);
//          }
//          else{
//            return Container();
//          }
//        }
//    );
//  }


}

void main() =>  runApp(
    new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(body: new Center(child: new MyBody(),))
    )
);