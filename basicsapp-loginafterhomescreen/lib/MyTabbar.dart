import 'package:flutter/material.dart';

class MyTabbar extends StatelessWidget {
  const MyTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(40),
      ),
      labelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerHeight: 0,
      tabs: [
        Tab(text: "All"),
        Tab(text: "Fashion"),
        Tab(text: "Electronics"),
        Tab(text: "Tab 4"),
      ],
    );
  }
}
