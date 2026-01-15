import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyProductsElectronics extends StatefulWidget {
  const MyProductsElectronics({super.key});

  @override
  State<MyProductsElectronics> createState() => _MyProductsElectronicsState();
}

class _MyProductsElectronicsState extends State<MyProductsElectronics> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> products = FirebaseFirestore.instance
        .collection('Products')
        .where("Category", isEqualTo: "Electronics")
        .snapshots();

    return StreamBuilder(
      stream: products,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text("Data not found"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: [
                  Image.memory(
                    base64Decode(snapshot.data!.docs[index]["prodImage"]),
                    height: 200,
                  ),
                  Text(
                    snapshot.data!.docs[index]['prodName'].toString().trim(),
                  ),
                  Text(snapshot.data!.docs[index]['prodPrice']),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
