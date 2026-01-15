import 'package:flutter/material.dart';

class MyGridviewBuilder extends StatelessWidget {
  const MyGridviewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width < 400 ? 1 : 2,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return null;
          
            // return MyCard();
          },
        ),
      ),
    );
  }
}
