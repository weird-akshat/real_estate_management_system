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
      'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final baseUrl = 'https://real-estate-flask-api.onrender.com';
      for (var item in data) {
        if (item['image_url'] != null &&
            item['image_url'].toString().startsWith('/')) {
          item['image_url'] = '$baseUrl${item['image_url']}';
        }
      }

      return data;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  width: screenWidth * 0.8, // 80% of screen width
                  height: screenHeight * 0.6, // 60% of screen height
                  child: index == -1 || list.isEmpty
                      ? CircularProgressIndicator()
                      : Image.network(
                          list[index]['image_url'],
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
