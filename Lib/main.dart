import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SportsNewsApp());
}

class SportsNewsApp extends StatelessWidget {
  const SportsNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sports News & Predictions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewsHomeScreen(),
    );
  }
}

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  final String apiKey = 'fda1431c2ce1419bb2d55d2ce52caea9';
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSportsNews();
  }

  Future<void> fetchSportsNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?category=sports&language=en&apiKey=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['articles'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports News & Predictions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Banner ya Tangazo la Juu
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(
              child: Text(
                'Adsterra Top Banner Ad Here',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Sehemu ya Orodha ya Habari
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: article['urlToImage'] != null
                              ? Image.network(
                                  article['urlToImage'],
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.sports),
                          title: Text(
                            article['title'] ?? 'No Title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            article['source']['name'] ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Banner ya Tangazo la Chini
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(
              child: Text(
                'Adsterra Bottom Banner Ad Here',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
