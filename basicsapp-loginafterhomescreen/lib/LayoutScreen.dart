import 'package:basicsapp/Home.dart';
import 'package:basicsapp/MyProfile.dart';
import 'package:basicsapp/MySettings.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {

  int currentIndex = 0;

  List<Widget> childrens = [
    Home(),
    MyProfile(),
    MySettings(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childrens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
        
      )
    );
  }
}
