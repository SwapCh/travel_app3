import 'package:flutter/material.dart';

class LocationExplorer extends StatelessWidget {
  const LocationExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Explorer')),
      body: const Center(child: Text('Location Explorer Page')),
    );
  }
}
