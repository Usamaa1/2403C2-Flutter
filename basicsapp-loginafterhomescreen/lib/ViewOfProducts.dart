import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:basicsapp/AddProducts.dart';
import 'package:basicsapp/MyTextFeild.dart';

class ViewOfProducts extends StatefulWidget {
  const ViewOfProducts({super.key});

  @override
  State<ViewOfProducts> createState() => _ViewOfProductsState();
}

class _ViewOfProductsState extends State<ViewOfProducts> {
  final Stream<QuerySnapshot> prods = FirebaseFirestore.instance
      .collection("Products")
      .snapshots();

  Future<void> deleteHandler(String id) async {
    try {
      await FirebaseFirestore.instance.collection("Products").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  String? imageGlobal;

  void showDialogBox(
    String id,
    String prodName,
    String prodPrice,
    String prodDesc,
    String prodImage,
  ) {
    TextEditingController upProdName = TextEditingController();
    TextEditingController upProdPrice = TextEditingController();
    TextEditingController upProdDesc = TextEditingController();

    upProdName.text = prodName;
    upProdPrice.text = prodPrice;
    upProdDesc.text = prodDesc;

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
          // print(base64Image);

          setState(() {
            imageGlobal = base64Image;
            print("Set state");
            print(imageGlobal);
            showDialogBox(
              id = id,
              prodName = prodName,
              prodDesc = prodDesc,
              prodPrice = prodPrice,
              prodImage = imageGlobal!,
            );
          });
        }
      } catch (e) {
        print(e);
      }
    }

    String productImage = imageGlobal ?? prodImage;
    print("Global Image");
    print(imageGlobal);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Product"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(base64Decode(productImage), width: 200, height: 200),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Mytextfeild(
                  hintText: "Product Name",
                  myTextController: upProdName,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Mytextfeild(
                  hintText: "Product Price",
                  myTextController: upProdPrice,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Mytextfeild(
                  hintText: "Product Description",
                  myTextController: upProdDesc,
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
                onPressed: () {
                  updateHandler(
                    id,
                    upProdName.text,
                    upProdPrice.text,
                    upProdDesc.text,
                    productImage,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 114, 255),
                  foregroundColor: Colors.white,
                ),
                child: Text("Update Product"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateHandler(
    String id,
    String prodName,
    String prodPrice,
    String prodDesc,
    String prodImage,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("Products").doc(id).update({
        'prodName': prodName,
        'prodPrice': prodPrice,
        'prodDescription': prodDesc,
        'prodImage': prodImage,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("View Products")),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProducts()),
            ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: prods,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Server ${snapshot.error}");
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text("Empty data");
          }
          var prodData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: prodData.length,
            itemBuilder: (context, index) {
              print(prodData[index].id);
              return ListTile(
                title: Text(prodData[index]["prodName"] ?? ''),
                subtitle: Text(
                  "${prodData[index]['prodDescription'] ?? ''} | ${prodData[index]['prodPrice'] ?? ''}",
                ),
                leading: CircleAvatar(
                  backgroundImage: MemoryImage(
                    base64Decode(prodData[index]["prodImage"] ?? ''),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        deleteHandler(prodData[index].id);
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialogBox(
                          prodData[index].id,
                          prodData[index]["prodName"],
                          prodData[index]["prodPrice"],
                          prodData[index]["prodDescription"],
                          prodData[index]["prodImage"],
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
                tileColor: index % 2 == 1
                    ? const Color.fromARGB(255, 219, 219, 219)
                    : const Color.fromARGB(255, 221, 242, 255),
              );
            },
          );
        },
      ),
    );
  }
}