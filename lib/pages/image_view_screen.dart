import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageViewScreen extends StatefulWidget {
  final int propertyId;
  ImageViewScreen(this.propertyId, {super.key});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  List<dynamic> list = [];
  int index = -1;

  Future<List<dynamic>> fetchImages(int propertyId) async {
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImages(widget.propertyId).then((data) {
      setState(() {
        list = data;
        index = data.isNotEmpty ? 0 : -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onHorizontalDragEnd: (details) {
                setState(() {
                  if (details.primaryVelocity! < 0 && index < list.length - 1) {
                    index++; // Swipe left → next image
                  } else if (details.primaryVelocity! > 0 && index > 0) {
                    index--; // Swipe right → previous image
                  }
                });
              },
              child: LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  child: index == -1 || list.isEmpty
                      ? CircularProgressIndicator()
                      : Image.network(list[index]['image_url']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
