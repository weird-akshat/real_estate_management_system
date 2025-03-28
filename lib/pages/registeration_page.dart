import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool buttonClicked = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/loginbackground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: !buttonClicked
                ? Column(
                    children: [
                      const Spacer(flex: 2),
                      const Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 50),
                      ),
                      const Spacer(),
                      _buildTextField(
                          Icons.person, 'Full Name', nameController),
                      _buildTextField(
                          Icons.phone, 'Phone Number', phoneController),
                      _buildTextField(Icons.mail, 'Email', emailController),
                      _buildTextField(
                          Icons.password, 'Password', passwordController,
                          obscureText: true),
                      _buildRegisterButton(),
                      const Spacer(flex: 2),
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Future<void> createUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
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

  Future<void> addUserToDataBase() async {
    final url =
        Uri.parse('https://real-estate-flask-api.onrender.com/create_user');

    Map<String, dynamic> data = {
      "user_id": FirebaseAuth.instance.currentUser?.uid,
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
    };
    print("Sending Data: ${jsonEncode(data)}"); // Debugging

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Success: ${response.body}");
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Widget _buildRegisterButton() {
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
        onPressed: buttonClicked
            ? null
            : () async {
                setState(() {
                  buttonClicked = true;
                });

                try {
                  await createUser();
                  await FirebaseAuth.instance.currentUser
                      ?.reload(); // Force update

                  await addUserToDataBase();

                  Navigator.of(context).pop();
                } finally {
                  setState(() {
                    buttonClicked = false;
                  });
                }
              },
        child: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
