import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Accomodations extends StatefulWidget {
  const Accomodations({super.key});

  @override
  State<Accomodations> createState() => _AccomodationsState();
}

class _AccomodationsState extends State<Accomodations> {
  final TextEditingController _locationController = TextEditingController();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (_checkInDate ?? initialDate)
          : (_checkOutDate ?? initialDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          // Ensure check-out is after check-in
          if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
            _checkOutDate = _checkInDate;
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _searchAccommodations() {
    String location = _locationController.text;
    String checkIn = _checkInDate != null
        ? DateFormat('yyyy-MM-dd').format(_checkInDate!)
        : 'Not selected';
    String checkOut = _checkOutDate != null
        ? DateFormat('yyyy-MM-dd').format(_checkOutDate!)
        : 'Not selected';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Searching hotels in $location from $checkIn to $checkOut'),
      ),
    );
    // TODO: Replace with actual search logic or API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Accommodations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find the best hotel deals across different platforms.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Check-in',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _checkInDate != null
                            ? DateFormat('yyyy-MM-dd').format(_checkInDate!)
                            : 'Select date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Check-out',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _checkOutDate != null
                            ? DateFormat('yyyy-MM-dd').format(_checkOutDate!)
                            : 'Select date',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _searchAccommodations,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
