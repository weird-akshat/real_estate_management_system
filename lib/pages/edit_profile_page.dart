import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Text(
                  'Edit',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                ),
                const Spacer(),
                _buildTextField(Icons.person, 'Full Name'),
                _buildTextField(Icons.location_city, 'City'),
                _buildTextField(Icons.location_on, 'State'),
                _buildTextField(Icons.map, 'Country'),
                _buildTextField(Icons.numbers, 'ZIP Code'),
                _buildTextField(Icons.phone, 'Phone Number'),
                _buildTextField(Icons.password, 'Password', obscureText: true),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 300,
        child: TextField(
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
