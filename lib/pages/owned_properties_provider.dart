import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OwnedPropertiesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> properties = [];
  Map<int, List<String>> images = {};

  Future<void> getOwnedProperties() async {
    String ownerId = FirebaseAuth.instance.currentUser!.uid;
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/get_properties_by_owner?owner_id=$ownerId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      properties = List<Map<String, dynamic>>.from(jsonDecode(response.body));

      List<Future<void>> fetchImagesFutures = properties.map((map) async {
        int propertyId = map['property_id'];
        images[propertyId] = [];
        String? image = await fetchOwnedImage(propertyId);
        if (image != null) {
          images[propertyId]!.add(image);
        }
      }).toList();

      await Future.wait(fetchImagesFutures);
      print(images);
      // print(properties);
      // print(images);
      notifyListeners();
    }
  }

  Future<String?> fetchOwnedImage(int propertyId) async {
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (var map in data) {
        if (map['is_primary'] == 'Yes') {
          return map['image_url'];
        }
      }
    }
    return null;
  }
}
