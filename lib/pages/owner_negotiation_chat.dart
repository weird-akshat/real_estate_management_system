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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      List<Map<String, dynamic>> fetchedList = await fetchOffers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => PaymentChatTile(
                price: list[index]['amount'],
                date: DateTime.parse(list[index]['offer_date']),
                // status: list[index]['offer_status'],
                isBuyer: list[index]['made_by'] != 'buyer',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Accept Offer')),
              ElevatedButton(
                  onPressed: _showMakeOfferDialog, child: Text('Make Offer')),
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
            prefixText: '\$',
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
  // final String status;
  final bool isBuyer;

  const PaymentChatTile({
    Key? key,
    required this.price,
    required this.date,
    // required this.status,
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
              color: isBuyer
                  ? const Color(0xFFE6F2FF) // Light Blue
                  : const Color(0xFFF0E6FF), // Light Purple
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
                  '${DateFormat('MMM dd, hh:mm a').format(date)}',
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
