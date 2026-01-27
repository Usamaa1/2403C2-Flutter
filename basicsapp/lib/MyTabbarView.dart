import 'package:basicsapp/MyProductsElectronics.dart';
import 'package:basicsapp/MyProductsFashion.dart';
import 'package:basicsapp/ProductScreen.dart';
import 'package:flutter/material.dart';

class MyTabbarView extends StatelessWidget {
  const MyTabbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          ProductsScreen(),
          MyProductsFashion(),
          MyProductsElectronics(),
          Text("Tab 4 Content"),
        ],
      ),
    );
  }
}
