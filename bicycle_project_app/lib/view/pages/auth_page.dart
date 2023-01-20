import 'package:bicycle_project_app/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //로그인한경우
          if (snapshot.hasData) {
            return const Home();
          }
          //로그인하지 않은 경우
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
