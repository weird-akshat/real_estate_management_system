import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_management_system/pages/negotiation_chat.dart';

import 'package:http/http.dart' as http;
import 'package:real_estate_management_system/pages/visit_chat.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<VisitPage> createState() => _NegotiationPageState();
}

class _NegotiationPageState extends State<VisitPage> {
  void onRefresh() {
    setState(() {});
  }

  List<Map<String, dynamic>> list = [];
  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      List<Map<String, dynamic>> fetchedList = await fetchProperties();
      setState(() {
        list = fetchedList;
        print(list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => NegotiationBodyPropertyCard(
            image:
                'https://real-estate-flask-api.onrender.com/${list[index]['image_url']}',
            index: index,
            propertyId: int.parse(list[index]['property_id'].toString()),
            price: list[index]['price'].toString(),
            area: list[index]['area'].toString(),
            numBed: list[index]['bedrooms'].toString(),
            propertyName: list[index]['name'].toString(),
            onRefresh: onRefresh));

    //so from the api we only need image_url, property_id, price, area bedrooms, property_name but ehh we'll get everything
  }
}

Future<List<Map<String, dynamic>>> fetchProperties() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final url = Uri.parse(
      'https://real-estate-flask-api.onrender.com/user/$userId/visited-properties');

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

class NegotiationBodyPropertyCard extends StatelessWidget {
  final int index;
  final int propertyId;
  final String propertyName;
  final String numBed;
  final String area;
  final String price;
  final String image;
  final VoidCallback onRefresh;
  const NegotiationBodyPropertyCard(
      {super.key,
      required this.image,
      required this.index,
      required this.propertyId,
      required this.price,
      required this.area,
      required this.numBed,
      required this.propertyName,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    // print('hey');
    // print(Provider.of<FavoriteProvider>(context, listen: false)
    //     .images[propertyId]);
    // print('hey2');
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return VisitChat(
            buyerId: FirebaseAuth.instance.currentUser!.uid,
            propertyId: propertyId,
          );
        }));
        // onRefresh();
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
                      child: Image.network(image)

                      // // child: Image.network(image)
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
