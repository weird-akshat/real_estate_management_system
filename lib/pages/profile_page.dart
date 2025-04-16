import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/edit_profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_management_system/pages/property_listing_page.dart';

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
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Separate method to fetch user data
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      map = await getUserDetails();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading profile: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      fontSize: 20,
    );

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading profile...')
                  ],
                ),
              )
            : Center(
                child: LayoutBuilder(
                  builder: (context, constraints) => RefreshIndicator(
                    onRefresh: () async {
                      await _fetchUserData();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name',
                                              style: textStyle,
                                            ),
                                            TextField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  labelText: map['name'] ??
                                                      'Not available'),
                                            ),
                                            Text(
                                              'Email',
                                              style: textStyle,
                                            ),
                                            TextField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  labelText: map['email'] ??
                                                      'Not available'),
                                            ),
                                            Text(
                                              'Phone',
                                              style: textStyle,
                                            ),
                                            TextField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  labelText: map['phone'] ??
                                                      'Not available'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfilePage()));

                                    // Show loading indicator while refreshing data
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      map = await getUserDetails();
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Edit',
                                    style: textStyle.copyWith(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

// Modified fetchProperties function for better error handling
Future<List<Map<String, dynamic>>> fetchProperties() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final url = Uri.parse(
      'https://real-estate-flask-api.onrender.com/user_offers/$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        // Fetch image URLs concurrently
        List<Map<String, dynamic>> propertiesWithImages = [];

        for (var property in data) {
          int propertyId = property['property_id'];
          try {
            // Fetch the image URL for each property
            String imagePath = await fetchImage(propertyId);

            // Properly format the image URL
            if (imagePath.startsWith('http')) {
              property['image_url'] = imagePath;
            } else {
              property['image_url'] = imagePath;
            }
          } catch (e) {
            property['image_url'] =
                '/api/get_image/$propertyId'; // Fallback path
          }

          propertiesWithImages.add(property);
        }

        return propertiesWithImages;
      } else {
        throw Exception('Expected a list but got something else');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
