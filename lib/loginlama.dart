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
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Welcom bak'),


        debugShowCheckedModeBanner: false
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
      appBar:
      PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child:
          AppBar(
            title: Text(widget.title),
            centerTitle: true,
            elevation: 10,
            backgroundColor: Colors.pink[50],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
            ),
            leading:
            Container(
              padding: (EdgeInsets.all(10)),
              child:
              Image.asset('assets/logoheader.png'),
            ),

          ) ),
      body: Center(
      ),
    );
  }
}