import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'materia';

Future<void> makeVisit(Map<String, dynamic> map) async {
  final url = Uri.parse('https://real-estate-flask-api.onrender.com/add_visit');

  final response = await http.post(url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(map));

  if (response.statusCode == 200 || response.statusCode == 201) {
    debugPrint("Success: ${response.body}");
  } else {
    debugPrint("Error: ${response.statusCode} - ${response.body}");
  }
}
