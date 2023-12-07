import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ieee_fsb_hr/features/login/login_screen.dart';
import 'package:ieee_fsb_hr/firebase_options.dart';

import 'features/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorScreen();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const Login();
          } else {
            return Home(
              userEmail: (FirebaseAuth.instance.currentUser?.email)!,
              name: (FirebaseAuth.instance.currentUser?.displayName)!,
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Error")));
  }
}
