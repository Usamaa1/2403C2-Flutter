import 'dart:convert';
import 'package:basicsapp/CheckoutScreen.dart';
import 'package:basicsapp/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCart extends StatelessWidget {
  MyCart({super.key});

  final cartRef = FirebaseFirestore.instance.collection("addToCart");
  final productsRef = FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // go to login
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      });
      return const Center(child: CircularProgressIndicator());
    }
    final uid = user.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartRef.where("userId", isEqualTo: uid).snapshots(),
        builder: (context, cartSnapshot) {
          if (cartSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!cartSnapshot.hasData || cartSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Cart is empty"));
          }

          final cartDocs = cartSnapshot.data!.docs;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _loadCartProducts(cartDocs),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = snapshot.data!;
              double total = items.fold(
                0,
                (sum, item) => sum + item["price"] * item["quantity"],
              );

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return ListTile(
                          leading: Image.memory(
                            base64Decode(item["image"]),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item["name"]),
                          subtitle: Text("USD \$${item["price"]}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () =>
                                    _updateQty(item["cartDocId"], -1),
                              ),
                              Text(item["quantity"].toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    _updateQty(item["cartDocId"], 1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "USD \$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckoutScreen(),
                                ),
                              );
                            },
                            child: const Text("Checkout"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// 🔄 Load products from Products collection
  Future<List<Map<String, dynamic>>> _loadCartProducts(
    List<QueryDocumentSnapshot> cartDocs,
  ) async {
    List<Map<String, dynamic>> items = [];

    for (var cart in cartDocs) {
      final prod = await productsRef.doc(cart["prodId"]).get();

      if (!prod.exists) continue;

      items.add({
        "cartDocId": cart.id,
        "name": prod["prodName"],
        "price": double.parse(prod["prodPrice"].toString()),
        "image": prod["prodImage"],
        "quantity": cart["quantity"],
      });
    }

    return items;
  }

  /// ➕➖ Update Quantity
  Future<void> _updateQty(String cartDocId, int delta) async {
    final doc = cartRef.doc(cartDocId);
    final snap = await doc.get();
    final qty = snap["quantity"] + delta;

    if (qty <= 0) {
      await doc.delete();
    } else {
      await doc.update({"quantity": qty});
    }
  }
}
