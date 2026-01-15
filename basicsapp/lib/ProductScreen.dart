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
  final Stream<QuerySnapshot> prods = FirebaseFirestore.instance
      .collection("Products")
      .snapshots();
  final addToCartItems = FirebaseFirestore.instance.collection("addToCart");

  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getCart();
  }

  void addToCartHandler(String uid, String prodId) {
    addToCartItems.add({"userId": uid, "prodId": prodId});
  }

  void deleteToCartHandler(var prodId) {
   var itemToDelte= addToCartItems
        .where("userId", isEqualTo: uid)
        .where("prodId", isEqualTo: prodId);
  }

  var cartItems = [];

  void getCart() async {
    var getCartItems = await addToCartItems
        .where("userId", isEqualTo: uid)
        .get();
    print("Hello");
    print(getCartItems.docs);

    for (var el in getCartItems.docs) {
      cartItems.add(el["prodId"]);
    }

    print(cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Our Products!"),
          Flexible(
            child: StreamBuilder(
              stream: prods,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return GridView.builder(
                  itemCount: snapshot.data!.size,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 300,
                    // crossAxisSpacing: 30,
                    // mainAxisSpacing: 30,
                  ),
                  itemBuilder: (context, index) {
                    final prodData = snapshot.data!.docs;

                    return MyCard(
                      onPressed: () {
                        print("Click event occurs");
                        print(uid);
                        print(prodData[index].id);

                        if (cartItems.contains(prodData[index].id)) {
                        } else {
                          addToCartHandler(uid, prodData[index].id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Product added to your Cart",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                        }
                      },
                      cartIcon: cartItems.contains(prodData[index].id)
                          ? Icon(Icons.remove, size: 18)
                          : Icon(
                              Icons.shopping_bag,
                              size: 18,
                              color: Colors.blueAccent,
                            ),
                      imageName: prodData[index]['prodImage'],
                      productName: prodData[index]['prodName'],
                      productDescription: prodData[index]['prodDescription'],
                      productPrice: prodData[index]['prodPrice'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}