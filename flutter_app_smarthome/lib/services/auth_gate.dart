import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_smarthome/login/login.dart';
import 'package:flutter_app_smarthome/login/lyr_homepage.dart';



class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder <User?> (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot)  {
        if (!snapshot.hasData){
          return LoginPage();
        }
        return HomePage();
      },
    );
  }
}
