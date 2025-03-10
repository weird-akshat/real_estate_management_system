import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextStyle style = GoogleFonts.lato(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

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
              Spacer(
                flex: 3,
              ),
              Text(
                'Dwell',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70),
              ),
              Spacer(
                flex: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Phone number',
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.password),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        fixedSize: WidgetStatePropertyAll(Size(300, 50))),
                    onPressed: () {},
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              Center(
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
              Spacer(
                flex: 3,
              )
            ],
          ),
        )
      ]),
    );
  }
}
