// import 'package:flutter/material.dart';

// class MyCard extends StatelessWidget {
//   const MyCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.network(
//                   "https://images.unsplash.com/photo-1763587239043-47e583ac0cb1?q=80&w=974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//                   width: 200,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4,bottom: 4),
//                   child: Text("Product 1"),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4,bottom: 4),
//                   child: Text("Product Description"),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4,bottom: 8),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.star, size: 14),
//                       Icon(Icons.star, size: 14),
//                       Icon(Icons.star, size: 14),
//                       Icon(Icons.star, size: 14),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.imageName,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.onPressed,
    required this.cartIcon,
  });

  final String imageName;
  final String productName;
  final String productDescription;
  final String productPrice;
  final Icon cartIcon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 233, 233, 233),
      elevation: 10,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Image.memory(
                width: double.infinity,
                height: 140,
                base64Decode(imageName),
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  maxRadius: 18,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  child: IconButton(onPressed: onPressed, icon: cartIcon),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(productName, style: TextStyle(fontSize: 18)),
          SizedBox(height: 6),
          Text(productPrice),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(productDescription,maxLines: 1,),
          ),
          // SizedBox(height: 6),
        ],
      ),
    );
  }
}
