import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_management_system/pages/filter_page.dart';

import 'package:real_estate_management_system/pages/property_details.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_management_system/property_details_provider.dart';

late Widget chip1, chip2, chip3, chip4;

class PropertyListingPage extends StatefulWidget {
  const PropertyListingPage({super.key});

  @override
  State<PropertyListingPage> createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  bool initialLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider
    final propertyProvider = Provider.of<PropertyDetailsProvider>(context);

    // If it's the initial load or there are no properties in the provider, fetch them
    if (initialLoad || propertyProvider.list.isEmpty) {
      return FutureBuilder(
        future: fetchDatawithImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var data = snapshot.data!;

            // Only update if we're doing initial load
            if (initialLoad) {
              Provider.of<PropertyDetailsProvider>(context, listen: false)
                  .addPropertiesFromApi(data.properties);
              Provider.of<PropertyDetailsProvider>(context, listen: false)
                  .addImagesFromApi(data.images);
              initialLoad = false;
            }

            return BodyPropertyList(propertyProvider.list);
          }
        },
      );
    } else {
      // If we already have data in the provider, just use that
      return BodyPropertyList(propertyProvider.list);
    }
  }
}

class SidebarButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icondata;
  final String text;
  final Widget widget;

  const SidebarButton(
    this.icondata,
    this.text,
    this.widget, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        style: ButtonStyle(
          iconSize: WidgetStatePropertyAll(5),
        ),
        child: Row(
          children: [
            Icon(
              icondata,
              size: 40,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class BodyPropertyList extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  const BodyPropertyList(
    this.list, {
    super.key,
  });

  @override
  State<BodyPropertyList> createState() => _BodyPropertyListState();
}

class _BodyPropertyListState extends State<BodyPropertyList> {
  String searchQuery = '';
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list that excludes user's own properties
    updateFilteredList();
  }

  @override
  void didUpdateWidget(BodyPropertyList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.list != oldWidget.list) {
      // If the list changes, update the filter
      updateFilteredList();
    }
  }

  void refreshPage() {
    setState(() {});
  }

  // Method to filter properties based on search query
  void filterProperties(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      updateFilteredList();
    });
  }

  // Helper method to update filtered list
  void updateFilteredList() {
    // First exclude user's own properties
    var nonUserProperties = widget.list.where((property) {
      return property['owner_id'] != FirebaseAuth.instance.currentUser!.uid;
    }).toList();

    // Then apply search query if it exists
    if (searchQuery.isEmpty) {
      filteredList = nonUserProperties;
    } else {
      filteredList = nonUserProperties.where((property) {
        // Check if any field in the property matches the search query
        return property.entries.any((entry) {
          if (entry.value == null) return false;
          return entry.value.toString().toLowerCase().contains(searchQuery);
        });
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                onChanged: filterProperties,
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusColor: Colors.black,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search anything',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(58, 58)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                    backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(218, 12, 12, 12)),
                  ),
                  onPressed: () async {
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FilterPage();
                    }));

                    // After returning from filter page, update our local filtered list
                    setState(() {
                      updateFilteredList();
                    });
                  },
                  child: Icon(
                    Icons.tune,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        Expanded(
          child: filteredList.isEmpty
              ? Center(child: Text('No properties match your search'))
              : ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    // Find the original index in the widget.list for provider lookup
                    final propertyId = filteredList[index]['property_id'];
                    final originalIndex = widget.list.indexWhere(
                        (property) => property['property_id'] == propertyId);

                    return PropertyCard(
                      index: originalIndex,
                      propertyId: filteredList[index]['property_id'],
                      price: filteredList[index]['price'].toString(),
                      area: filteredList[index]['area'],
                      numBed: filteredList[index]['bedrooms'] + " BHK",
                      propertyName: filteredList[index]['name'],
                      onRefresh: refreshPage,
                    );
                  }),
        )
      ],
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          chip1,
          SizedBox(
            width: 15,
          ),
          chip2,
          SizedBox(
            width: 15,
          ),
          chip3,
          SizedBox(
            width: 15,
          ),
          chip4
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final int index;
  final int propertyId;
  final String propertyName;
  final String numBed;
  final String area;
  final String price;
  final VoidCallback onRefresh;
  const PropertyCard(
      {super.key,
      required this.index,
      required this.propertyId,
      required this.price,
      required this.area,
      required this.numBed,
      required this.propertyName,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PropertyDetailsPage(index);
        }));
        onRefresh();
      },
      child: Container(
        decoration: BoxDecoration(),
        // color: Colors.black87,
        // borderRadius: BorderRadius.circular(20),
        child: Card(
          color: Color(0xffd8e2dc),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black, width: 0)),
          surfaceTintColor: Colors.white70,

          margin: EdgeInsets.all(10),
          elevation: 15,
          // decoration: BoxDecoration(
          // border: Border.all(),
          // borderRadius: BorderRadius.circular(20),
          // ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          Provider.of<PropertyDetailsProvider>(context,
                                      listen: false)
                                  .images[Provider.of<PropertyDetailsProvider>(
                                      context,
                                      listen: false)
                                  .list[index]['property_id']]?[0] ??
                              '',
                          fit: BoxFit.cover,
                        ),
                      )

                      // child: Image.network(image)
                      )),
              Text(
                propertyName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bed),
                        Text(numBed),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop),
                        Text(area),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.currency_rupee),
                        Text(price),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<({List<Map<String, dynamic>> properties, Map<int, List<String>> images})>
    fetchDatawithImages() async {
  Map<int, List<String>> images = {};
  List<Map<String, dynamic>> properties = await fetchData();
  // print(properties);
  for (Map<String, dynamic> map in properties) {
    if (images[map['property_id']] == null) {
      images[map['property_id']] = [];
    }

    // print(images);
    String image = await fetchImage(map['property_id']);
    images[map['property_id']]!.add(image);
  }

  return (properties: properties, images: images);
}

Future<List<Map<String, dynamic>>> fetchData() async {
  final url =
      Uri.parse('https://real-estate-flask-api.onrender.com/search_properties');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Expected a list but got something else');
    }
  } else {
    throw Exception('Error: ${response.statusCode}');
  }
}

Future<String> fetchImage(int propertyId) async {
  final url = Uri.parse(
    'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    for (Map<String, dynamic> map in data) {
      if (map['is_primary'] == 'Yes') {
        // Make full URL from relative path
        final imageUrl = map['image_url'];
        return 'https://real-estate-flask-api.onrender.com$imageUrl';
      }
    }
  }
  return '';
}
