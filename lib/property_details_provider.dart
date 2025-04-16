import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/property_details.dart';

class PropertyDetailsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> list = [];
  Map<int, List<String>> images = {};

  void updateFilteredProperties(List<Map<String, dynamic>> filteredProperties) {
    list = filteredProperties;
    notifyListeners();
  }

  void addPropertiesFromApi(List<Map<String, dynamic>> properties) {
    list = properties;
    notifyListeners();
  }

  void addImagesFromApi(Map<int, List<String>> newImages) {
    images = newImages;
    notifyListeners();
  }

  // Optionally add this method to clear filters
  void clearFilters() {
    list = [];
    images = {};
    notifyListeners();
  }
}
