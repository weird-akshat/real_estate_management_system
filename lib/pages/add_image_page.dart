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
  bool isClikced = false;
  void _updateState() {
    setState(() {}); // This will refresh the page when images are added/removed
  }

  List<File> list = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    print(Provider.of<PropertyidProvider>(context).propertyId);
    return isClikced
        ? CircularProgressIndicator()
        : Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add Images',
                    style: TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: list.length + 1,
                    itemBuilder: (context, index) {
                      return index < list.length
                          ? BuildImageButton(
                              list,
                              _updateState,
                              index, // Always using the current index from the builder
                            )
                          : GestureDetector(
                              onTap: () async {
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    list.add(File(pickedFile.path));
                                  });
                                }
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.add,
                                    size: 40, color: Colors.grey),
                              ),
                            );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isClikced = true;
                    });
                    try {
                      for (int i = 0; i < list.length; i++) {
                        await uploadImage(list[i], i == 0);
                      }

                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } finally {
                      isClikced = false;
                      setState(() {});
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black)),
                  child: Text('Submit'),
                )
              ],
            ),
          );
  }

  Future<void> uploadImage(File i, bool primary) async {
    if (list.isEmpty) {
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
    request.fields['is_primary'] = primary ? 'Yes' : 'No';

    var imageFile = await http.MultipartFile.fromPath('image', i.path);
    request.files.add(imageFile);

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Success: $responseBody");
    } else {
      debugPrint("Error: ${response.statusCode} - $responseBody");
    }
  }
}


// before i was just removing the whole fucking thing before 