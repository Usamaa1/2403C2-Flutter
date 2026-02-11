import 'package:basicsapp/MyCarousel.dart';
import 'package:basicsapp/MyCart.dart';
import 'package:basicsapp/MyProductsElectronics.dart';
import 'package:basicsapp/MyProductsFashion.dart';
import 'package:basicsapp/MyTabbar.dart';
import 'package:basicsapp/ProductScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          title: Text("Home Screen"),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyCart()),
                    );
                  },
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("addToCart")
                        .where(
                          "userId",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }

                      int totalItems = 0;
                      for (var doc in snapshot.data!.docs) {
                        totalItems +=
                            (doc.data().toString().contains("quantity"))
                            ? (doc["quantity"] as int)
                            : 1;
                      }

                      return CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Text(
                          totalItems.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(child: MyCarousel(images: images)),

            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: MyTabbar(),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              ProductsScreen(),
              MyProductsFashion(),
              MyProductsElectronics(),
              Center(child: Text("Tab 4 Content")),
            ],
          ),
        ),
      ),
    );
  }
}
