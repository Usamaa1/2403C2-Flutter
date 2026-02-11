import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddEditAddressScreen extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? data;

  const AddEditAddressScreen({super.key, this.docId, this.data});

  @override
  State<AddEditAddressScreen> createState() =>
      _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final ref = FirebaseFirestore.instance.collection("addresses");

  final name = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  final street = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      name.text = widget.data!["fullName"];
      phone.text = widget.data!["phone"];
      city.text = widget.data!["city"];
      street.text = widget.data!["street"];
    }
  }

  Future<void> save() async {
    final body = {
      "userId": uid,
      "fullName": name.text,
      "phone": phone.text,
      "city": city.text,
      "street": street.text,
    };

    if (widget.docId == null) {
      await ref.add(body);
    } else {
      await ref.doc(widget.docId).update(body);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.docId == null
              ? "Add Address"
              : "Edit Address")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone")),
            TextField(controller: city, decoration: const InputDecoration(labelText: "City")),
            TextField(controller: street, decoration: const InputDecoration(labelText: "Street")),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
