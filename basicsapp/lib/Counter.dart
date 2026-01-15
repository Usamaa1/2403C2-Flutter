import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
    });
    print(counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter")),
      body: Column(
        children: [
          Center(child: Text("Counter")),
          SizedBox(height: 50),
          Text(counter.toString()),
          ElevatedButton(onPressed: increment, child: Text("Increment")),
        ],
      ),
    );
  }
}
