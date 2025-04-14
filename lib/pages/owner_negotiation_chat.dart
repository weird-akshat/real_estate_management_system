import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_management_system/pages/make_offer.dart';

class OwnerNegotiationChat extends StatefulWidget {
  final String buyerId;
  final int propertyId;

  const OwnerNegotiationChat(
      {super.key, required this.buyerId, required this.propertyId});

  @override
  State<OwnerNegotiationChat> createState() => _NegotiationChatState();
}

class _NegotiationChatState extends State<OwnerNegotiationChat> {
  List<Map<String, dynamic>> list = [];
  bool isSold = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      List<Map<String, dynamic>> fetchedList = await fetchOffers();
      isSold = await checkSold();
      setState(() {
        list = fetchedList;
      });
    });
  }

  Future markPropoertySold() async {
    int propertyId = widget.propertyId;

    final url = Uri.parse(
        "https://real-estate-flask-api.onrender.com/mark_property_sold/$propertyId");

    final response = await http.put(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('success');
    } else {
      print("error");
    }
  }

  Future checkSold() async {
    int propertyId = widget.propertyId;
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/is_property_sold/$propertyId');

    final response = await http.get(url);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body)['sold'];
      print(data);
      return data;
    } else {
      print("error");
      return false;
    }
  }

  Future updateOffer(int offerId) async {
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/accept_offer/$offerId');

    final response = await http.put(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("success update Offer");
    } else {
      print("error update Offer");
    }
  }

  void refresh() {
    setState(() {});
  }

  // Function to show the Make Offer Dialog
  void _showMakeOfferDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MakeOfferDialog(
          propertyId: widget.propertyId,
          buyerId: widget.buyerId,
          list: list,
          refresh: refresh,
          onOfferSubmitted: (double amount) {
            // Create a new offer
            final newOffer = {
              "property_id": widget.propertyId,
              "buyer_id": widget.buyerId,
              "amount": amount,
              "offer_status": "pending",
              "offer_date": DateTime.now().toIso8601String(),
              "made_by": "owner",
            };
            makeOffer(newOffer);
            // Add the new offer to the list
            setState(() {
              list.add(newOffer);
            });

            // Close the dialog
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> makeOffer(Map<String, dynamic> offer) async {
    final url =
        Uri.parse('https://real-estate-flask-api.onrender.com/make_offer');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(offer),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Offer successfully made");
      } else {
        print("Error making offer: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception making offer: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchOffers() async {
    String userId = widget.buyerId;
    int propId = widget.propertyId;
    final url = Uri.parse(
        'https://real-estate-flask-api.onrender.com/offers/$userId/$propId');

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

  void _showAcceptDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Accept Offer"),
          content: Text("Do you want to accept this offer?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool sold = await checkSold();
                if (!sold) {
                  //here we have to update the property as sold, and also update the offer

                  //first check if the property is already sold or not
                  //if yes then you can't accept the offer

                  //now just update the api and also just update the status of the offer
                  await markPropoertySold();

                  int offerId = list[index]['offer_id'];

                  await updateOffer(offerId);
                  print("Offer Accepted! ✅");

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Property Already sold"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                // Perform any update logic here
                Navigator.of(context).pop();
              },
              child: Text("Accept"),
            ),
          ],
        );
      },
    );
  }

  // Helper method to parse dates safely
  DateTime parseDate(String dateStr) {
    try {
      // Try parsing ISO format
      return DateTime.parse(dateStr);
    } catch (e) {
      try {
        // Try alternative format
        var format = DateFormat("yyyy-MM-dd HH:mm:ss");
        return format.parse(dateStr);
      } catch (e) {
        print("Error parsing date: $dateStr");
        // Return current date as fallback
        return DateTime.now();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            'assets/images/loginbackground.jpg',
            fit: BoxFit.cover,
          )),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    //you know what, i think i should check whether the property is already sold here only, if not then only gesture detector
                    if (list[index]['made_by'] == 'buyer' && isSold == false) {
                      return GestureDetector(
                        onTap: () {
                          _showAcceptDialog(context, index);
                        },
                        child: PaymentChatTile(
                          price: double.parse(list[index]['amount'].toString()),
                          date: parseDate(list[index]['offer_date']),
                          status: list[index]['offer_status'],
                          isBuyer: list[index]['made_by'] != 'buyer',
                        ),
                      );
                    }
                    return PaymentChatTile(
                      price: double.parse(list[index]['amount'].toString()),
                      date: parseDate(list[index]['offer_date']),
                      status: list[index]['offer_status'],
                      isBuyer: list[index]['made_by'] != 'buyer',
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (!isSold)
                      ElevatedButton(
                        onPressed: _showMakeOfferDialog,
                        child: Text(
                          'Make Offer',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Property Already Sold',
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// New Dialog Widget for Making an Offer
class MakeOfferDialog extends StatefulWidget {
  List list;
  final int propertyId;
  final String buyerId;
  final VoidCallback refresh;

  final Function(double amount) onOfferSubmitted;

  MakeOfferDialog(
      {Key? key,
      required this.onOfferSubmitted,
      required this.propertyId,
      required this.buyerId,
      required this.list,
      required this.refresh})
      : super(key: key);

  @override
  _MakeOfferDialogState createState() => _MakeOfferDialogState();
}

class _MakeOfferDialogState extends State<MakeOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Make an Offer'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Offer Amount',
            border: OutlineInputBorder(),
            prefixText: '₹ ',
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an offer amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Parse the value
              final amount = double.parse(_amountController.text);
              // Call the submitted callback
              widget.onOfferSubmitted(amount);
              widget.refresh();
            }
          },
          child: Text('Submit Offer'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up controller
    _amountController.dispose();
    super.dispose();
  }
}

// PaymentChatTile with improved styling
class PaymentChatTile extends StatelessWidget {
  final double price;
  final DateTime date;
  final String status;
  final bool isBuyer;

  const PaymentChatTile({
    Key? key,
    required this.price,
    required this.date,
    required this.status,
    required this.isBuyer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: isBuyer ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: status.toLowerCase() == 'accepted'
                  ? Colors.lightGreenAccent
                  : (isBuyer
                      ? const Color(0xFFE6F2FF) // Light Blue
                      : const Color(0xFFF0E6FF)), // Light Purple
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isBuyer ? const Radius.circular(16) : Radius.zero,
                bottomRight: isBuyer ? Radius.zero : const Radius.circular(16),
              ),
              border: Border.all(
                color: isBuyer
                    ? const Color(0xFFB3D9FF) // Soft Blue Border
                    : const Color(0xFFD1B3FF), // Soft Purple Border
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price
                Text(
                  '₹ ${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isBuyer
                        ? const Color(0xFF0066CC) // Deep Blue
                        : const Color(0xFF6600CC), // Deep Purple
                  ),
                ),
                const SizedBox(height: 8),

                // Status
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: status.toLowerCase() == 'accepted'
                        ? Colors.green.shade800
                        : (status.toLowerCase() == 'pending'
                            ? Colors.orange.shade800
                            : Colors.red.shade800),
                  ),
                ),

                const SizedBox(height: 4),

                // Date
                Text(
                  '• ${DateFormat('MMM dd, hh:mm a').format(date)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isBuyer
                        ? const Color(0xFF3399FF) // Bright Blue
                        : const Color(0xFF9933FF), // Bright Purple
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
