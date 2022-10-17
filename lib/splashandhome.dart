import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: const MyHomePage(title: ''),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        backgroundColor: Colors.pink[50],
        // title: Text("Welcom To Tiryaq",style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold,fontSize: 25),),
        // centerTitle: true,
        // leading: Icon(Icons.arrow_back),
        // actions: [Icon(Icons.search)],
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 3,
                style: BorderStyle.none
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2000),bottomRight:Radius.circular(1000))
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                    ),
                    Text("Welcom to",style: TextStyle(color: Colors.purple,fontSize: 30,fontWeight: FontWeight.bold),),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:  Colors.white,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 150.0),
                  child: Text("Tiryaq",style: TextStyle(color: Colors.purple,fontSize: 30,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 110,)
              ],
            )
        ),
      ),
    );
  }
}
