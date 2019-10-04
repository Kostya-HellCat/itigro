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

   getJson() async{
    i=0;
    var response = await http.get('https://randomuser.me/api?results=10'); //https://randomuser.me/api or https://api.github.com/users
    if (response.statusCode == 200){
      var _jsonMap = json.decode(response.body);

      if ((_jsonMap['results'].length - 1 >= i)) {
        while (i != 10) {
          _array.addAll(['${_jsonMap['results'][i]['name']['first']}','${_jsonMap['results'][i]['picture']['large']}','${_jsonMap['results'][i]['email']}']);
          i++;
        }
        controller.add(_array);
      }
    }
    else{
      print('Error. Status =  ${response.statusCode} ${response.body}');
    }
  }


  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
        print("list update");
        getJson();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Widget build(BuildContext context) {
    getJson();
     return StreamBuilder<List<String>>(
         stream: controller.stream,
         builder: (context, snapshot) {
           if (snapshot.data != null) {
             return ListView.builder(
               controller: _scrollController,
               physics: const AlwaysScrollableScrollPhysics(),
               itemBuilder: (context, index) {
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
                             Container(

                                 child: Padding(
                                     padding: EdgeInsets.only(right: 12.0),
                                     child: Container(
                                       child: CircleAvatar(
                                                 backgroundImage: NetworkImage('${snapshot.data[(index*3)+1]}'),
                                             ),
                                     )
                                 )
                             ),
                             Container(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Text(
                                     snapshot.data[index*3],
                                     textAlign: TextAlign.left,
                                     style: TextStyle(fontWeight: FontWeight.bold),
                                   ),
                                   Padding(
                                     padding: EdgeInsets.symmetric(vertical: 4),
                                     child: Text(
                                     snapshot.data[(index*3)+2],
                                     style: TextStyle(
                                         color: Color(0xFF757575),
                                         fontSize: 10
                                     ),
                                   ),
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       )
                   ),
                 );
               },
               itemCount: snapshot.data.length ~/ 3
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
        home: new Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('itgro app'),
            )
          ),
            body: new Center(
              child: new MyBody(),
            )
        )
    )
);