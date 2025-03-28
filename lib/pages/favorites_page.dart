import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/favorite_body_property_list.dart';
import 'package:real_estate_management_system/pages/favorite_provider.dart';
import 'property_listing_page.dart';
import 'package:http/http.dart' as http;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchFavDatawithImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // print(snapshot.data.body);
            var data = snapshot.data!;
            Provider.of<FavoriteProvider>(context, listen: false)
                .addPropertiesFromApi(data.properties);
            Provider.of<FavoriteProvider>(context, listen: false)
                .addImagesFromApi(data.images);

            // print(Provider.of<PropertyDetailsProvider>(context).images);
            // return Text('data');
            return FavoriteBodyPropertyList(data.properties);
          }
        },
      ),
    );
  }

  Future<
      ({
        List<Map<String, dynamic>> properties,
        Map<int, List<String>> images
      })> fetchFavDatawithImages() async {
    Map<int, List<String>> images = {};
    List<Map<String, dynamic>> properties = await fetchFavData();
    // print(properties);
    for (Map<String, dynamic> map in properties) {
      if (images[map['property_id']] == null) {
        images[map['property_id']] = [];
      }

      // print(images);
      String image = await fetchFavImage(map['property_id']);
      images[map['property_id']]!.add(image);
    }

    return (properties: properties, images: images);
  }

  Future<List<Map<String, dynamic>>> fetchFavData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/get_favorite_properties/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Expected a list but got something else');
      }
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future fetchFavImage(int propertyId) async {
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print('Response Data: $data');

      for (Map<String, dynamic> map in data) {
        if (map['is_primary'] == 'Yes') {
          // print(map);
          return map['image_url'];
        }
      }
    } else {
      // print('Error: ${response.statusCode}');
    }
    return response;
  }
}
