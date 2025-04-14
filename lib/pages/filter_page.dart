import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/property_details.dart';
import 'package:real_estate_management_system/property_details_provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final minpriceController = TextEditingController();
  final maxpriceController = TextEditingController();
  final bedController = TextEditingController();
  final bathController = TextEditingController();
  final balconyController = TextEditingController();
  final parkingController = TextEditingController();
//     city = request.args.get('city')
//     state = request.args.get('state')
//     min_price = request.args.get('min_price', type=int)
//     max_price = request.args.get('max_price', type=int)
//     bedrooms = request.args.get('bedrooms', type=int)
//     area= request.args.get('area')
//     bathrooms= request.args.get('bathrooms', type=int)
//     parking= request.args.get('parking', type=int)
//     balcony= request.args.get('balcony', type=int)
  Future<List<Map<String, dynamic>>> getProperties() async {
    final queryParams = {
      'city': cityController.text.trim(),
      'area': areaController.text.trim(),
      'state': stateController.text.trim(),
      'min_price': minpriceController.text.trim(),
      'max_price': maxpriceController.text.trim(),
      'bedrooms': bedController.text.trim(),
      'bathrooms': bathController.text.trim(),
      'parking': parkingController.text.trim(),
      'balcony': balconyController.text.trim(),
    }..removeWhere((key, value) => value.isEmpty);

    final url = Uri.https('real-estate-flask-api.onrender.com',
        '/search_properties', queryParams);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      print('Error fetching properties');
      return [];
    }
  }

  Future<
      ({
        List<Map<String, dynamic>> properties,
        Map<int, List<String>> images
      })> fetchDatawithImages() async {
    Map<int, List<String>> images = {};
    List<Map<String, dynamic>> properties = await getProperties();

    // Fetch all images asynchronously
    await Future.wait(properties.map((property) async {
      String image = await fetchImage(property['property_id']);
      images[property['property_id']] = [image];
    }));

    if (!mounted) return (properties: properties, images: images);
    if (properties.length != 0) {
      Provider.of<PropertyDetailsProvider>(context, listen: false)
          .addPropertiesFromApi(properties);
      Provider.of<PropertyDetailsProvider>(context, listen: false)
          .addImagesFromApi(images);
    }

    return (properties: properties, images: images);
  }

  Future<String> fetchImage(int propertyId) async {
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var map in data) {
        if (map['is_primary'] == 'Yes') {
          return "https://real-estate-flask-api.onrender.com" +
              map['image_url'];
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraits) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FilterCards(
                    icon: Icons.place,
                    t: areaController,
                    string: 'Area',
                    numKey: false,
                  ),
                  FilterCards(
                    icon: Icons.location_city,
                    t: cityController,
                    string: 'City',
                    numKey: false,
                  ),
                  FilterCards(
                    icon: Icons.map,
                    t: stateController,
                    string: 'State',
                    numKey: false,
                  ),
                  FilterCards(
                    icon: Icons.currency_rupee,
                    t: minpriceController,
                    string: 'Minimum Price',
                    numKey: true,
                  ),
                  FilterCards(
                    icon: Icons.currency_rupee_outlined,
                    t: maxpriceController,
                    string: 'Maximum Price',
                    numKey: true,
                  ),
                  FilterCards(
                    icon: Icons.bed,
                    t: bedController,
                    string: 'Bedrooms',
                    numKey: true,
                  ),
                  FilterCards(
                    icon: Icons.bathroom,
                    t: bathController,
                    string: 'Bathrooms',
                    numKey: true,
                  ),
                  FilterCards(
                    icon: Icons.balcony,
                    t: balconyController,
                    string: 'Balcony',
                    numKey: true,
                  ),
                  FilterCards(
                    icon: Icons.local_parking,
                    t: parkingController,
                    string: 'Parking',
                    numKey: true,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var result = await fetchDatawithImages();
                      if (result.properties.isNotEmpty) {
                        if (mounted) Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No properties found')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.black),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterCards extends StatelessWidget {
  final IconData icon;
  final TextEditingController t;
  final String string;
  final bool numKey;
  const FilterCards({
    required this.numKey,
    required this.icon,
    required this.t,
    required this.string,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SizedBox(
          // height: constraits.maxHeight * .1,
          width: constraints.maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      keyboardType:
                          numKey ? TextInputType.number : TextInputType.text,
                      controller: t,
                      decoration: InputDecoration(
                          hintText: string,
                          // enabledBorder: OutlineInputBorder(),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2)),
                          prefixIcon: Icon(icon)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// i have these criterias through which we are searching for properties 
