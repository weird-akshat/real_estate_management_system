import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_management_system/pages/add_property_page.dart';
import 'package:real_estate_management_system/pages/favorites_page.dart';
import 'package:real_estate_management_system/pages/login_page.dart';
import 'package:real_estate_management_system/pages/owned_property_page.dart';
import 'package:real_estate_management_system/pages/property_details.dart';
// import 'package:real_estate_management_system/pages/login_page.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';
import 'package:real_estate_management_system/pages/registeration_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.gentiumPlusTextTheme(),
        ));
  }
}
