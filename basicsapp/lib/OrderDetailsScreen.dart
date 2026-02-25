import 'dart:convert';
import 'package:basicsapp/ReviewSection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ordersRef = FirebaseFirestore.instance.collection("orders");
    final orderItemsRef = FirebaseFirestore.instance.collection("orderItems");
    final productsRef = FirebaseFirestore.instance.collection("Products");

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: ordersRef.doc(orderId).get(),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!orderSnapshot.hasData || !orderSnapshot.data!.exists) {
            return const Center(child: Text("Order not found"));
          }

          final order = orderSnapshot.data!.data() as Map<String, dynamic>;
          final status = order["status"] ?? "processing";

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.green.shade50,
                child: Text(
                  "Order Status: $status",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: orderItemsRef.where("orderId", isEqualTo: orderId).snapshots(),
                  builder: (context, itemSnapshot) {
                    if (!itemSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final items = itemSnapshot.data!.docs;

                    if (items.isEmpty) {
                      return const Center(child: Text("No items"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index].data() as Map<String, dynamic>;
                        final productId = item["productId"];
                        final quantity = item["quantity"] ?? 1;
                        final price = (item["price"] ?? 0).toDouble();

                        return FutureBuilder<DocumentSnapshot>(
                          future: productsRef.doc(productId).get(),
                          builder: (context, prodSnapshot) {
                            if (!prodSnapshot.hasData ||
                                !prodSnapshot.data!.exists) {
                              return const SizedBox();
                            }

                            final product =
                                prodSnapshot.data!.data() as Map<String, dynamic>;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        product["prodImage"]?.isNotEmpty == true
                                            ? Image.memory(
                                                base64Decode(product["prodImage"]),
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Icons.image, size: 70),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product["prodName"] ?? "",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(product["prodDescription"] ?? ""),
                                              Text(
                                                "USD \$${price.toStringAsFixed(2)} x $quantity",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (status == "delivered")
                                      ReviewSection(
                                        productId: productId,
                                        status: status,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
