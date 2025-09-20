// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class IternaryPlanner extends StatefulWidget {
//   const IternaryPlanner({super.key}); 

//   @override
//   State<IternaryPlanner> createState() => _IternaryPlannerState();
// }

// class _IternaryPlannerState extends State<IternaryPlanner> {
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _preferencesController = TextEditingController();
//   String _itinerary = '';
//   bool _isLoading = false;

//   Future<void> _generateItinerary() async {
//     String location = _locationController.text.trim();
//     String preferences = _preferencesController.text.trim();

//     if (location.isEmpty || preferences.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill both fields')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _itinerary = '';
//     });

//     try {
//       final response = await http.post(
//         Uri.parse("http://localhost:3000/generate-itinerary"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "location": location,
//           "preferences": preferences,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _itinerary = data['itinerary'] ?? 'No itinerary found';
//         });
//       } else {
//         setState(() {
//           _itinerary =
//               'Failed to generate itinerary. Status code: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _itinerary = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Iternary Planner')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Create Your Perfect Itinerary',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Let our AI craft a personalized travel plan for you.',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _locationController,
//               decoration: const InputDecoration(
//                 labelText: 'Location',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.location_on),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _preferencesController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 labelText: 'Preferences',
//                 hintText:
//                     'e.g., interested in beaches, historical sites, and local cuisine. Budget of ₹20,000.',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.note),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _generateItinerary,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(200, 50),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Generate Itinerary',
//                         style: TextStyle(fontSize: 18)),
//               ),
//             ),
//             const SizedBox(height: 30),
//             if (_itinerary.isNotEmpty)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   _itinerary,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IternaryPlanner extends StatefulWidget {
  const IternaryPlanner({super.key});

  @override
  State<IternaryPlanner> createState() => _IternaryPlannerState();
}

class _IternaryPlannerState extends State<IternaryPlanner> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  String _itinerary = '';
  bool _isLoading = false;

  Future<void> _generateItinerary() async {
    String location = _locationController.text.trim();
    String preferences = _preferencesController.text.trim();

    if (location.isEmpty || preferences.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill both fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _itinerary = '';
    });

    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/generate-itinerary"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "location": location,
          "preferences": preferences,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _itinerary = data['itinerary'] ?? 'No itinerary found';
        });
      } else {
        setState(() {
          _itinerary =
              'Failed to generate itinerary. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _itinerary = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iternary Planner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Your Perfect Itinerary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Let our AI craft a personalized travel plan for you.',
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
            TextField(
              controller: _preferencesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Preferences',
                hintText:
                    'e.g., interested in beaches, historical sites, local cuisine, Budget of ₹20,000.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateItinerary,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Generate Itinerary',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            if (_itinerary.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _itinerary,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
