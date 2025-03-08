import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/login_page.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PropertyListingPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    );
  }
}
