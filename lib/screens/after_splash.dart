import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:selaa/screens/register/redirect_login.dart';
import 'package:selaa/screens/register/pre_register.dart';

class AfterSplash extends StatefulWidget {
  const AfterSplash({Key? key}) : super(key: key);

  @override
  State<AfterSplash> createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); 
        } else {
          if (snapshot.hasData) {
            return const RedirectLogin();
          } else {
            return const PreRegister();
          }            
        }
      },
    );
  }
}