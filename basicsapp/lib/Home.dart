import 'package:basicsapp/MyCarousel.dart';
import 'package:basicsapp/MyCart.dart';
import 'package:basicsapp/MyTabbar.dart';
import 'package:basicsapp/MyTabbarView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    List<Image> images = [
      Image.network(
        "https://images.unsplash.com/photo-1505533321630-975218a5f66f?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
      Image.network(
        "https://images.unsplash.com/photo-1591779051696-1c3fa1469a79?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
      Image.network(
        "https://plus.unsplash.com/premium_photo-1669357657874-34944fa0be68?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
      Image.network(
        "https://images.unsplash.com/photo-1530076886461-ce58ea8abe24?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(child: FaIcon(FontAwesomeIcons.user)),
          title: Center(child: Text("Home Screen")),
          actions: [
            IconButton(
              onPressed: () {
                print("funciton performed");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCart()),
                );
              },
              icon: FaIcon(FontAwesomeIcons.cartShopping),
            ),
          ],
        ),

        body: Column(
          children: [
            MyCarousel(images: images),
            Container(padding: const EdgeInsets.all(8.0), child: MyTabbar()),

            MyTabbarView(),
          ],
        ),
      ),
    );
  }
}
