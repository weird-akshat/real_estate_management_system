import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_management_system/pages/make_offer.dart';

class NegotiationChat extends StatefulWidget {
  final String buyerId;
  final int propertyId;
  const NegotiationChat(
      {super.key, required this.buyerId, required this.propertyId});

  @override
  State<NegotiationChat> createState() => _NegotiationChatState();
}

class _NegotiationChatState extends State<NegotiationChat> {
  List<Map<String, dynamic>> list = [];
  bool isSold = false;

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
              "offer_date": DateTime.now().toString(),
              "made_by": "buyer",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                if (list[index]['made_by'] == 'owner' && isSold == false) {
                  return GestureDetector(
                    onTap: () {
                      _showAcceptDialog(context, index);
                    },
                    child: PaymentChatTile(
                      price: list[index]['amount'],
                      // status: list[index]['status'],
                      date: DateTime.parse(list[index]['offer_date']),
                      status: list[index]['offer_status'],
                      isBuyer: list[index]['made_by'] == 'buyer',
                    ),
                  );
                }

                return PaymentChatTile(
                  price: list[index]['amount'],
                  date: DateTime.parse(list[index]['offer_date']),
                  status: list[index]['offer_status'],
                  isBuyer: list[index]['made_by'] == 'buyer',
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ElevatedButton(onPressed: () {}, child: Text('Accept Offer')),
              if (!isSold)
                ElevatedButton(
                    onPressed: _showMakeOfferDialog, child: Text('Make Offer'))
              else
                Text('Property Already Sold'),
            ],
          )
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
              Map<String, dynamic> map = {
                //get the offer_id from the api at the end
              };

              // Call the submitted callback
              widget.onOfferSubmitted(amount);
              // widget.list.add(map);
              // print(widget.list);
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

// Existing PaymentChatTile remains the same as in the previous code
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
              color: status == 'Accepted'
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
                  '${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isBuyer
                        ? const Color(0xFF0066CC) // Deep Blue
                        : const Color(0xFF6600CC), // Deep Purple
                  ),
                ),
                const SizedBox(height: 8),

                // Status and Date
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
