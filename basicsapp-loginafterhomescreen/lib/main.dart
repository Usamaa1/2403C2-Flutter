import 'package:basicsapp/Home.dart';
import 'package:basicsapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
     
      // home: FlexibleExpanded(),
      // home: MyCard(),
      // home: Home(),
      // home: MyTabbarView(),
      // home: LayoutScreen(),
      // home: Counter(),
      // home: MyProducts(),
      // home: Login(),
      home: Home()
    );
  }
}
