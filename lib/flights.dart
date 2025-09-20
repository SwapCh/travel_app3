import 'package:flutter/material.dart';

class Flights extends StatelessWidget {
  const Flights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flights')),
      body: const Center(child: Text('Flights Page')),
    );
  }
}
