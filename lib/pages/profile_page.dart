import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/edit_profile_page.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

Future<Map<String, dynamic>> getUserDetails() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final url =
      Uri.parse("https://real-estate-flask-api.onrender.com/user/$userId");

  final response = await http.get(url);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // print(response.body);
    return jsonDecode(response.body);
  } else {
    return {};
  }
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> map = {};
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      map = await getUserDetails();
      // print(map);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      fontSize: 20,
    );

    // final textStyle = TextStyle(fontSize: constraints.maxWidth);
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        foregroundColor: Colors.black,
                        radius: constraints.maxWidth * .16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: constraints.maxWidth * .17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 5,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: textStyle,
                                ),
                                TextField(
                                  enabled: false,
                                  decoration:
                                      InputDecoration(labelText: map['name']),
                                ),
                                Text(
                                  'Email',
                                  style: textStyle,
                                ),
                                TextField(
                                  enabled: false,
                                  decoration:
                                      InputDecoration(labelText: map['email']),
                                ),
                                Text(
                                  'Phone',
                                  style: textStyle,
                                ),
                                TextField(
                                  enabled: false,
                                  decoration:
                                      InputDecoration(labelText: map['phone']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfilePage()));

                          map = await getUserDetails();
                          print(map);
                          setState(() {});
                        },
                        child: Text(
                          'Edit',
                          style: textStyle.copyWith(fontSize: 15),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
