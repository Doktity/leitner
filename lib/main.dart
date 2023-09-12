import 'package:flutter/material.dart';
import 'package:leitner/pages/AddPage.dart';
import 'package:leitner/pages/HomePage.dart';
import 'package:leitner/pages/ListPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _index = 0;

  setCurrentIndex(int index){
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const [
              Text("Leitner"),
              Text("Ajout"),
              Text("List")
            ][_index]
        ),
        body: const [
          HomePage(),
          AddPage(),
          ListPage()
        ][_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (index) => setCurrentIndex(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.backspace),
                label: "Retour"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Ajout"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Maison"
            ),
          ],
        ),
      ),
    );
  }
}
