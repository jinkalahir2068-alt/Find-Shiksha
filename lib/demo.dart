import 'package:flutter/material.dart';

class demo extends StatelessWidget {
  List<Widget> items=<Widget>[
    Text("hello1"),
    Text("hello2"),
    Text("hello3"),
    Text("hello4"),
    Text("hello5"),
    Text("hello6"),
    Text("hello7"),
    Text("hello8"),
    Text("hello9"),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
          (crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
        ), itemBuilder: (context,index){
          return Container(
            height: 200,
            width: 200,
            child: Text("items[index]"),
          );
        },
        itemCount: items.length,)
      ),

    );
  }
}
