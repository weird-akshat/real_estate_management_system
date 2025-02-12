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
            'assets/images/image3.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          // color: Colors.blue,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth * .8,
                    height: height * 0.55,
                    child: Card(
                      color: Colors.transparent.withValues(alpha: .08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      shadowColor: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  'Login',
                                  textScaler: TextScaler.linear(3),
                                  style: style,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Email',
                                textScaler: TextScaler.linear(1.5),
                                style: style,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                style: style,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Password',
                                textScaler: TextScaler.linear(1.5),
                                style: style,
                              ),
                            ),
                            TextField(
                              style: style,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: LayoutBuilder(
                                builder: (context, constraints) => Center(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(Size(
                                          constraints.maxWidth * 0.8,
                                          constraints.maxHeight)),
                                    ),
                                    child: Text(
                                      'Log In',
                                      style:
                                          style.copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                    Text("Don't have an account? ",
                                        style: style),
                                    Text(
                                      'Register',
                                      style:
                                          TextStyle(color: Colors.deepPurple),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
