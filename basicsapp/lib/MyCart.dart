import 'package:flutter/material.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(2),
          child: ListTile(
            title: Text("Item $index"),
            leading: Image.network("https://plus.unsplash.com/premium_photo-1669357657874-34944fa0be68?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", width: 50, height: 50,),
            subtitle: Text("Item Description"),
            tileColor: Colors.blueGrey[50],
            trailing: Text("USD.\$300"),
            onTap: (){
              print("Item $index");
            },
            ),
        );
      }, itemCount: 10,),
    );
  }
}
