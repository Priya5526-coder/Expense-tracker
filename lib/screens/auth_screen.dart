import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B8F75),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 📱 MOBILE VIEW
            if (constraints.maxWidth < 700) {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: const [
                    SizedBox(height: 40),

                    // 🔹 Tabs
                    TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: [
                        Tab(text: "Login"),
                        Tab(text: "Register"),
                      ],
                    ),

                    // 🔹 Screens
                    Expanded(
                      child: TabBarView(
                        children: [
                          LoginScreen(),
                          SignupScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // 💻 WEB / TABLET VIEW
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: const LoginScreen(),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: const SignupScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
