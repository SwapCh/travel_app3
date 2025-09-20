// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'iternary_planner.dart';
// import 'location_explorer.dart';
// import 'accomodations.dart';
// import 'flights.dart';
// import 'trains.dart';
// import 'buses.dart';
// import 'chatbot.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> _images = [];
//   final List<String> locations = [
//     'jaipur', 'agra', 'mumbai', 'delhi', 'kerala', 'goa'
//   ];

//   final PageController _pageController = PageController();
//   Timer? _timer;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchImages();

//     // Auto page switching every 5 seconds
//     _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
//       if (_images.isNotEmpty && _pageController.hasClients) {
//         _currentPage++;
//         if (_currentPage >= _images.length) {
//           _currentPage = 0;
//         }
//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchImages() async {
//     List<String> fetchedImages = [];
//     for (String location in locations) {
//       final response = await http.get(Uri.parse(
//           'https://api.unsplash.com/search/photos?query=$location&client_id=JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg'));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['results'].isNotEmpty) {
//           fetchedImages.add(data['results'][0]['urls']['regular']);
//         }
//       }
//     }
//     setState(() {
//       _images = fetchedImages;
//     });
//   }

//   void _onSearch() {
//     String query = _searchController.text.trim();
//     if (query.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const LocationExplorer()),
//       );
//     }
//   }

//   Widget buildIcon(String title, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => page),
//         );
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 30,
//             child: Icon(icon, size: 30),
//           ),
//           const SizedBox(height: 5),
//           Text(title, textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: 'Search locations',
//             suffixIcon: IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: _onSearch,
//             ),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 200,
//               child: _images.isNotEmpty
//                   ? PageView.builder(
//                       controller: _pageController,
//                       itemCount: _images.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               _images[index],
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : const Center(child: CircularProgressIndicator()),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: GridView(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 20,
//                   crossAxisSpacing: 20,
//                   childAspectRatio: 0.8,
//                 ),
//                 children: [
//                   buildIcon('Itenary Planner', Icons.calendar_today,
//                       const ItenaryPlanner()),
//                   buildIcon(
//                       'Location Explorer', Icons.place, const LocationExplorer()),
//                   buildIcon(
//                       'Accomodations', Icons.hotel, const Accomodations()),
//                   buildIcon('Flights', Icons.flight, const Flights()),
//                   buildIcon('Trains', Icons.train, const Trains()),
//                   buildIcon('Buses', Icons.directions_bus, const Buses()),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ChatBot()),
//           );
//         },
//         child: const Icon(Icons.chat),
//       ),
//     );
//   }
// }


// // lib/home.dart
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'iternary_planner.dart';
// import 'location_explorer.dart';
// import 'accomodations.dart';
// import 'flights.dart';
// import 'trains.dart';
// import 'buses.dart';
// import 'chatbot.dart';
// import 'search_result.dart';

// const String UNSPLASH_CLIENT_ID = 'JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> _locationsToFetch = [
//     'jaipur',
//     'agra',
//     'mumbai',
//     'delhi',
//     'kerala',
//     'goa'
//   ];
//   List<String> _images = [];
//   final PageController _pageController = PageController();
//   Timer? _autoTimer;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchImages();
//     _startAutoSlide();
//   }

//   @override
//   void dispose() {
//     _autoTimer?.cancel();
//     _pageController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _startAutoSlide() {
//     _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
//       if (_images.isEmpty || !_pageController.hasClients) return;
//       _currentIndex = (_currentIndex + 1) % _images.length;
//       _pageController.animateToPage(
//         _currentIndex,
//         duration: const Duration(milliseconds: 600),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   Future<void> fetchImages() async {
//     List<String> fetched = [];
//     for (final loc in _locationsToFetch) {
//       try {
//         final uri = Uri.parse(
//             'https://api.unsplash.com/search/photos?query=${Uri.encodeComponent(loc)}&per_page=1&client_id=$UNSPLASH_CLIENT_ID');
//         final resp = await http.get(uri);
//         if (resp.statusCode == 200) {
//           final data = json.decode(resp.body);
//           final results = data['results'] as List<dynamic>;
//           if (results.isNotEmpty) {
//             final url = results[0]['urls']?['regular'] as String?;
//             if (url != null) fetched.add(url);
//           }
//         }
//       } catch (_) {
//         // ignore single location errors
//       }
//     }
//     if (mounted) {
//       setState(() {
//         _images = fetched;
//       });
//     }
//   }

//   void _onSearchSubmit(String q) {
//     final query = q.trim();
//     if (query.isEmpty) return;
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => SearchResultPage(query: query)),
//     );
//   }

//   Widget _buildIconTile(String title, IconData icon, Widget page) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Column(
//         children: [
//           Container(
//             height: 64,
//             width: 64,
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 30, color: Colors.blue.shade700),
//             alignment: Alignment.center,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final background = _images.isNotEmpty
//         ? PageView.builder(
//             controller: _pageController,
//             itemCount: _images.length,
//             itemBuilder: (context, index) {
//               return ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.network(
//                   _images[index],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               );
//             },
//           )
//         : ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Container(
//               color: Colors.grey.shade300,
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//           );

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       // No appBar — search is floating
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Top area with images + floating search
//               SizedBox(
//                 height: 240,
//                 child: Stack(
//                   children: [
//                     // background images
//                     Positioned.fill(
//                       left: 16,
//                       right: 16,
//                       top: 0,
//                       bottom: 0,
//                       child: background,
//                     ),

//                     // floating search bar (slightly overlapping the image)
//                     Positioned(
//                       left: 28,
//                       right: 28,
//                       bottom: 12,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: const [
//                             BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 6)),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: _searchController,
//                                 onSubmitted: _onSearchSubmit,
//                                 decoration: const InputDecoration(
//                                   hintText: 'Search locations (e.g. Mumbai)',
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () =>
//                                   _onSearchSubmit(_searchController.text),
//                               icon: const Icon(Icons.search),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Icon container with slight float, rounded corners and shadow
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: const [
//                       BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 8,
//                           offset: Offset(0, 6)),
//                     ],
//                   ),
//                   child: GridView(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       mainAxisSpacing: 10, // reduced gap between rows
//                       crossAxisSpacing: 12,
//                       childAspectRatio: 0.85,
//                     ),
//                     children: [
//                       _buildIconTile('Itenary Planner', Icons.calendar_today,
//                           const ItenaryPlanner()),
//                       _buildIconTile('Location Explorer', Icons.place,
//                           const LocationExplorer()),
//                       _buildIconTile('Accomodations', Icons.hotel,
//                           const Accomodations()),
//                       _buildIconTile('Flights', Icons.flight, const Flights()),
//                       _buildIconTile('Trains', Icons.train, const Trains()),
//                       _buildIconTile('Buses', Icons.directions_bus,
//                           const Buses()),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 18),
//               // Add any other sections you want below here...
//               const SizedBox(height: 80), // to allow FAB space
//             ],
//           ),
//         ),
//       ),

//       // chat floating button
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const ChatBot()),
//           );
//         },
//         child: const Icon(Icons.chat),
//       ),
//     );
//   }
// }



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'search_result.dart';
// import 'iternary_planner.dart';
// import 'location_explorer.dart';
// import 'accomodations.dart';
// import 'flights.dart';
// import 'trains.dart';
// import 'buses.dart';
// import 'chatbot.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   late Timer _timer;

//   final List<String> _images = [
//     // "https://images.unsplash.com/photo-1589308078054-8322a67c8a7f", // Jaipur
//     // "https://api.unsplash.com/search/photos?query=Jaipur&per_page=6&client_id=JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg",
//     // "https://images.unsplash.com/photo-1507525428034-b723cf961d3e", 
//     // "https://images.unsplash.com/photo-1548013146-72479768bada", 

//         'https://pixabay.com/api/?key=52387988-823b09a769b69f8eb7c59d3d7&q=jaipur&image_type=photo&per_page=10',
//   "https://pixabay.com/get/g2a3b1c0d4e6f7a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3g4_640.jpg", // Goa
//   "https://pixabay.com/get/g3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2g3h4_640.jpg", // Mumbai
//   ];

//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
//       if (_currentPage < _images.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onSearch() {
//     final query = _searchController.text.trim();
//     if (query.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchResultsPage(query: query),
//         ),
//       );
//     }
//   }

//   Widget _buildIcon(String label, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => page),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 32, color: Colors.teal),
//             const SizedBox(height: 6),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 16), // Top margin gap
//               // Auto-switching image container
//               SizedBox(
//                 height: 220,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: PageView.builder(
//                     controller: _pageController,
//                     itemCount: _images.length,
//                     itemBuilder: (context, index) {
//                       return Image.network(
//                         _images[index],
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               // Floating Search Bar
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.12),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   onSubmitted: (_) => _onSearch(),
//                   decoration: InputDecoration(
//                     hintText: "Search destinations...",
//                     border: InputBorder.none,
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.search, color: Colors.teal),
//                       onPressed: _onSearch,
//                     ),
//                   ),
//                 ),
//               ),
//               // Widget Icons
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: _buildIcon("Iternary Planner", Icons.event, IternaryPlanner()),
//                         ),
//                         Expanded(
//                           child: _buildIcon("Explorer", Icons.location_on, LocationExplorer()),
//                         ),
//                         Expanded(
//                           child: _buildIcon("Accomodations", Icons.hotel, Accomodations()),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: _buildIcon("Flights", Icons.flight, Flights()),
//                         ),
//                         Expanded(
//                           child: _buildIcon("Trains", Icons.train, Trains()),
//                         ),
//                         Expanded(
//                           child: _buildIcon("Buses", Icons.directions_bus, Buses()),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // Floating chatbot button
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.teal,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ChatBot()),
//           );
//         },
//         child: const Icon(Icons.chat),
//       ),
//     );
//   }
// }



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'search_result.dart';
// import 'iternary_planner.dart';
// import 'location_explorer.dart';
// import 'accomodations.dart';
// import 'flights.dart';
// import 'trains.dart';
// import 'buses.dart';
// import 'chatbot.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   late Timer _timer;

//   final List<String> _images = [
//     'https://api.unsplash.com/photos/?jaipurclient_id=JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg',
//     'https://pixabay.com/get/g3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2g3h4_640.jpg', // Goa
//     'https://pixabay.com/get/g4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3g4h5_640.jpg', // Mumbai
//   ];

//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
//       _currentPage = (_currentPage + 1) % _images.length;
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onSearch() {
//     final query = _searchController.text.trim();
//     if (query.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchResultsPage(query: query),
//         ),
//       );
//     }
//   }

//   Widget _buildIcon(String label, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => page),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 32, color: Colors.teal),
//             const SizedBox(height: 6),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               SizedBox(
//                 height: 220,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: PageView.builder(
//                     controller: _pageController,
//                     itemCount: _images.length,
//                     itemBuilder: (context, index) {
//                       return Image.network(
//                         _images[index],
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Container(
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.12),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   onSubmitted: (_) => _onSearch(),
//                   decoration: InputDecoration(
//                     hintText: "Search destinations...",
//                     border: InputBorder.none,
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.search, color: Colors.teal),
//                       onPressed: _onSearch,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: _buildIcon(
//                             "Iternary Planner",
//                             Icons.event,
//                             const IternaryPlanner(),
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildIcon(
//                             "Explorer",
//                             Icons.location_on,
//                             const LocationExplorer(),
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildIcon(
//                             "Accomodations",
//                             Icons.hotel,
//                             const Accomodations(),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: _buildIcon(
//                             "Flights",
//                             Icons.flight,
//                             const Flights(),
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildIcon(
//                             "Trains",
//                             Icons.train,
//                             const Trains(),
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildIcon(
//                             "Buses",
//                             Icons.directions_bus,
//                             const Buses(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.teal,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ChatBot()),
//           );
//         },
//         child: const Icon(Icons.chat),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'search_result.dart';
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
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _images = [
    'https://api.unsplash.com/photos/?jaipurclient_id=JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg',
    'https://pixabay.com/get/g3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2g3h4_640.jpg', // Goa
    'https://pixabay.com/get/g4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3g4h5_640.jpg', // Mumbai
  ];

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> trips = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _currentPage = (_currentPage + 1) % _images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query),
        ),
      );
    }
  }

  void _openTripForm({int? editIndex}) {
    final _originController = TextEditingController();
    final _destinationController = TextEditingController();
    final _travelersController = TextEditingController();
    DateTime? _startDate;
    DateTime? _endDate;
    String _mode = 'Flight';
    String _status = 'Planned';

    if (editIndex != null) {
      final trip = trips[editIndex];
      _originController.text = trip['origin'] ?? '';
      _destinationController.text = trip['destination'] ?? '';
      _travelersController.text = trip['travelers'] ?? '';
      _startDate = trip['startDate'];
      _endDate = trip['endDate'];
      _mode = trip['mode'];
      _status = trip['status'];
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(editIndex != null ? 'Edit Trip' : 'Add Trip'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _originController,
                  decoration: const InputDecoration(labelText: 'Origin'),
                ),
                TextField(
                  controller: _destinationController,
                  decoration: const InputDecoration(labelText: 'Destination'),
                ),
                TextField(
                  controller: _travelersController,
                  decoration: const InputDecoration(labelText: 'Travelers'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _mode,
                  items: ['Flight', 'Train', 'Bus', 'Hotel']
                      .map((mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _mode = val!),
                  decoration: const InputDecoration(labelText: 'Mode'),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text(_startDate != null
                      ? 'Start: ${DateFormat('yyyy-MM-dd').format(_startDate!)}'
                      : 'Select Start Date'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => _startDate = date);
                  },
                ),
                ListTile(
                  title: Text(_endDate != null
                      ? 'End: ${DateFormat('yyyy-MM-dd').format(_endDate!)}'
                      : 'Select End Date'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => _endDate = date);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final tripData = {
                  'origin': _originController.text,
                  'destination': _destinationController.text,
                  'travelers': _travelersController.text,
                  'startDate': _startDate,
                  'endDate': _endDate,
                  'mode': _mode,
                  'status': _status,
                };
                setState(() {
                  if (editIndex != null) {
                    trips[editIndex] = tripData;
                  } else {
                    trips.add(tripData);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String label, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.teal),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        _images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearch(),
                  decoration: InputDecoration(
                    hintText: "Search destinations...",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.teal),
                      onPressed: _onSearch,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildIcon(
                            "Iternary Planner",
                            Icons.event,
                            const IternaryPlanner(),
                          ),
                        ),
                        Expanded(
                          child: _buildIcon(
                            "Explorer",
                            Icons.location_on,
                            const LocationExplorer(),
                          ),
                        ),
                        Expanded(
                          child: _buildIcon(
                            "Accomodations",
                            Icons.hotel,
                            const Accomodations(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildIcon(
                            "Flights",
                            Icons.flight,
                            const Flights(),
                          ),
                        ),
                        Expanded(
                          child: _buildIcon(
                            "Trains",
                            Icons.train,
                            const Trains(),
                          ),
                        ),
                        Expanded(
                          child: _buildIcon(
                            "Buses",
                            Icons.directions_bus,
                            const Buses(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // ------------------- ADD TRIP FEATURE -------------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Trips",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Manage and view your travel plans.",
                            style: TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => _openTripForm(),
                            child: const Text("Add Trip"),
                          ),
                          const SizedBox(height: 12),
                          trips.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text("Mode")),
                                      DataColumn(label: Text("Trip")),
                                      DataColumn(label: Text("Travelers")),
                                      DataColumn(label: Text("Date")),
                                      DataColumn(label: Text("Status")),
                                      DataColumn(label: Text("Actions")),
                                    ],
                                    rows: trips
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => DataRow(cells: [
                                            DataCell(Text(entry.value['mode'] ?? '')),
                                            DataCell(Text(
                                                "${entry.value['origin']} → ${entry.value['destination']}")),
                                            DataCell(Text(entry.value['travelers'] ?? '')),
                                            DataCell(Text(
                                                "${entry.value['startDate'] != null ? DateFormat('yyyy-MM-dd').format(entry.value['startDate']) : ''} → ${entry.value['endDate'] != null ? DateFormat('yyyy-MM-dd').format(entry.value['endDate']) : ''}")),
                                            DataCell(Text(entry.value['status'] ?? '')),
                                            DataCell(
                                              PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  if (value == 'Edit') {
                                                    _openTripForm(editIndex: entry.key);
                                                  } else if (value == 'Delete') {
                                                    setState(() {
                                                      trips.removeAt(entry.key);
                                                    });
                                                  }
                                                },
                                                itemBuilder: (context) => const [
                                                  PopupMenuItem(
                                                    value: 'Edit',
                                                    child: Text('Edit'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'Delete',
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                                child: const Icon(Icons.more_vert),
                                              ),
                                            ),
                                          ]),
                                        )
                                        .toList(),
                                  ),
                                )
                              : const Text(
                                  "No trips added yet.",
                                  style: TextStyle(color: Colors.black54),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBot()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}


