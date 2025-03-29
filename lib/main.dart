import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/firebase_options.dart';
import 'package:real_estate_management_system/pages/add_image_page.dart';
import 'package:real_estate_management_system/pages/add_property_page.dart';
import 'package:real_estate_management_system/pages/favorite_provider.dart';
import 'package:real_estate_management_system/pages/favorites_page.dart';
import 'package:real_estate_management_system/pages/filter_page.dart';
import 'package:real_estate_management_system/pages/home_page.dart';
import 'package:real_estate_management_system/pages/login_page.dart';
import 'package:real_estate_management_system/pages/negotiation_chat.dart';
import 'package:real_estate_management_system/pages/owned_properties_provider.dart';
import 'package:real_estate_management_system/pages/owned_property_page.dart';
import 'package:real_estate_management_system/pages/profile_page.dart';
import 'package:real_estate_management_system/pages/property_details.dart';
// import 'package:real_estate_management_system/pages/login_page.dart';
import 'package:real_estate_management_system/pages/property_listing_page.dart';
import 'package:real_estate_management_system/pages/propertyid_provider.dart';
import 'package:real_estate_management_system/pages/registeration_page.dart';
import 'package:real_estate_management_system/pages/visit_chat.dart';
import 'package:real_estate_management_system/property_details_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PropertyidProvider()),
        ChangeNotifierProvider(create: (context) => PropertyDetailsProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => OwnedPropertiesProvider())
        // ChangeNotifierProvider(create: (context) => ImageProvider())
      ],
      child: MaterialApp(
        home: StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data != null) {
                return const HomePage();
              }
              return const LoginPage();
            }),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.gentiumPlusTextTheme(),
        ),
      ),
    );
  }
}
