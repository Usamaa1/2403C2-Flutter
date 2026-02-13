import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basicsapp/Home.dart';
import 'package:basicsapp/Login.dart';
import 'package:basicsapp/MyTextFeild.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    signupHandler() async {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );

        await credential.user!.sendEmailVerification();

        print(credential);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 42, 131),
            duration: Duration(seconds: 8),
            content: Text("Your account is created successfully!"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );

        
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The password provided is too weak.")),
          );
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(255, 255, 42, 131),
              duration: Duration(seconds: 8),
              content: Text("The account already exists for that email."),
            ),
          );
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }

    Future<UserCredential> signInWithGoogle() async {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope(
        'https://www.googleapis.com/auth/contacts.readonly',
      );
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // Or use signInWithRedirect
      // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
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
                Text("Signup Screen", style: TextStyle(fontSize: 28)),
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
                ElevatedButton(onPressed: signupHandler, child: Text("Signup")),
                SizedBox(height: 10),
                InkWell(
                  child: Text("Login"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: signInWithGoogle,
                  label: Text("Signup with Google"),
                  icon: Icon(Icons.g_mobiledata),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}