import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:expense_tracker/widgets/expenses.dart';
import 'welcome_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ⏳ While checking login state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ✅ Logged in user
        if (snapshot.hasData) {
          return const Expenses();
        }

        // ❌ Not logged in
        return const WelcomeScreen();
      },
    );
  }
}
