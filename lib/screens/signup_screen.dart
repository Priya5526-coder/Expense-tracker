import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _loading = false;

  Future<void> _register() async {
    if (_username.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.trim().isEmpty ||
        _confirmPassword.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all details")),
      );
      return;
    }

    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        'username': _username.text.trim(),
        'email': _email.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // ✅ No navigation needed
      // AuthWrapper will automatically open Expenses
    } on FirebaseAuthException catch (e) {
      String msg = "Registration failed";

      if (e.code == 'email-already-in-use') {
        msg = "Email already registered";
      } else if (e.code == 'weak-password') {
        msg = "Password must be at least 6 characters";
      } else if (e.code == 'invalid-email') {
        msg = "Invalid email address";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          const Text(
            "Register",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: _username,
            decoration: const InputDecoration(labelText: "Username"),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _confirmPassword,
            obscureText: true,
            decoration:
                const InputDecoration(labelText: "Confirm Password"),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _register,
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : const Text("Register"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
}
