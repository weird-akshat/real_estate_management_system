import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/property_details.dart';

class PropertyDetailsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> list = [];
  Map<int, List<String>> images = {};
  //the idea is to store the property_id and the images

  void addPropertiesFromApi(List<Map<String, dynamic>> list) {
    this.list = list;
    // print(list);
    notifyListeners();
  }

  void addImagesFromApi(Map<int, List<String>> images) {
    this.images = images;
    // print(images);

    notifyListeners();
  }
}
