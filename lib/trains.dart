import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Trains extends StatefulWidget {
  const Trains({super.key});

  @override
  State<Trains> createState() => _TrainsState();
}

class _TrainsState extends State<Trains> {
  final TextEditingController _fromController = TextEditingController(text: 'Mumbai');
  DateTime? _journeyDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _journeyDate ?? initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _journeyDate = picked;
      });
    }
  }

  void _searchTrains() {
    String from = _fromController.text;
    String date = _journeyDate != null
        ? DateFormat('yyyy-MM-dd').format(_journeyDate!)
        : 'Not selected';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching trains from $from on $date'),
      ),
    );
    // TODO: Replace with actual search logic or API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Train Tickets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find the best prices for train journeys across India.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'From',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.train),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _journeyDate != null
                      ? DateFormat('yyyy-MM-dd').format(_journeyDate!)
                      : 'Select date',
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _searchTrains,
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
