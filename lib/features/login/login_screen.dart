import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: const Text("Login with Google"),
        ),
      ),
    );
  }

  signInWithGoogle() async {
    GoogleSignInAccount? user = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await user?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
