import 'package:flutter/material.dart';
import 'notification.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.menu),
          actions: [

            ElevatedButton(onPressed: (){
              Navigator.push
                (context, MaterialPageRoute(builder:(_)=>notification()));
            }, child:Icon(Icons.notifications))
          ],
          title: Text("Dashboard")
      ),
    );
  }
}
