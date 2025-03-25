import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/add_image_page.dart';
import 'package:real_estate_management_system/pages/propertyid_provider.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final priceController = TextEditingController();
  final ownershipController = TextEditingController();
  final areaController = TextEditingController();
  final configurationController = TextEditingController();
  final bedroomController = TextEditingController();
  final bathroomController = TextEditingController();
  final ownerController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final balconyController = TextEditingController();
  final parkingController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 20),
                        InfoField(
                            text: 'Property Name',
                            iconData: Icons.home,
                            t: nameController),
                        InfoField(
                          text: 'City',
                          iconData: Icons.location_on,
                          t: cityController,
                        ),
                        InfoField(
                          text: 'State',
                          iconData: Icons.map,
                          t: stateController,
                        ),
                        InfoField(
                          text: 'Country',
                          iconData: Icons.public,
                          t: countryController,
                        ),
                        InfoField(
                          text: 'Price',
                          iconData: Icons.currency_rupee,
                          t: priceController,
                        ),
                        InfoField(
                            text: 'Balcony',
                            iconData: Icons.balcony,
                            t: balconyController),
                        InfoField(
                            text: 'Ownership Type',
                            iconData: Icons.business,
                            t: ownershipController),
                        InfoField(
                            text: 'Area',
                            iconData: Icons.square_foot,
                            t: areaController),
                        InfoField(
                            text: 'Configuration',
                            iconData: Icons.weekend,
                            t: configurationController),
                        InfoField(
                            text: 'Parking',
                            iconData: Icons.local_parking,
                            t: parkingController),
                        InfoField(
                            text: 'Number of Bedrooms',
                            iconData: Icons.bed,
                            t: bedroomController),
                        InfoField(
                            text: 'Number of Bathrooms',
                            iconData: Icons.bathroom,
                            t: bathroomController),
                        InfoField(
                            text: 'Owner Name',
                            iconData: Icons.person,
                            t: ownerController),
                        InfoField(
                            text: 'Owner\'s email',
                            iconData: Icons.mail,
                            t: emailController),
                        InfoField(
                            text: 'Owner\'s Phone Number',
                            iconData: Icons.phone,
                            t: numberController),
                        InfoField(
                            text: 'Description',
                            iconData: Icons.description,
                            t: descriptionController),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: TextButton(
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                                backgroundColor:
                                    const WidgetStatePropertyAll(Colors.black),
                                fixedSize:
                                    const WidgetStatePropertyAll(Size(300, 50)),
                              ),
                              onPressed: () async {
                                print("hey");
                                await addProperty();
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<void> addProperty() async {
    setState(() {
      isLoading = true;
    });
    print('lmao');
    final url =
        Uri.parse('https://real-estate-flask-api.onrender.com/add_property');

    Map<String, dynamic> data = {
      "name": nameController.text.trim(),
      "owner_id": FirebaseAuth.instance.currentUser?.uid,
      "property_type": ownershipController.text.trim(),
      "area": areaController.text.trim(),
      "parking": parkingController.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "country": countryController.text.trim(),
      "price": priceController.text.trim(),
      "balcony": balconyController.text.trim(),
      "bedrooms": bedroomController.text.trim(),
      "contact_number": numberController.text.trim(),
      "email": emailController.text.trim(),
      "description": descriptionController.text.trim(),
      "status": "Available"
    };
    print('lmaoo');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );
    print('response');
    if (response.statusCode == 200 || response.statusCode == 201) {
      isLoading = false;
      final responseData = jsonDecode(response.body);
      Provider.of<PropertyidProvider>(context, listen: false)
          .setPropertyId(responseData['property_id']);
      debugPrint("Success: ${response.body}");

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AddImagePage();
          },
        ),
      );
    } else {
      isLoading = false;
      debugPrint("Error: ${response.statusCode} - ${response.body}");
    }
  }
}

class InfoField extends StatelessWidget {
  final String text;
  final IconData iconData;
  final TextEditingController t;
  const InfoField(
      {super.key, required this.text, required this.iconData, required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextField(
        controller: t,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          hintText: text,
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
