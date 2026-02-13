import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:basicsapp/MyTextFeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController prodName = TextEditingController();
  TextEditingController prodPrice = TextEditingController();
  TextEditingController prodDesc = TextEditingController();

  String? imageGlobal;

  Future<void> pickImage() async {
    try {
      var pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      // print(pickedImage != null);

      if (pickedImage != null) {
        Uint8List image = await pickedImage.readAsBytes();
        String base64Image = base64Encode(image);

        print("Image Bytes");
        print(base64Image);

        setState(() {
          imageGlobal = base64Image;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  CollectionReference products = FirebaseFirestore.instance.collection(
    'Products',
  );

  Future<void> addProducts() async {
    try {
      await products.add({
        "prodName": prodName.text,
        "prodPrice": prodPrice.text,
        "prodDescription": prodDesc.text,
        "prodImage": imageGlobal,
      });
      print("Product added");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 42, 131),
          duration: Duration(seconds: 8),
          content: Text("Product Added!"),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Products")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageGlobal != null
              ? Image.memory(
                  base64Decode(imageGlobal!),
                  width: 200,
                  height: 200,
                )
              : Text("Image not selected"),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Mytextfeild(
              hintText: "Product Name",
              myTextController: prodName,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Mytextfeild(
              hintText: "Product Price",
              myTextController: prodPrice,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Mytextfeild(
              hintText: "Product Description",
              myTextController: prodDesc,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 114, 255),
              foregroundColor: Colors.white,
            ),
            onPressed: pickImage,
            label: Text("Choose file"),
            icon: Icon(Icons.file_upload),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: addProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 114, 255),
              foregroundColor: Colors.white,
            ),
            child: Text("Add Product"),
          ),
        ],
      ),
    );
  }
}