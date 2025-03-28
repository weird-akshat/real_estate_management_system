import 'dart:convert';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchDatawithImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // print(snapshot.data.body);
            var data = snapshot.data!;
            Provider.of<PropertyDetailsProvider>(context, listen: false)
                .addPropertiesFromApi(data.properties);
            Provider.of<PropertyDetailsProvider>(context, listen: false)
                .addImagesFromApi(data.images);

            // print(Provider.of<PropertyDetailsProvider>(context).images);

            return BodyPropertyList(data.properties);
          }
        },
      ),
    );
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
  void refreshPage() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    chip1 = CategoryChip(
      label: 'Houses',
      color: Colors.black,
    );
    // chip1.color = Colors.black;
    chip2 = CategoryChip(
      label: 'Offices',
      color: Colors.white,
    );
    chip3 = CategoryChip(label: 'Appartments', color: Colors.white);
    chip4 = CategoryChip(
      label: 'Bunglows',
      color: Colors.white,
    );
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
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusColor: Colors.black,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Location',
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PropertyFilterPage();
                    }));
                  },
                  child: Icon(
                    Icons.tune,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Categories(),
        Expanded(
          child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return PropertyCard(
                  index: index,
                  propertyId: widget.list[index]['property_id'],
                  price: widget.list[index]['price'],
                  area: widget.list[index]['area'],
                  numBed: widget.list[index]['bedrooms'],
                  propertyName: widget.list[index]['name'],
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.black, width: 01)),
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
                      child: Image.network(Provider.of<PropertyDetailsProvider>(
                                  context,
                                  listen: false)
                              .images[Provider.of<PropertyDetailsProvider>(
                                  context,
                                  listen: false)
                              .list[index]['property_id']]?[0] ??
                          '')

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

Future fetchImage(int propertyId) async {
  final url = Uri.parse(
      'https://real-estate-flask-api.onrender.com/get_property_images?property_id=$propertyId');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    // print('Response Data: $data');

    for (Map<String, dynamic> map in data) {
      if (map['is_primary'] == 'Yes') {
        // print(map);
        return map['image_url'];
      }
    }
  } else {
    // print('Error: ${response.statusCode}');
  }
  return response;
}

class CategoryChip extends StatefulWidget {
  final Color color;
  final String label;
  const CategoryChip({super.key, required this.label, required this.color});

  @override
  State<CategoryChip> createState() => _CategoryChipState(color);
}

class _CategoryChipState extends State<CategoryChip> {
  _CategoryChipState(this.color);
  late Color color;
  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        color = color == Colors.white ? Colors.black : Colors.white;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Chip(
          backgroundColor: color,
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all((Radius.circular(5)))),
          label: Text(
            widget.label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color == Colors.white ? Colors.black : Colors.white),
          ),
          padding: EdgeInsets.all(15),
        ),
      ),
    );
  }
}
