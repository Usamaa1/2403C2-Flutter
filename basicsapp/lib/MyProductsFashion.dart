import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyProductsFashion extends StatefulWidget {
  const MyProductsFashion({super.key});

  @override
  State<MyProductsFashion> createState() => _MyProductsFashionState();
}

class _MyProductsFashionState extends State<MyProductsFashion> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> products = FirebaseFirestore.instance
        .collection('Products').where("Category", isEqualTo: "Fashion")
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
