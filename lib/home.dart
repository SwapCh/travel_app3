import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'iternary_planner.dart';
import 'location_explorer.dart';
import 'accomodations.dart';
import 'flights.dart';
import 'trains.dart';
import 'buses.dart';
import 'chatbot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _images = [];
  final List<String> locations = [
    'jaipur', 'agra', 'mumbai', 'delhi', 'kerala', 'goa'
  ];

  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchImages();

    // Auto page switching every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_images.isNotEmpty && _pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= _images.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchImages() async {
    List<String> fetchedImages = [];
    for (String location in locations) {
      final response = await http.get(Uri.parse(
          'https://api.unsplash.com/search/photos?query=$location&client_id=JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          fetchedImages.add(data['results'][0]['urls']['regular']);
        }
      }
    }
    setState(() {
      _images = fetchedImages;
    });
  }

  void _onSearch() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LocationExplorer()),
      );
    }
  }

  Widget buildIcon(String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search locations',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onSearch,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: _images.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                children: [
                  buildIcon('Itenary Planner', Icons.calendar_today,
                      const ItenaryPlanner()),
                  buildIcon(
                      'Location Explorer', Icons.place, const LocationExplorer()),
                  buildIcon(
                      'Accomodations', Icons.hotel, const Accomodations()),
                  buildIcon('Flights', Icons.flight, const Flights()),
                  buildIcon('Trains', Icons.train, const Trains()),
                  buildIcon('Buses', Icons.directions_bus, const Buses()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBot()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
