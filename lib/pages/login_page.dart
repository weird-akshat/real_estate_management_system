import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/home_page.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';
import 'registeration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/loginbackground.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            children: [
              const Spacer(flex: 3),
              const Text(
                'Dwell',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70),
              ),
              const Spacer(flex: 2),
              _buildTextField(Icons.mail, 'Email', emailController),
              _buildTextField(Icons.password, 'Password', passwordController,
                  obscureText: true),
              _buildLoginButton(context),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationPage()),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        )
      ]),
    );
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Widget _buildTextField(IconData icon, String hint, TextEditingController t,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: t,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon),
            hintText: hint,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.black),
          fixedSize: const WidgetStatePropertyAll(Size(300, 50)),
        ),
        onPressed: () async {
          login();
        },
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
