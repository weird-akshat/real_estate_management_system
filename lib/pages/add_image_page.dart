import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/add_property_page.dart';
import 'package:real_estate_management_system/pages/build_image_button.dart';
import 'package:real_estate_management_system/pages/home_page.dart';
import 'package:real_estate_management_system/pages/propertyid_provider.dart';
import 'package:http/http.dart' as http;

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key});

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  bool isLoading = false;
  List<File> imagesList = [];
  final picker = ImagePicker();

  void _updateState() {
    setState(() {}); // Refresh the page when images are added/removed
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Optimize image quality
    );

    if (pickedFile != null) {
      setState(() {
        imagesList.add(File(pickedFile.path));
      });
    }
  }

  Future<void> uploadImage(File imageFile, bool isPrimary) async {
    if (imagesList.isEmpty) {
      debugPrint("Error: No images selected.");
      return;
    }

    final url =
        Uri.parse('https://real-estate-flask-api.onrender.com/upload_image');

    var request = http.MultipartRequest("POST", url);
    request.fields['property_id'] =
        Provider.of<PropertyidProvider>(context, listen: false)
            .propertyId
            .toString();
    request.fields['is_primary'] = isPrimary ? 'Yes' : 'No';

    var multipartFile =
        await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(multipartFile);

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Success: $responseBody");
    } else {
      debugPrint("Error: ${response.statusCode} - $responseBody");
    }
  }

  Future<void> _submitImages() async {
    if (imagesList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      for (int i = 0; i < imagesList.length; i++) {
        await uploadImage(imagesList[i], i == 0);
      }

      // Show success message before navigating
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Images uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyId = Provider.of<PropertyidProvider>(context).propertyId;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive grid count based on screen width
    int crossAxisCount = 3;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth >= 1200) {
      crossAxisCount = 4;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Images',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Uploading ${imagesList.length} images...',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header and description
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Property Gallery',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Add images for property #$propertyId. The first image will be used as the primary image.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Counter for images
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${imagesList.length} images selected',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (imagesList.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  imagesList.clear();
                                });
                              },
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              label: const Text('Clear all',
                                  style: TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),
                    ),

                    // Grid of images
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: imagesList.length + 1,
                        itemBuilder: (context, index) {
                          return index < imagesList.length
                              ? _buildImageTile(index)
                              : _buildAddImageTile();
                        },
                      ),
                    ),

                    // Submit button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitImages,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Submit Images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImageTile(int index) {
    bool isPrimary = index == 0;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary ? Colors.blue : Colors.grey.shade300,
              width: isPrimary ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              imagesList[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),

        // Primary badge
        if (isPrimary)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Delete button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                imagesList.removeAt(index);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.close, size: 18, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 40, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              'Add Image',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
