import 'package:basicsapp/AdminOrderScreen.dart';
import 'package:basicsapp/Login.dart';
import 'package:basicsapp/ViewOfProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  final productsRef = FirebaseFirestore.instance.collection("Products");
  final ordersRef = FirebaseFirestore.instance.collection("orders");
  final usersRef = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Admin Panel",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminOrderScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Products"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ViewOfProducts()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
                );
              },
            ),

          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: ordersRef.snapshots(),
          builder: (context, orderSnapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: productsRef.snapshots(),
              builder: (context, productSnapshot) {
                return StreamBuilder<QuerySnapshot>(
                  stream: usersRef.snapshots(),
                  builder: (context, userSnapshot) {
                    if (!orderSnapshot.hasData ||
                        !productSnapshot.hasData ||
                        !userSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final totalProducts = productSnapshot.data!.docs.length;
                    final totalOrders = orderSnapshot.data!.docs.length;
                    final totalUsers = userSnapshot.data!.docs.length;

                    double revenue = 0;
                    for (var doc in orderSnapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      revenue += (data["total"] ?? 0).toDouble();
                    }

                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: [
                        _dashboardCard(
                          title: "Products",
                          value: totalProducts.toString(),
                          icon: Icons.shopping_bag,
                          color: Colors.blue,
                        ),
                        _dashboardCard(
                          title: "Orders",
                          value: totalOrders.toString(),
                          icon: Icons.receipt_long,
                          color: Colors.green,
                        ),
                        _dashboardCard(
                          title: "Users",
                          value: totalUsers.toString(),
                          icon: Icons.people,
                          color: Colors.orange,
                        ),
                        _dashboardCard(
                          title: "Revenue",
                          value: "USD \$${revenue.toStringAsFixed(2)}",
                          icon: Icons.attach_money,
                          color: Colors.purple,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _dashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }
}
