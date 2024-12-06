import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          categories = data['categories'] ?? [];
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 192, 136, 57),
        centerTitle: true,
        title: Text(
          'Meal Categories',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 19,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            category['strCategoryThumb'] ?? '',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['strCategory'] ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category['strCategoryDescription'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
               context,
               MaterialPageRoute(
               builder: (context) => DetailPage(category: category['strCategory'] ?? ''),
                            ),
                               );
                                  },
                                  child: Text(
                                    'Detail',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
