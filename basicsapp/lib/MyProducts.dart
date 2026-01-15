import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> products = FirebaseFirestore.instance
        .collection('Products')
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
