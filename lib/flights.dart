import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Flights extends StatefulWidget {
  const Flights({super.key});

  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _departureDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate ?? initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _departureDate = picked;
      });
    }
  }

  void _searchFlights() {
    String origin = _originController.text;
    String destination = _destinationController.text;
    String departure = _departureDate != null
        ? DateFormat('yyyy-MM-dd').format(_departureDate!)
        : 'Not selected';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Searching flights from $origin to $destination on $departure'),
      ),
    );
    // TODO: Replace with actual search logic or API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Flights')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find the cheapest flight tickets across different websites.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _originController,
              decoration: const InputDecoration(
                labelText: 'Origin',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flight_takeoff),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flight_land),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Departure',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _departureDate != null
                      ? DateFormat('yyyy-MM-dd').format(_departureDate!)
                      : 'Select date',
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _searchFlights,
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
