import 'package:flutter/material.dart';

class PropertyidProvider extends ChangeNotifier {
  int? propertyId;
  void setPropertyId(int id) {
    propertyId = id;
    notifyListeners();
  }
}
