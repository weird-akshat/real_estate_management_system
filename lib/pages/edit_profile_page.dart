import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  Future updateUser(Map<String, dynamic> map) async {
    final url =
        Uri.parse("https://real-estate-flask-api.onrender.com/update_user");
    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(map));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
    } else {
      print("error");
    }
  }

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // const Spacer(flex: 2),
                  const Text(
                    'Edit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  // const Spacer(),
                  _buildTextField(Icons.person, 'Full Name', nameController),
                  _buildTextField(Icons.phone, 'Phone Number', phoneController),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.black),
                        fixedSize: const WidgetStatePropertyAll(Size(300, 50)),
                      ),
                      onPressed: () async {
                        final map = {
                          "user_id": FirebaseAuth.instance.currentUser!.uid,
                          "name": nameController.text.trim(),
                          "phone": phoneController.text.trim(),
                        };
                        await updateUser(map);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
}
