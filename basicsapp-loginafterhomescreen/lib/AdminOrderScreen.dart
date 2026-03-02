import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderScreen extends StatelessWidget {
  final ordersRef = FirebaseFirestore.instance.collection("orders");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Orders")),
      body: StreamBuilder(
        stream: ordersRef.orderBy("createdAt", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text("Order #${order.id.substring(0, 6)}"),
                  subtitle: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("addresses")
                        .where("userId", isEqualTo: data["userId"])
                        .limit(1)
                        .get(),
                    builder: (context, addressSnap) {
                      String addressText = "No address";

                      if (addressSnap.hasData &&
                          addressSnap.data!.docs.isNotEmpty) {
                        final addr =
                            addressSnap.data!.docs.first.data()
                                as Map<String, dynamic>;

                        addressText =
                            "${addr["fullName"]}\n${addr["street"]}, ${addr["city"]}\n${addr["phone"]}";
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total: USD \$${data["total"]}"),
                          Text("Status: ${data["status"] ?? "pending"}"),
                          const SizedBox(height: 6),
                          Text(addressText),
                        ],
                      );
                    },
                  ),

                  trailing: DropdownButton<String>(
                    value: (data["status"] ?? "pending"),
                    items: const [
                      DropdownMenuItem(
                        value: "pending",
                        child: Text("Pending"),
                      ),
                      DropdownMenuItem(
                        value: "confirmed",
                        child: Text("Confirmed"),
                      ),
                      DropdownMenuItem(
                        value: "shipped",
                        child: Text("Shipped"),
                      ),
                      DropdownMenuItem(
                        value: "delivered",
                        child: Text("Delivered"),
                      ),
                      DropdownMenuItem(
                        value: "cancelled",
                        child: Text("Cancelled"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      ordersRef.doc(order.id).update({"status": value});
                    },
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
