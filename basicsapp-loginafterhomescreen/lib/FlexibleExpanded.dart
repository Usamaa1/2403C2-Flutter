import 'package:flutter/material.dart';

class FlexibleExpanded extends StatelessWidget {
  const FlexibleExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // child: Column(
        //   children: [
        //     // Container(color: Colors.blueAccent),
        //     Flexible(
        //       flex: 3,
        //       child:Container(color: Colors.amber),
        //     ),
        //     Expanded(flex: 1, child: Container(color: Colors.redAccent)),
        //   ],
        // ),
        child: Row(
          children: [
            // Container(color: Colors.blueAccent),
            Flexible(
              child:Container(width: 100,color: Colors.amber),
            ),
            Expanded(child: Container(width: 100, color: Colors.redAccent)),
          ],
        ),
      ),
    );
  }
}
