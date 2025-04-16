import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/negotiation_chat.dart';

import 'package:http/http.dart' as http;
import 'package:real_estate_management_system/pages/visit_chat.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<VisitPage> createState() => _NegotiationPageState();
}

class _NegotiationPageState extends State<VisitPage> {
  void onRefresh() {
    setState(() {});
  }

  List<Map<String, dynamic>> list = [];
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Separate method to fetch data
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> fetchedList = await fetchProperties();
      if (mounted) {
        setState(() {
          list = fetchedList;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading visit properties: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator when fetching data
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading visited properties...')
          ],
        ),
      );
    }

    // Show message if no properties found
    if (list.isEmpty) {
      return Center(
        child: Text('No Property Found'),
      );
    }

    // Show property list
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchData();
      },
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => NegotiationBodyPropertyCard(
              image: list[index]['image_url'].startsWith('http')
                  ? list[index]['image_url']
                  : 'https://real-estate-flask-api.onrender.com${list[index]['image_url']}',
              index: index,
              propertyId: int.parse(list[index]['property_id'].toString()),
              price: list[index]['price'].toString(),
              area: list[index]['area'].toString(),
              numBed: list[index]['bedrooms'].toString() + " BHK",
              propertyName: list[index]['name'].toString(),
              onRefresh: onRefresh)),
    );
  }
}

Future<String> fetchImage(int propertyId) async {
  final url = Uri.parse(
    'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId',
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty) {
        for (Map<String, dynamic> map in data) {
          if (map['is_primary'] == 'Yes') {
            return map['image_url'];
          }
        }
        // If no primary image found but we have images, return the first one
        return data[0]['image_url'];
      }
    }
    // If we reach here, something went wrong
    return '/api/get_image/$propertyId'; // Fallback to direct API call
  } catch (e) {
    print('Error fetching image: $e');
    return '/api/get_image/$propertyId'; // Fallback on error
  }
}

Future<List<Map<String, dynamic>>> fetchProperties() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final url = Uri.parse(
      'https://real-estate-flask-api.onrender.com/user/$userId/visited-properties');

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
          print('Error processing property image: $e');
          property['image_url'] = '/api/get_image/$propertyId'; // Fallback path
        }

        propertiesWithImages.add(property);
      }

      return propertiesWithImages;
    } else {
      throw Exception('Expected a list but got something else');
    }
  } else {
    throw Exception('Error: ${response.statusCode}');
  }
}

class NegotiationBodyPropertyCard extends StatelessWidget {
  final int index;
  final int propertyId;
  final String propertyName;
  final String numBed;
  final String area;
  final String price;
  final String image;
  final VoidCallback onRefresh;
  const NegotiationBodyPropertyCard(
      {super.key,
      required this.image,
      required this.index,
      required this.propertyId,
      required this.price,
      required this.area,
      required this.numBed,
      required this.propertyName,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return VisitChat(
            buyerId: FirebaseAuth.instance.currentUser!.uid,
            propertyId: propertyId,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(),
        child: Card(
          color: Color(0xffd8e2dc),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black, width: 0)),
          surfaceTintColor: Colors.white70,
          margin: EdgeInsets.all(10),
          elevation: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    image,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Image.network(
                        'https://via.placeholder.com/150',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                propertyName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bed),
                        Text(numBed),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop),
                        Text(area),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.currency_rupee),
                        Text(price),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
