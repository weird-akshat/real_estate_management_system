import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> list = [];
  Map<int, List<String>> images = {};
  //the idea is to store the property_id and the images

  void addPropertiesFromApi(List<Map<String, dynamic>> list) {
    this.list = list;
    // print(list);
    notifyListeners();
  }

  void removePropertyFromApi(int propertyId) {
    list.removeWhere((map) => map['property_id'] == propertyId);
    notifyListeners();
  }

  void addImagesFromApi(Map<int, List<String>> images) {
    this.images = images;
    // print(images);

    notifyListeners();
  }
}
