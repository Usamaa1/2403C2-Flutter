import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  MyOrdersScreen({super.key});

  final uid = FirebaseAuth.instance.currentUser!.uid;

  final ordersRef = FirebaseFirestore.instance.collection("orders");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef
            .where("userId", isEqualTo: uid)
          
            .snapshots(),
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
                child: ListTile(
                  title: Text("Order #${order.id.substring(0, 6)}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total: USD \$${order["total"]}"),
                      Text("Status: ${order["status"]}"),
                      Text(date),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // next we can open order details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
