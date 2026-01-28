import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basicsapp/MyCard.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Stream<QuerySnapshot> prods =
      FirebaseFirestore.instance.collection("Products").snapshots();
  final addToCartItems = FirebaseFirestore.instance.collection("addToCart");

  final uid = FirebaseAuth.instance.currentUser!.uid;

  List<String> cartItems = [];

  @override
  void initState() {
    super.initState();
    getCart();
  }

  Future<void> getCart() async {
    final snapshot =
        await addToCartItems.where("userId", isEqualTo: uid).get();

    setState(() {
      cartItems = snapshot.docs.map((e) => e["prodId"] as String).toList();
    });
  }

Future<void> addToCartHandler(String prodId) async {
  final snapshot = await addToCartItems
      .where("userId", isEqualTo: uid)
      .where("prodId", isEqualTo: prodId)
      .get();

  if (snapshot.docs.isEmpty) {
    // first time add
    await addToCartItems.add({
      "userId": uid,
      "prodId": prodId,
      "quantity": 1,
    });
  } else {
    // already exists → increase quantity
    await snapshot.docs.first.reference.update({
      "quantity": FieldValue.increment(1),
    });
  }

  await getCart();
}

  Future<void> deleteFromCartHandler(String prodId) async {
    final snapshot = await addToCartItems
        .where("userId", isEqualTo: uid)
        .where("prodId", isEqualTo: prodId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    await getCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product removed from Cart"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: prods,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No products found"));
              }

              final prodData = snapshot.data!.docs;

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: prodData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final prodId = prodData[index].id;
                  final inCart = cartItems.contains(prodId);

                  return MyCard(
                    imageName: prodData[index]['prodImage'],
                    productName: prodData[index]['prodName'].toString().trim(),
                    productDescription: prodData[index]['prodDescription'],
                    productPrice: prodData[index]['prodPrice'],
                    cartIcon: Icon(
                      inCart ? Icons.remove : Icons.shopping_bag,
                      size: 18,
                      color: inCart ? Colors.red : Colors.blueAccent,
                    ),
                    onPressed: () {
                      if (inCart) {
                        deleteFromCartHandler(prodId);
                      } else {
                        addToCartHandler(prodId);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
