import 'package:flutter/material.dart';

class Mytextfeild extends StatelessWidget {
  const Mytextfeild({super.key, required this.hintText, required this.myTextController});
  final String hintText;
  final TextEditingController myTextController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myTextController,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}