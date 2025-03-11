import 'package:flutter/material.dart';

class PropertyFilterPage extends StatefulWidget {
  @override
  _PropertyFilterPageState createState() => _PropertyFilterPageState();
}

class _PropertyFilterPageState extends State<PropertyFilterPage> {
  // Filter state variables
  RangeValues _priceRange = RangeValues(100000, 1000000);
  List<String> _propertyTypes = [
    'House',
    'Apartment',
    'Condo',
    'Townhouse',
    'Land'
  ];
  List<String> _selectedPropertyTypes = ['House', 'Apartment'];
  RangeValues _areaRange = RangeValues(500, 5000);
  int _bedrooms = 2;
  int _bathrooms = 2;
  List<String> _amenities = [
    'Swimming Pool',
    'Garden',
    'Garage',
    'Balcony',
    'Gym',
    'Security',
    'Elevator',
    'Parking'
  ];
  List<String> _selectedAmenities = ['Parking', 'Balcony'];
  String _sortBy = 'Price (Low to High)';
  bool _onlyShowWithPhotos = true;
  bool _onlyShowVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Filters',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Reset all filters to default
              setState(() {
                _priceRange = RangeValues(100000, 1000000);
                _selectedPropertyTypes = ['House', 'Apartment'];
                _areaRange = RangeValues(500, 5000);
                _bedrooms = 2;
                _bathrooms = 2;
                _selectedAmenities = ['Parking', 'Balcony'];
                _sortBy = 'Price (Low to High)';
                _onlyShowWithPhotos = true;
                _onlyShowVerified = false;
              });
            },
            child: Text(
              'Reset',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRangeFilter(),
            _buildDivider(),
            _buildPropertyTypeFilter(),
            _buildDivider(),
            _buildAreaFilter(),
            _buildDivider(),
            _buildRoomsFilter(),
            _buildDivider(),
            _buildAmenitiesFilter(),
            _buildDivider(),
            _buildSortByFilter(),
            _buildDivider(),
            _buildAdditionalOptions(),
            SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Apply filters and return to search results
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey[200],
      height: 1,
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Price Range'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${_priceRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 2000000,
          divisions: 20,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[300],
          labels: RangeLabels(
            '\$${_priceRange.start.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            '\$${_priceRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPropertyTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Property Type'),
        Container(
          height: 50,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: _propertyTypes.map((type) {
              final isSelected = _selectedPropertyTypes.contains(type);
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedPropertyTypes.add(type);
                      } else {
                        _selectedPropertyTypes.remove(type);
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: Colors.blue[100],
                  checkmarkColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue[800] : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAreaFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Square Footage'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_areaRange.start.toInt()} sq ft',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_areaRange.end.toInt()} sq ft',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        RangeSlider(
          values: _areaRange,
          min: 0,
          max: 10000,
          divisions: 20,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[300],
          labels: RangeLabels(
            '${_areaRange.start.toInt()} sq ft',
            '${_areaRange.end.toInt()} sq ft',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _areaRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRoomsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Rooms'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Bedrooms Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bedrooms',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildNumberButton(
                      1,
                      _bedrooms == 1,
                      () => setState(() => _bedrooms = 1),
                    ),
                    _buildNumberButton(
                      2,
                      _bedrooms == 2,
                      () => setState(() => _bedrooms = 2),
                    ),
                    _buildNumberButton(
                      3,
                      _bedrooms == 3,
                      () => setState(() => _bedrooms = 3),
                    ),
                    _buildNumberButton(
                      4,
                      _bedrooms == 4,
                      () => setState(() => _bedrooms = 4),
                    ),
                    _buildNumberButton(
                      '5+',
                      _bedrooms >= 5,
                      () => setState(() => _bedrooms = 5),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Bathrooms Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bathrooms',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildNumberButton(
                      1,
                      _bathrooms == 1,
                      () => setState(() => _bathrooms = 1),
                    ),
                    _buildNumberButton(
                      2,
                      _bathrooms == 2,
                      () => setState(() => _bathrooms = 2),
                    ),
                    _buildNumberButton(
                      3,
                      _bathrooms == 3,
                      () => setState(() => _bathrooms = 3),
                    ),
                    _buildNumberButton(
                      4,
                      _bathrooms == 4,
                      () => setState(() => _bathrooms = 4),
                    ),
                    _buildNumberButton(
                      '5+',
                      _bathrooms >= 5,
                      () => setState(() => _bathrooms = 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberButton(
      dynamic number, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
            ),
          ),
          child: Text(
            number.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmenitiesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Amenities'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _amenities.map((amenity) {
              final isSelected = _selectedAmenities.contains(amenity);
              return FilterChip(
                label: Text(amenity),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedAmenities.add(amenity);
                    } else {
                      _selectedAmenities.remove(amenity);
                    }
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue[800] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSortByFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sort By'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<String>(
            value: _sortBy,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _sortBy = newValue;
                });
              }
            },
            items: [
              'Price (Low to High)',
              'Price (High to Low)',
              'Newest First',
              'Oldest First',
              'Most Popular',
              'Most Relevant',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Additional Options'),
        SwitchListTile(
          title: Text(
            'Only show properties with photos',
            style: TextStyle(fontSize: 16),
          ),
          value: _onlyShowWithPhotos,
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          onChanged: (bool value) {
            setState(() {
              _onlyShowWithPhotos = value;
            });
          },
        ),
        SwitchListTile(
          title: Text(
            'Only show verified properties',
            style: TextStyle(fontSize: 16),
          ),
          value: _onlyShowVerified,
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          onChanged: (bool value) {
            setState(() {
              _onlyShowVerified = value;
            });
          },
        ),
      ],
    );
  }
}
