import 'dart:convert';
import 'package:basicsapp/AddEditAddressScreen.dart';
import 'package:basicsapp/OrderSuccessScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final cartRef = FirebaseFirestore.instance.collection("addToCart");
  final productsRef = FirebaseFirestore.instance.collection("Products");
  final ordersRef = FirebaseFirestore.instance.collection("orders");
  final orderItemsRef = FirebaseFirestore.instance.collection("orderItems");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
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

              double subtotal = items.fold(
                0,
                (sum, item) => sum + item["price"] * item["quantity"],
              );

              double shipping = 5;
              double tax = subtotal * 0.05;
              double total = subtotal + shipping + tax;

              return Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("addresses")
                        .where("userId", isEqualTo: uid)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return ListTile(
                          title: const Text("No address found"),
                          trailing: TextButton(
                            child: const Text("Add"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditAddressScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      final data = snapshot.data!.docs.first;

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.grey.shade200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivery Address",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(data["fullName"]),
                            Text(data["street"]),
                            Text(data["city"]),
                            Text(data["phone"]),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: const Text("Change"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditAddressScreen(
                                        docId: data.id,
                                        data:
                                            data.data() as Map<String, dynamic>,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

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
                          subtitle: Text(
                            "USD \$${item["price"]}  x ${item["quantity"]}",
                          ),
                        );
                      },
                    ),
                  ),

                  /// Price Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _priceRow("Subtotal", subtotal),
                        _priceRow("Shipping", shipping),
                        _priceRow("Tax", tax),
                        const Divider(),
                        _priceRow("Total", total, bold: true),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                _placeOrder(context, items, total, cartDocs),
                            child: const Text("Place Order"),
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

  Widget _priceRow(String title, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: bold
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              : null,
        ),
        Text(
          "USD \$${value.toStringAsFixed(2)}",
          style: bold
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              : null,
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _loadCartProducts(
    List<QueryDocumentSnapshot> cartDocs,
  ) async {
    List<Map<String, dynamic>> items = [];

    for (var cart in cartDocs) {
      final prod = await productsRef.doc(cart["prodId"]).get();
      if (!prod.exists) continue;

      items.add({
        "prodId": cart["prodId"],
        "name": prod["prodName"],
        "price": double.parse(prod["prodPrice"].toString()),
        "image": prod["prodImage"],
        "quantity": cart["quantity"] ?? 1,
      });
    }

    return items;
  }

 Future<void> _placeOrder(
  BuildContext context,
  List<Map<String, dynamic>> items,
  double total,
  List<QueryDocumentSnapshot> cartDocs,
) async {
  final order = await ordersRef.add({
    "userId": uid,
    "total": total,
    "status": "pending",
    "createdAt": FieldValue.serverTimestamp(),
  });

  for (var item in items) {
    await orderItemsRef.add({
      "orderId": order.id,
      "productId": item["prodId"],
      "price": item["price"],
      "quantity": item["quantity"],
    });
  }

  /// ✅ MOVE NAVIGATION HERE
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => OrderSuccessScreen(orderId: order.id),
    ),
  );

  /// ✅ clear cart AFTER navigation
  for (var cart in cartDocs) {
    await cart.reference.delete();
  }
}

}
