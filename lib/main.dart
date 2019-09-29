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
  ScrollController _scrollController = new ScrollController();
  List<String> _array = [];
  int i = 0;
  int j = 0;
  int iteration = 0;
  bool _isLoad = false;

  arrGenerate() async {
    j = 0;
    while (j != 17) {
      await Future.delayed(const Duration(milliseconds: 100));
      _array.add('Name ${i}');
      j++;
      i++;
    }
    controller.add(_array);
  }

//   getJson(i) async{
//    var response = await http.get('https://randomuser.me/api?results=10'); //https://randomuser.me/api or https://api.github.com/users
//    if (response.statusCode == 200){
//      var _jsonMap = json.decode(response.body);
//      print('${_jsonMap['results'][i]['name']['first']}');
//      if ((_jsonMap['results'].length - 1 >= i)) {
//        _array.add('${_jsonMap['results'][i]['name']['first']}');
//        controller.add(_array);
//      }
//    }
//    else{
//      print('Error. Status =  ${response.statusCode} ${response.body}');
//    }
//  }


  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
        print("list update");
        arrGenerate();
    }
//    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
//        !_scrollController.position.outOfRange) {
//        print("reach the top");
//    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Widget build(BuildContext context) {

    arrGenerate();

     return StreamBuilder<List<String>>(
         stream: controller.stream,
         builder: (context, snapshot) {
           iteration = 0;
           if (snapshot.data != null) {
             return ListView.builder(
               controller: _scrollController,
               physics: const AlwaysScrollableScrollPhysics(),
               itemBuilder: (context, index) {

                 if (iteration != 16 || index == 0) {
                   iteration++;
                   return Column(
                     children: <Widget>[
                       Text('${snapshot.data[index]} ($index , ${index % 19})'),
                       new Divider()
                     ]
                   );
                 }
                 else{
                   iteration=0;
                   return Column(
                       children: <Widget>[
                         Text('${snapshot.data[index]} ($index , ${index % 19})'),
                         new Divider(),
                         Center(
                           child: CircularProgressIndicator(),
                         )
                       ]
                   );
                 }
               },
               itemCount: snapshot.data.length
             );
           }
           else{
             return Container();
           }
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