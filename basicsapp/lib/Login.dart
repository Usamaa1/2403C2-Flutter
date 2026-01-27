import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basicsapp/Home.dart';
import 'package:basicsapp/MyTextFeild.dart';
import 'package:basicsapp/Signup.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    loginHandler() async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );

        if (credential.user!.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          print("Email is not verified");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          child: Text("Go to Home Screen"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login Screen", style: TextStyle(fontSize: 28)),
                SizedBox(height: 40),
                Mytextfeild(
                  hintText: "Enter your email!",
                  myTextController: email,
                ),
                SizedBox(height: 10),
                Mytextfeild(
                  hintText: "Enter your Password!",
                  myTextController: password,
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: loginHandler, child: Text("Login")),
                SizedBox(height: 10),
                InkWell(
                  child: Text("Signup"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
