import 'package:basicsapp/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  MyOrdersScreen({super.key});



  final ordersRef = FirebaseFirestore.instance.collection("orders");

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    await ordersRef.doc(orderId).update({"status": "cancelled"});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order cancelled")));
  }

  @override
  Widget build(BuildContext context) {
     final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    Future.microtask(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  final uid = user.uid;
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef.where("userId", isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              final timestamp = order["createdAt"] as Timestamp?;
              final date = timestamp != null
                  ? timestamp.toDate().toString().substring(0, 16)
                  : "";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order.id.substring(0, 6)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text("Total: USD \$${order["total"]}"),
                      Text("Status: ${order["status"]}"),
                      Text(date),

                      const SizedBox(height: 10),

                      /// Cancel Button
                      if (order["status"] == "pending" ||
                          order["status"] == "confirmed")
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white
                            ),
                            onPressed: () => _cancelOrder(context, order.id),
                            child: const Text("Cancel Order"),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
