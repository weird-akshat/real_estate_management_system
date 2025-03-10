import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:real_estate_management_system/pages/property_editing_page..dart';

class OwnedPropertyDetailsPage extends StatelessWidget {
  const OwnedPropertyDetailsPage({super.key});
  final double textSize = 17.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.black, items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueGrey,
            ),
            label: ""),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          label: "",
        )
      ]),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/loginbackground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/housepic3.jpeg',
                        fit: BoxFit.cover,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 30, 0, 0),
                          child: Icon(Icons.arrow_back),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Building Name',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    //property type
                    //price
                    //location
                    //area
                    //number of bedrooms and bathrooms
                    //balcony and terrace availablity
                    //parking availability
                    //contact number and email
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Price- 46,00,000',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Description',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                Card(
                  elevation: 5,
                  color: Color.fromARGB(176, 247, 245, 159),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Lmao this is supposed to be the property description. You write whatever the fuck you want to write about the fucking property so that people can read i guess. I hope you fucking know what a description is',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('OverView',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                Card(
                    color: Color.fromRGBO(187, 208, 255, 1),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Property Type',
                                  style: TextStyle(fontSize: textSize)),
                              Text('Price',
                                  style: TextStyle(fontSize: textSize)),
                              Text('Location',
                                  style: TextStyle(fontSize: textSize)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Area',
                                  style: TextStyle(fontSize: textSize)),
                              Text('B and B',
                                  style: TextStyle(fontSize: textSize)),
                              Text('Balcony',
                                  style: TextStyle(fontSize: textSize)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Parking',
                                  style: TextStyle(fontSize: textSize)),
                              Text('Contact Number',
                                  style: TextStyle(fontSize: textSize)),
                              Text('Email',
                                  style: TextStyle(fontSize: textSize)),
                            ],
                          ),
                        ],
                      ),
                    )
                    // child: GridView(
                    // gridDelegate:
                    // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    // ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prospective Buyers',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      // Text('Phone Number  Email ID'),
                      BuyerProfileCard(
                          name: 'name', phone: 'phone', email: 'email'),
                      BuyerProfileCard(
                          name: 'name', phone: 'phone', email: 'email'),
                      BuyerProfileCard(
                          name: 'name', phone: 'phone', email: 'email'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xffff8fa3)),
                      ),
                      child: Text(
                        'Declare Sold',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return EditPage();
                          }));
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuyerProfileCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;

  const BuyerProfileCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.lightBlue.shade100,
              child: Icon(LucideIcons.user, size: 30, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(LucideIcons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(phone, style: TextStyle(color: Colors.grey[700])),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(LucideIcons.mail, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(email, style: TextStyle(color: Colors.grey[700])),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
