// // // lib/search_result.dart
// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:intl/intl.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // const String UNSPLASH_CLIENT_ID = 'JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg';

// // // Optional: Add your NewsAPI key here to enable recent news.
// // // Get key at https://newsapi.org/ (free tier available)
// // const String NEWS_API_KEY = ''; // <-- put your key here (or leave empty)

// // class SearchResultPage extends StatefulWidget {
// //   final String query;
// //   const SearchResultPage({super.key, required this.query});

// //   @override
// //   State<SearchResultPage> createState() => _SearchResultPageState();
// // }

// // class _SearchResultPageState extends State<SearchResultPage> {
// //   // images for top switching banner
// //   List<String> placeImages = [];
// //   // top places list (image + title)
// //   List<Map<String, String>> topPlaces = [];

// //   // weather: list of maps {date, min, max, weathercode}
// //   List<Map<String, dynamic>> threeDayWeather = [];

// //   // news items
// //   List<Map<String, dynamic>> news = [];

// //   bool loadingImages = true;
// //   bool loadingTopPlaces = true;
// //   bool loadingWeather = true;
// //   bool loadingNews = true;

// //   // for auto-switching banner
// //   final PageController _bannerController = PageController();
// //   Timer? _bannerTimer;
// //   int _bannerIndex = 0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchAll();
// //     _startBannerAutoSwitch();
// //   }

// //   @override
// //   void dispose() {
// //     _bannerTimer?.cancel();
// //     _bannerController.dispose();
// //     super.dispose();
// //   }

// //   void _startBannerAutoSwitch() {
// //     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
// //       if (placeImages.isEmpty || !_bannerController.hasClients) return;
// //       _bannerIndex = (_bannerIndex + 1) % placeImages.length;
// //       _bannerController.animateToPage(
// //         _bannerIndex,
// //         duration: const Duration(milliseconds: 500),
// //         curve: Curves.easeInOut,
// //       );
// //     });
// //   }

// //   Future<void> _fetchAll() async {
// //     final q = widget.query;
// //     _fetchPlaceImages(q);
// //     _fetchTopPlaces(q);
// //     await _fetchWeather(q);
// //     _fetchNews(q);
// //   }

// //   Future<void> _fetchPlaceImages(String q) async {
// //     setState(() => loadingImages = true);
// //     try {
// //       final uri = Uri.parse(
// //           'https://api.unsplash.com/search/photos?query=${Uri.encodeComponent(q)}&per_page=6&client_id=$UNSPLASH_CLIENT_ID');
// //       final resp = await http.get(uri);
// //       if (resp.statusCode == 200) {
// //         final data = json.decode(resp.body);
// //         final results = (data['results'] as List<dynamic>);
// //         final urls = results
// //             .map<String?>((r) => r['urls']?['regular'] as String?)
// //             .whereType<String>()
// //             .toList();
// //         if (mounted) {
// //           setState(() {
// //             placeImages = urls;
// //           });
// //         }
// //       }
// //     } catch (_) {
// //       // ignore
// //     } finally {
// //       if (mounted) setState(() => loadingImages = false);
// //     }
// //   }

// //   Future<void> _fetchTopPlaces(String q) async {
// //     setState(() => loadingTopPlaces = true);
// //     try {
// //       // try a couple of Unsplash queries (attractions, landmarks)
// //       final suggestions = [
// //         '$q attractions',
// //         '$q landmarks',
// //         '$q sightseeing',
// //       ];

// //       List<Map<String, String>> aggregated = [];
// //       for (final s in suggestions) {
// //         final uri = Uri.parse(
// //             'https://api.unsplash.com/search/photos?query=${Uri.encodeComponent(s)}&per_page=6&client_id=$UNSPLASH_CLIENT_ID');
// //         final resp = await http.get(uri);
// //         if (resp.statusCode == 200) {
// //           final data = json.decode(resp.body);
// //           final results = data['results'] as List<dynamic>;
// //           for (var r in results) {
// //             final img = r['urls']?['regular'] as String?;
// //             final title = (r['alt_description'] ??
// //                     r['description'] ??
// //                     r['user']?['name'] ??
// //                     '')
// //                 .toString();
// //             if (img != null) {
// //               aggregated.add({'image': img, 'title': title.isNotEmpty ? title : 'Place'});
// //             }
// //           }
// //         }
// //         if (aggregated.length >= 6) break;
// //       }

// //       if (mounted) {
// //         setState(() {
// //           topPlaces = aggregated.take(6).toList();
// //         });
// //       }
// //     } catch (_) {
// //       // ignore
// //     } finally {
// //       if (mounted) setState(() => loadingTopPlaces = false);
// //     }
// //   }

// //   Future<void> _fetchWeather(String q) async {
// //     setState(() => loadingWeather = true);
// //     try {
// //       // 1) geocode via Nominatim (no API key). Be polite: set a User-Agent
// //       final geoUri = Uri.parse(
// //           'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(q)}&format=json&limit=1');
// //       final geoResp = await http.get(geoUri, headers: {
// //         'User-Agent': 'TravelApp/1.0 (youremail@example.com)'
// //       });
// //       if (geoResp.statusCode != 200) {
// //         if (mounted) setState(() => loadingWeather = false);
// //         return;
// //       }
// //       final geoData = json.decode(geoResp.body) as List<dynamic>;
// //       if (geoData.isEmpty) {
// //         if (mounted) setState(() => loadingWeather = false);
// //         return;
// //       }
// //       final lat = double.tryParse(geoData[0]['lat'].toString());
// //       final lon = double.tryParse(geoData[0]['lon'].toString());
// //       if (lat == null || lon == null) {
// //         if (mounted) setState(() => loadingWeather = false);
// //         return;
// //       }

// //       // 2) Open-Meteo for a 3-day window (yesterday, today, tomorrow)
// //       final today = DateTime.now().toUtc();
// //       final yesterday = today.subtract(const Duration(days: 1));
// //       final tomorrow = today.add(const Duration(days: 1));
// //       final startDate = DateFormat('yyyy-MM-dd').format(yesterday);
// //       final endDate = DateFormat('yyyy-MM-dd').format(tomorrow);

// //       final weatherUri = Uri.parse(
// //           'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min,weathercode&start_date=$startDate&end_date=$endDate&timezone=auto');
// //       final weatherResp = await http.get(weatherUri);

// //       if (weatherResp.statusCode == 200) {
// //         final wData = json.decode(weatherResp.body);
// //         final daily = wData['daily'];
// //         if (daily != null) {
// //           final dates = (daily['time'] as List<dynamic>).cast<String>();
// //           final mins = (daily['temperature_2m_min'] as List<dynamic>).cast<num>();
// //           final maxs = (daily['temperature_2m_max'] as List<dynamic>).cast<num>();
// //           final codes = (daily['weathercode'] as List<dynamic>).cast<num>();

// //           final combined = <Map<String, dynamic>>[];
// //           for (int i = 0; i < dates.length; i++) {
// //             combined.add({
// //               'date': dates[i],
// //               'min': mins[i].toDouble(),
// //               'max': maxs[i].toDouble(),
// //               'code': codes[i].toInt()
// //             });
// //           }
// //           if (mounted) setState(() => threeDayWeather = combined);
// //         }
// //       }
// //     } catch (_) {
// //       // ignore
// //     } finally {
// //       if (mounted) setState(() => loadingWeather = false);
// //     }
// //   }

// //   Future<void> _fetchNews(String q) async {
// //     setState(() => loadingNews = true);
// //     try {
// //       if (NEWS_API_KEY.trim().isEmpty) {
// //         if (mounted) {
// //           setState(() {
// //             news = [];
// //           });
// //         }
// //         return;
// //       }
// //       final to = DateFormat('yyyy-MM-dd').format(DateTime.now());
// //       final from = DateFormat('yyyy-MM-dd')
// //           .format(DateTime.now().subtract(const Duration(days: 3)));
// //       final uri = Uri.parse(
// //           'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(q)}&from=$from&to=$to&sortBy=publishedAt&pageSize=10&language=en&apiKey=$NEWS_API_KEY');
// //       final resp = await http.get(uri);
// //       if (resp.statusCode == 200) {
// //         final data = json.decode(resp.body);
// //         final articles = (data['articles'] as List<dynamic>?) ?? [];
// //         final mapped = articles.map<Map<String, dynamic>>((a) {
// //           return {
// //             'title': a['title'] ?? '',
// //             'source': a['source']?['name'] ?? '',
// //             'url': a['url'] ?? '',
// //             'publishedAt': a['publishedAt'] ?? ''
// //           };
// //         }).toList();
// //         if (mounted) setState(() => news = mapped.cast<Map<String, dynamic>>());
// //       } else {
// //         if (mounted) setState(() => news = []);
// //       }
// //     } catch (_) {
// //       if (mounted) setState(() => news = []);
// //     } finally {
// //       if (mounted) setState(() => loadingNews = false);
// //     }
// //   }

// //   String _humanWeatherDescription(int code) {
// //     // very small mapping for demonstration (Open-Meteo uses WMO weather codes)
// //     if (code == 0) return 'Clear';
// //     if (code == 1 || code == 2 || code == 3) return 'Partly cloudy';
// //     if (code >= 45 && code <= 48) return 'Fog';
// //     if (code >= 51 && code <= 67) return 'Rain';
// //     if (code >= 71 && code <= 77) return 'Snow/ice';
// //     if (code >= 80 && code <= 82) return 'Rain showers';
// //     if (code >= 95) return 'Thunderstorm';
// //     return 'Weather';
// //   }

// //   Widget _buildSectionTitle(String title) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //       child: Text(title,
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //     );
// //   }

// //   Future<void> _openUrl(String url) async {
// //     final uri = Uri.tryParse(url);
// //     if (uri == null) return;
// //     if (!await launchUrl(uri)) {
// //       // can't launch; ignore
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final banner = SizedBox(
// //       height: 200,
// //       child: loadingImages
// //           ? const Center(child: CircularProgressIndicator())
// //           : placeImages.isEmpty
// //               ? Center(
// //                   child: Container(
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade200,
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: const Text('No images found'),
// //                   ),
// //                 )
// //               : PageView.builder(
// //                   controller: _bannerController,
// //                   itemCount: placeImages.length,
// //                   itemBuilder: (context, i) => Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(12),
// //                       child: Image.network(
// //                         placeImages[i],
// //                         fit: BoxFit.cover,
// //                         width: double.infinity,
// //                         errorBuilder: (_, __, ___) => Container(
// //                           color: Colors.grey.shade300,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //     );

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.query),
// //       ),
// //       body: RefreshIndicator(
// //         onRefresh: () async {
// //           await _fetchAll();
// //         },
// //         child: SingleChildScrollView(
// //           physics: const AlwaysScrollableScrollPhysics(),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // banner
// //               const SizedBox(height: 12),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 12),
// //                 child: banner,
// //               ),
// //               const SizedBox(height: 8),
// //               // Top places
// //               _buildSectionTitle('Top Places to see'),
// //               loadingTopPlaces
// //                   ? const Padding(
// //                       padding: EdgeInsets.all(20),
// //                       child: Center(child: CircularProgressIndicator()))
// //                   : SizedBox(
// //                       height: 160,
// //                       child: topPlaces.isEmpty
// //                           ? const Padding(
// //                               padding: EdgeInsets.symmetric(horizontal: 16),
// //                               child: Text('No top places found.'),
// //                             )
// //                           : PageView.builder(
// //                               controller: PageController(viewportFraction: 0.8),
// //                               itemCount: topPlaces.length,
// //                               itemBuilder: (context, idx) {
// //                                 final p = topPlaces[idx];
// //                                 return Padding(
// //                                   padding:
// //                                       const EdgeInsets.symmetric(horizontal: 8),
// //                                   child: ClipRRect(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     child: Stack(
// //                                       fit: StackFit.expand,
// //                                       children: [
// //                                         Image.network(
// //                                           p['image']!,
// //                                           fit: BoxFit.cover,
// //                                           errorBuilder: (_, __, ___) =>
// //                                               Container(color: Colors.grey),
// //                                         ),
// //                                         Container(
// //                                           decoration: BoxDecoration(
// //                                             gradient: LinearGradient(
// //                                               begin: Alignment.bottomCenter,
// //                                               end: Alignment.topCenter,
// //                                               colors: [
// //                                                 Colors.black.withOpacity(0.6),
// //                                                 Colors.transparent
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ),
// //                                         Positioned(
// //                                           left: 12,
// //                                           bottom: 12,
// //                                           right: 12,
// //                                           child: Text(
// //                                             p['title']!,
// //                                             maxLines: 2,
// //                                             overflow: TextOverflow.ellipsis,
// //                                             style: const TextStyle(
// //                                                 color: Colors.white,
// //                                                 fontWeight: FontWeight.bold),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                     ),

// //               const SizedBox(height: 12),

// //               // Weather section
// //               _buildSectionTitle('Weather forecast'),
// //               loadingWeather
// //                   ? const Padding(
// //                       padding: EdgeInsets.all(20),
// //                       child: Center(child: CircularProgressIndicator()))
// //                   : threeDayWeather.isEmpty
// //                       ? const Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: 16),
// //                           child: Text('Weather data not available.'),
// //                         )
// //                       : Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 8),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                             children: threeDayWeather.map((w) {
// //                               final dt = DateFormat('EEE, d MMM')
// //                                   .format(DateTime.parse(w['date']));
// //                               final min = w['min'];
// //                               final max = w['max'];
// //                               final desc = _humanWeatherDescription(w['code']);
// //                               return Container(
// //                                 width: MediaQuery.of(context).size.width / 3.6,
// //                                 padding: const EdgeInsets.all(8),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(10),
// //                                   boxShadow: const [
// //                                     BoxShadow(
// //                                         color: Colors.black12,
// //                                         blurRadius: 6,
// //                                         offset: Offset(0, 4))
// //                                   ],
// //                                 ),
// //                                 child: Column(
// //                                   mainAxisSize: MainAxisSize.min,
// //                                   children: [
// //                                     Text(dt,
// //                                         style: const TextStyle(
// //                                             fontSize: 12,
// //                                             fontWeight: FontWeight.w600)),
// //                                     const SizedBox(height: 6),
// //                                     Text(desc,
// //                                         style: const TextStyle(fontSize: 12)),
// //                                     const SizedBox(height: 6),
// //                                     Text('${max.toString()}° / ${min.toString()}°',
// //                                         style: const TextStyle(
// //                                             fontWeight: FontWeight.bold)),
// //                                   ],
// //                                 ),
// //                               );
// //                             }).toList(),
// //                           ),
// //                         ),

// //               const SizedBox(height: 20),

// //               // News section
// //               _buildSectionTitle('Latest news (last 3 days)'),
// //               loadingNews
// //                   ? const Padding(
// //                       padding: EdgeInsets.all(20),
// //                       child: Center(child: CircularProgressIndicator()))
// //                   : (NEWS_API_KEY.trim().isEmpty
// //                       ? Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 16),
// //                           child: Text(
// //                               'News disabled — add a NewsAPI key to enable latest news. Put your key in search_result.dart NEWS_API_KEY constant.'),
// //                         )
// //                       : news.isEmpty
// //                           ? const Padding(
// //                               padding: EdgeInsets.symmetric(horizontal: 16),
// //                               child: Text('No recent articles found.'),
// //                             )
// //                           : Column(
// //                               children: news.map((a) {
// //                                 final title = a['title'] ?? '';
// //                                 final src = a['source'] ?? '';
// //                                 final url = a['url'] ?? '';
// //                                 final published = a['publishedAt'] ?? '';
// //                                 final dateStr = published.isNotEmpty
// //                                     ? DateFormat('d MMM, HH:mm').format(
// //                                         DateTime.parse(published).toLocal())
// //                                     : '';
// //                                 return ListTile(
// //                                   title: Text(title),
// //                                   subtitle: Text('$src • $dateStr'),
// //                                   onTap: () => _openUrl(url),
// //                                 );
// //                               }).toList(),
// //                             )),

// //               const SizedBox(height: 40),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// // lib/search_result.dart
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_fonts/google_fonts.dart';

// /// Replace with your Unsplash Access Key (or keep the provided demo key).
// const String UNSPLASH_CLIENT_ID = 'JWw2z4Mfk07EOFK35aBPg0m8BWY3QgAVknYC6xq0qrg';

// /// Optional: add your NewsAPI key to enable "Latest News".
// /// Get an API key at https://newsapi.org/ and paste it here.
// const String NEWS_API_KEY = 'aefbf3c560a049518f9ba88fb5b48fc9'; // <-- put your NewsAPI key here (optional)

// class SearchResultsPage extends StatefulWidget {
//   final String place;
//   const SearchResultsPage({super.key, required this.place});

//   @override
//   State<SearchResultsPage> createState() => _SearchResultsPageState();
// }

// class _SearchResultsPageState extends State<SearchResultsPage> {
//   // Banner images for top switching banner
//   List<String> placeImages = [];

//   // Top places list (image + title)
//   List<Map<String, String>> topPlaces = [];

//   // Weather: list of {date, min, max, code}
//   List<Map<String, dynamic>> threeDayWeather = [];

//   // News items (optional)
//   List<Map<String, dynamic>> news = [];

//   // Loading flags
//   bool loadingImages = true;
//   bool loadingTopPlaces = true;
//   bool loadingWeather = true;
//   bool loadingNews = true;

//   // Banner auto-switch
//   final PageController _bannerController = PageController();
//   Timer? _bannerTimer;
//   int _bannerIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAll();
//     _startBannerAutoSwitch();
//   }

//   @override
//   void didUpdateWidget(covariant SearchResultsPage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // If user navigates to the same page object but with a different place,
//     // re-fetch everything.
//     if (oldWidget.place != widget.place) {
//       _fetchAll();
//     }
//   }

//   @override
//   void dispose() {
//     _bannerTimer?.cancel();
//     _bannerController.dispose();
//     super.dispose();
//   }

//   void _startBannerAutoSwitch() {
//     _bannerTimer?.cancel();
//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (placeImages.isEmpty || !_bannerController.hasClients) return;
//       _bannerIndex = (_bannerIndex + 1) % placeImages.length;
//       _bannerController.animateToPage(
//         _bannerIndex,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   Future<void> _fetchAll() async {
//     final q = widget.place.trim();
//     setState(() {
//       // reset previous data while loading new
//       placeImages = [];
//       topPlaces = [];
//       threeDayWeather = [];
//       news = [];
//       loadingImages = loadingTopPlaces = loadingWeather = loadingNews = true;
//     });

//     await Future.wait([
//       _fetchPlaceImages(q),
//       _fetchTopPlaces(q),
//       _fetchWeather(q),
//       _fetchNews(q),
//     ]);

//     // Restart banner timer in case images changed
//     _startBannerAutoSwitch();
//   }

//   Future<void> _fetchPlaceImages(String q) async {
//     if (q.isEmpty) {
//       setState(() {
//         loadingImages = false;
//         placeImages = [];
//       });
//       return;
//     }
//     try {
//       final uri = Uri.parse(
//           'https://api.unsplash.com/search/photos?query=${Uri.encodeComponent(q)}&per_page=6&client_id=$UNSPLASH_CLIENT_ID');
//       final resp = await http.get(uri);
//       if (resp.statusCode == 200) {
//         final data = json.decode(resp.body);
//         final results = (data['results'] as List<dynamic>?) ?? [];
//         final urls = results
//             .map<String?>((r) => r['urls']?['regular'] as String?)
//             .whereType<String>()
//             .toList();
//         if (mounted) {
//           setState(() {
//             placeImages = urls;
//           });
//         }
//       } else {
//         if (mounted) setState(() => placeImages = []);
//       }
//     } catch (_) {
//       if (mounted) setState(() => placeImages = []);
//     } finally {
//       if (mounted) setState(() => loadingImages = false);
//     }
//   }

//   Future<void> _fetchTopPlaces(String q) async {
//     if (q.isEmpty) {
//       setState(() {
//         loadingTopPlaces = false;
//         topPlaces = [];
//       });
//       return;
//     }
//     try {
//       final queries = [
//         '$q attractions',
//         '$q landmarks',
//         '$q sightseeing',
//       ];
//       final List<Map<String, String>> aggregated = [];

//       for (final s in queries) {
//         final uri = Uri.parse(
//             'https://api.unsplash.com/search/photos?query=${Uri.encodeComponent(s)}&per_page=6&client_id=$UNSPLASH_CLIENT_ID');
//         final resp = await http.get(uri);
//         if (resp.statusCode == 200) {
//           final data = json.decode(resp.body);
//           final results = (data['results'] as List<dynamic>?) ?? [];
//           for (var r in results) {
//             final img = r['urls']?['regular'] as String?;
//             final title = (r['alt_description'] ??
//                     r['description'] ??
//                     r['user']?['name'] ??
//                     '')
//                 .toString();
//             if (img != null) {
//               aggregated.add({'image': img, 'title': title.isNotEmpty ? title : 'Place'});
//             }
//           }
//         }
//         if (aggregated.length >= 6) break;
//       }

//       if (mounted) setState(() => topPlaces = aggregated.take(6).toList());
//     } catch (_) {
//       if (mounted) setState(() => topPlaces = []);
//     } finally {
//       if (mounted) setState(() => loadingTopPlaces = false);
//     }
//   }

//   Future<void> _fetchWeather(String q) async {
//     if (q.isEmpty) {
//       setState(() {
//         loadingWeather = false;
//         threeDayWeather = [];
//       });
//       return;
//     }
//     try {
//       // geocode using Nominatim (OpenStreetMap) - no key required
//       final geoUri = Uri.parse(
//           'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(q)}&format=json&limit=1');
//       final geoResp = await http.get(geoUri, headers: {
//         'User-Agent': 'TravelApp/1.0 (contact@example.com)'
//       });

//       if (geoResp.statusCode != 200) {
//         if (mounted) setState(() => threeDayWeather = []);
//         return;
//       }
//       final geoList = (json.decode(geoResp.body) as List<dynamic>?) ?? [];
//       if (geoList.isEmpty) {
//         if (mounted) setState(() => threeDayWeather = []);
//         return;
//       }

//       final lat = double.tryParse(geoList[0]['lat'].toString());
//       final lon = double.tryParse(geoList[0]['lon'].toString());
//       if (lat == null || lon == null) {
//         if (mounted) setState(() => threeDayWeather = []);
//         return;
//       }

//       // get yesterday, today, tomorrow (Open-Meteo)
//       final today = DateTime.now().toUtc();
//       final yesterday = today.subtract(const Duration(days: 1));
//       final tomorrow = today.add(const Duration(days: 1));
//       final start = DateFormat('yyyy-MM-dd').format(yesterday);
//       final end = DateFormat('yyyy-MM-dd').format(tomorrow);

//       final weatherUri = Uri.parse(
//           'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min,weathercode&start_date=$start&end_date=$end&timezone=auto');

//       final weatherResp = await http.get(weatherUri);

//       if (weatherResp.statusCode == 200) {
//         final wData = json.decode(weatherResp.body);
//         final daily = wData['daily'];
//         if (daily != null) {
//           final dates = (daily['time'] as List<dynamic>).cast<String>();
//           final mins = (daily['temperature_2m_min'] as List<dynamic>).cast<num>();
//           final maxs = (daily['temperature_2m_max'] as List<dynamic>).cast<num>();
//           final codes = (daily['weathercode'] as List<dynamic>).cast<num>();

//           final combined = <Map<String, dynamic>>[];
//           for (int i = 0; i < dates.length; i++) {
//             combined.add({
//               'date': dates[i],
//               'min': mins[i].toDouble(),
//               'max': maxs[i].toDouble(),
//               'code': codes[i].toInt(),
//             });
//           }
//           if (mounted) setState(() => threeDayWeather = combined);
//         }
//       } else {
//         if (mounted) setState(() => threeDayWeather = []);
//       }
//     } catch (_) {
//       if (mounted) setState(() => threeDayWeather = []);
//     } finally {
//       if (mounted) setState(() => loadingWeather = false);
//     }
//   }

//   Future<void> _fetchNews(String q) async {
//     if (q.isEmpty) {
//       setState(() {
//         loadingNews = false;
//         news = [];
//       });
//       return;
//     }
//     if (NEWS_API_KEY.trim().isEmpty) {
//       // News disabled
//       if (mounted) setState(() {
//         news = [];
//         loadingNews = false;
//       });
//       return;
//     }

//     try {
//       final to = DateFormat('yyyy-MM-dd').format(DateTime.now());
//       final from = DateFormat('yyyy-MM-dd')
//           .format(DateTime.now().subtract(const Duration(days: 3)));
//       final uri = Uri.parse(
//           'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(q)}&from=$from&to=$to&sortBy=publishedAt&pageSize=10&language=en&apiKey=$NEWS_API_KEY');

//       final resp = await http.get(uri);
//       if (resp.statusCode == 200) {
//         final data = json.decode(resp.body);
//         final articles = (data['articles'] as List<dynamic>?) ?? [];
//         final mapped = articles.map<Map<String, dynamic>>((a) {
//           return {
//             'title': a['title'] ?? '',
//             'source': a['source']?['name'] ?? '',
//             'url': a['url'] ?? '',
//             'publishedAt': a['publishedAt'] ?? ''
//           };
//         }).toList();
//         if (mounted) setState(() => news = mapped.cast<Map<String, dynamic>>());
//       } else {
//         if (mounted) setState(() => news = []);
//       }
//     } catch (_) {
//       if (mounted) setState(() => news = []);
//     } finally {
//       if (mounted) setState(() => loadingNews = false);
//     }
//   }

//   String _humanWeatherDescription(int code) {
//     if (code == 0) return 'Clear';
//     if (code == 1 || code == 2 || code == 3) return 'Partly cloudy';
//     if (code >= 45 && code <= 48) return 'Fog';
//     if (code >= 51 && code <= 67) return 'Rain';
//     if (code >= 71 && code <= 77) return 'Snow/ice';
//     if (code >= 80 && code <= 82) return 'Rain showers';
//     if (code >= 95) return 'Thunderstorm';
//     return 'Weather';
//   }

//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Text(title,
//           style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
//     );
//   }

//   Future<void> _openUrl(String url) async {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return;
//     try {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } catch (_) {
//       // ignore
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final banner = SizedBox(
//       height: 200,
//       child: loadingImages
//           ? const Center(child: CircularProgressIndicator())
//           : placeImages.isEmpty
//               ? Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text('No images found'),
//                   ),
//                 )
//               : PageView.builder(
//                   controller: _bannerController,
//                   itemCount: placeImages.length,
//                   itemBuilder: (context, i) => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         placeImages[i],
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         loadingBuilder: (context, child, progress) {
//                           if (progress == null) return child;
//                           return Container(
//                             color: Colors.grey.shade300,
//                             child: const Center(child: CircularProgressIndicator()),
//                           );
//                         },
//                         errorBuilder: (_, __, ___) =>
//                             Container(color: Colors.grey.shade300),
//                       ),
//                     ),
//                   ),
//                 ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.place, style: GoogleFonts.poppins()),
//         backgroundColor: Colors.teal,
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await _fetchAll();
//         },
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: banner,
//               ),
//               const SizedBox(height: 8),

//               // Top Places
//               _sectionTitle('Top Places to see'),
//               loadingTopPlaces
//                   ? const Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Center(child: CircularProgressIndicator()))
//                   : SizedBox(
//                       height: 160,
//                       child: topPlaces.isEmpty
//                           ? const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               child: Text('No top places found.'),
//                             )
//                           : PageView.builder(
//                               controller: PageController(viewportFraction: 0.8),
//                               itemCount: topPlaces.length,
//                               itemBuilder: (context, idx) {
//                                 final p = topPlaces[idx];
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Stack(
//                                       fit: StackFit.expand,
//                                       children: [
//                                         Image.network(
//                                           p['image']!,
//                                           fit: BoxFit.cover,
//                                           loadingBuilder: (context, child, progress) {
//                                             if (progress == null) return child;
//                                             return Container(
//                                               color: Colors.grey.shade300,
//                                             );
//                                           },
//                                           errorBuilder: (_, __, ___) =>
//                                               Container(color: Colors.grey.shade300),
//                                         ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.bottomCenter,
//                                               end: Alignment.topCenter,
//                                               colors: [
//                                                 Colors.black.withOpacity(0.6),
//                                                 Colors.transparent
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 12,
//                                           bottom: 12,
//                                           right: 12,
//                                           child: Text(
//                                             p['title'] ?? 'Place',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),

//               const SizedBox(height: 12),

//               // Weather
//               _sectionTitle('Weather forecast'),
//               loadingWeather
//                   ? const Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Center(child: CircularProgressIndicator()))
//                   : threeDayWeather.isEmpty
//                       ? const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           child: Text('Weather data not available.'),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: threeDayWeather.map((w) {
//                               final dt = DateFormat('EEE, d MMM')
//                                   .format(DateTime.parse(w['date']));
//                               final min = w['min'];
//                               final max = w['max'];
//                               final desc = _humanWeatherDescription(w['code']);
//                               return Container(
//                                 width: MediaQuery.of(context).size.width / 3.6,
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                         color: Colors.black12,
//                                         blurRadius: 6,
//                                         offset: Offset(0, 4))
//                                   ],
//                                 ),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(dt,
//                                         style: const TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600)),
//                                     const SizedBox(height: 6),
//                                     Text(desc, style: const TextStyle(fontSize: 12)),
//                                     const SizedBox(height: 6),
//                                     Text('${max.toString()}° / ${min.toString()}°',
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),

//               const SizedBox(height: 20),

//               // News
//               _sectionTitle('Latest news (last 3 days)'),
//               loadingNews
//                   ? const Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Center(child: CircularProgressIndicator()))
//                   : (NEWS_API_KEY.trim().isEmpty
//                       ? Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                               'News disabled — add a NewsAPI key to enable latest news. Put your key in search_result.dart NEWS_API_KEY constant.'),
//                         )
//                       : news.isEmpty
//                           ? const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               child: Text('No recent articles found.'),
//                             )
//                           : Column(
//                               children: news.map((a) {
//                                 final title = a['title'] ?? '';
//                                 final src = a['source'] ?? '';
//                                 final url = a['url'] ?? '';
//                                 final published = a['publishedAt'] ?? '';
//                                 final dateStr = published.isNotEmpty
//                                     ? DateFormat('d MMM, HH:mm')
//                                         .format(DateTime.parse(published).toLocal())
//                                     : '';
//                                 return ListTile(
//                                   title: Text(title),
//                                   subtitle: Text('$src • $dateStr'),
//                                   onTap: () => _openUrl(url),
//                                 );
//                               }).toList(),
//                             )),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// // lib/search_result.dart
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_fonts/google_fonts.dart';

// const String PIXABAY_API_KEY = '52387988-823b09a769b69f8eb7c59d3d7';
// const String NEWS_API_KEY = 'aefbf3c560a049518f9ba88fb5b48fc9'; // optional

// class SearchResultsPage extends StatefulWidget {
//   final String place;
//   const SearchResultsPage({super.key, required this.place});

//   @override
//   State<SearchResultsPage> createState() => _SearchResultsPageState();
// }

// class _SearchResultsPageState extends State<SearchResultsPage> {
//   List<String> placeImages = [];
//   List<Map<String, String>> topPlaces = [];
//   List<Map<String, dynamic>> threeDayWeather = [];
//   List<Map<String, dynamic>> news = [];

//   bool loadingImages = true;
//   bool loadingTopPlaces = true;
//   bool loadingWeather = true;
//   bool loadingNews = true;

//   final PageController _bannerController = PageController();
//   Timer? _bannerTimer;
//   int _bannerIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAll();
//     _startBannerAutoSwitch();
//   }

//   @override
//   void didUpdateWidget(covariant SearchResultsPage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.place != widget.place) {
//       _fetchAll();
//     }
//   }

//   @override
//   void dispose() {
//     _bannerTimer?.cancel();
//     _bannerController.dispose();
//     super.dispose();
//   }

//   void _startBannerAutoSwitch() {
//     _bannerTimer?.cancel();
//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (placeImages.isEmpty || !_bannerController.hasClients) return;
//       _bannerIndex = (_bannerIndex + 1) % placeImages.length;
//       _bannerController.animateToPage(
//         _bannerIndex,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   Future<void> _fetchAll() async {
//     final q = widget.place.trim();
//     setState(() {
//       placeImages = [];
//       topPlaces = [];
//       threeDayWeather = [];
//       news = [];
//       loadingImages = loadingTopPlaces = loadingWeather = loadingNews = true;
//     });

//     await Future.wait([
//       _fetchPlaceImages(q),
//       _fetchTopPlaces(q),
//       _fetchWeather(q),
//       _fetchNews(q),
//     ]);

//     _startBannerAutoSwitch();
//   }

//   // Fetch main place images from Pixabay
//   Future<void> _fetchPlaceImages(String q) async {
//     if (q.isEmpty) {
//       setState(() {
//         placeImages = [];
//         loadingImages = false;
//       });
//       return;
//     }
//     try {
//       final uri = Uri.parse(
//           'https://pixabay.com/api/?key=$PIXABAY_API_KEY&q=${Uri.encodeComponent(q)}&image_type=photo&per_page=6');
//       final resp = await http.get(uri);
//       if (resp.statusCode == 200) {
//         final data = json.decode(resp.body);
//         final hits = (data['hits'] as List<dynamic>?) ?? [];
//         final urls = hits.map<String>((h) => h['largeImageURL'] as String).toList();
//         if (mounted) setState(() => placeImages = urls);
//       } else {
//         if (mounted) setState(() => placeImages = []);
//       }
//     } catch (_) {
//       if (mounted) setState(() => placeImages = []);
//     } finally {
//       if (mounted) setState(() => loadingImages = false);
//     }
//   }

//   // Fetch top places images (Pixabay) for "attractions", "landmarks", etc.
//   Future<void> _fetchTopPlaces(String q) async {
//     if (q.isEmpty) {
//       setState(() {
//         topPlaces = [];
//         loadingTopPlaces = false;
//       });
//       return;
//     }
//     try {
//       final queries = [
//         '$q attractions',
//         '$q landmarks',
//         '$q sightseeing',
//       ];
//       final List<Map<String, String>> aggregated = [];

//       for (final query in queries) {
//         final uri = Uri.parse(
//             'https://pixabay.com/api/?key=$PIXABAY_API_KEY&q=${Uri.encodeComponent(query)}&image_type=photo&per_page=6');
//         final resp = await http.get(uri);
//         if (resp.statusCode == 200) {
//           final data = json.decode(resp.body);
//           final hits = (data['hits'] as List<dynamic>?) ?? [];
//           for (var h in hits) {
//             final img = h['largeImageURL'] as String?;
//             final title = (h['tags'] as String?) ?? 'Place';
//             if (img != null) aggregated.add({'image': img, 'title': title});
//           }
//         }
//         if (aggregated.length >= 6) break;
//       }

//       if (mounted) setState(() => topPlaces = aggregated.take(6).toList());
//     } catch (_) {
//       if (mounted) setState(() => topPlaces = []);
//     } finally {
//       if (mounted) setState(() => loadingTopPlaces = false);
//     }
//   }

//   // Weather and news remain unchanged
//   Future<void> _fetchWeather(String q) async {
//     // ... keep the same as your previous Open-Meteo + Nominatim code
//   }

//   Future<void> _fetchNews(String q) async {
//     // ... keep the same as your previous NewsAPI code
//   }

//   String _humanWeatherDescription(int code) {
//     if (code == 0) return 'Clear';
//     if (code == 1 || code == 2 || code == 3) return 'Partly cloudy';
//     if (code >= 45 && code <= 48) return 'Fog';
//     if (code >= 51 && code <= 67) return 'Rain';
//     if (code >= 71 && code <= 77) return 'Snow/ice';
//     if (code >= 80 && code <= 82) return 'Rain showers';
//     if (code >= 95) return 'Thunderstorm';
//     return 'Weather';
//   }

//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Text(title,
//           style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
//     );
//   }

//   Future<void> _openUrl(String url) async {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return;
//     try {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } catch (_) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     final banner = SizedBox(
//       height: 200,
//       child: loadingImages
//           ? const Center(child: CircularProgressIndicator())
//           : placeImages.isEmpty
//               ? Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text('No images found'),
//                   ),
//                 )
//               : PageView.builder(
//                   controller: _bannerController,
//                   itemCount: placeImages.length,
//                   itemBuilder: (context, i) => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         placeImages[i],
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         loadingBuilder: (context, child, progress) =>
//                             progress == null
//                                 ? child
//                                 : Container(
//                                     color: Colors.grey.shade300,
//                                     child: const Center(
//                                         child: CircularProgressIndicator())),
//                         errorBuilder: (_, __, ___) =>
//                             Container(color: Colors.grey.shade300),
//                       ),
//                     ),
//                   ),
//                 ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.place, style: GoogleFonts.poppins()),
//         backgroundColor: Colors.teal,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _fetchAll,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 12),
//               Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: banner),
//               const SizedBox(height: 8),

//               // Top Places
//               _sectionTitle('Top Places to see'),
//               loadingTopPlaces
//                   ? const Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Center(child: CircularProgressIndicator()))
//                   : SizedBox(
//                       height: 160,
//                       child: topPlaces.isEmpty
//                           ? const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               child: Text('No top places found.'),
//                             )
//                           : PageView.builder(
//                               controller: PageController(viewportFraction: 0.8),
//                               itemCount: topPlaces.length,
//                               itemBuilder: (context, idx) {
//                                 final p = topPlaces[idx];
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Stack(
//                                       fit: StackFit.expand,
//                                       children: [
//                                         Image.network(
//                                           p['image']!,
//                                           fit: BoxFit.cover,
//                                           errorBuilder: (_, __, ___) =>
//                                               Container(color: Colors.grey.shade300),
//                                         ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.bottomCenter,
//                                               end: Alignment.topCenter,
//                                               colors: [
//                                                 Colors.black.withOpacity(0.6),
//                                                 Colors.transparent
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 12,
//                                           bottom: 12,
//                                           right: 12,
//                                           child: Text(
//                                             p['title']!,
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),

//               const SizedBox(height: 12),

//               // Weather and News sections remain unchanged
//               _sectionTitle('Weather forecast'),
//               // ... keep your weather widget
//               _sectionTitle('Latest news (last 3 days)'),
//               // ... keep your news widget
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/search_result.dart
// Imports – must be at the top

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

// API Keys
const String PIXABAY_API_KEY = '52387988-823b09a769b69f8eb7c59d3d7';
const String NEWS_API_KEY = 'aefbf3c560a049518f9ba88fb5b48fc9';
const String WEATHER_API_KEY = 'edb5fc24d5c247f3b72200908252009';

class SearchResultsPage extends StatefulWidget {
  final String query;
  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<String> images = [];
  List<dynamic> news = [];
  Map<String, dynamic>? weather;
  List<dynamic> forecast = [];
  List<String> topPlacesImages = [];

  @override
  void initState() {
    super.initState();
    fetchImages(widget.query);
    fetchNews(widget.query);
    fetchWeather(widget.query);
    fetchTopPlaces(widget.query);
  }

  // Fetch Pixabay images
  Future<void> fetchImages(String query) async {
    final url = Uri.parse(
        'https://pixabay.com/api/?key=$PIXABAY_API_KEY&q=${Uri.encodeComponent(query)}&image_type=photo&per_page=10');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        images = List<String>.from(data['hits'].map((hit) => hit['webformatURL']));
      });
    }
  }

  // Fetch NewsAPI top 5
  Future<void> fetchNews(String query) async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(query)}&pageSize=5&apiKey=$NEWS_API_KEY');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        news = data['articles'];
      });
    }
  }

  // Fetch WeatherAPI
  Future<void> fetchWeather(String query) async {
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$WEATHER_API_KEY&q=${Uri.encodeComponent(query)}&days=3&aqi=no&alerts=no');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        weather = data['current'];
        forecast = data['forecast']['forecastday'];
      });
    }
  }

  // Fetch top places dynamically via Pixabay with "tourism" keyword
  Future<void> fetchTopPlaces(String query) async {
    final url = Uri.parse(
        'https://pixabay.com/api/?key=$PIXABAY_API_KEY&q=${Uri.encodeComponent('$query tourism')}&image_type=photo&per_page=5');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        topPlacesImages =
            List<String>.from(data['hits'].map((hit) => hit['webformatURL']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for "${widget.query}"')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images Carousel
            SizedBox(
              height: 200,
              child: images.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(images[index])),
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // Weather Section
            if (weather != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Weather',
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    ListTile(
                      title: Text('${widget.query}'),
                      subtitle: Text(
                          '${weather!['condition']['text']}, Temp: ${weather!['temp_c']}°C'),
                      leading: Image.network(
                        'https:${weather!['condition']['icon']}',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('3-Day Forecast',
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Column(
                      children: forecast.map((f) {
                        final date = DateTime.parse(f['date']);
                        return ListTile(
                          leading: Image.network(
                            'https:${f['day']['condition']['icon']}',
                          ),
                          title:
                              Text('${DateFormat('EEE, MMM d').format(date)}'),
                          subtitle: Text(
                              'Max: ${f['day']['maxtemp_c']}°C, Min: ${f['day']['mintemp_c']}°C'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Top Places Section
            if (topPlacesImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top Places to Visit',
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topPlacesImages.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(topPlacesImages[index])),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // News Section
            if (news.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top News',
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Column(
                      children: news.map((article) {
                        return ListTile(
                          title: Text(article['title'] ?? ''),
                          subtitle: Text(article['source']['name'] ?? ''),
                          onTap: () async {
                            final url = Uri.parse(article['url']);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
