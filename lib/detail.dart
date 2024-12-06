import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail_menu.dart'; 

class DetailPage extends StatefulWidget {
  final String category;

  const DetailPage({required this.category});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<dynamic> meals = [];

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          meals = data['meals'] ?? [];
        });
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      print('Error fetching meals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 192, 136, 57),
        centerTitle: true,
        title: Text(
          '${widget.category} Meals',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: meals.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailMenuPage(mealId: meal['idMeal'] ?? ''),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(8)),
                              child: Image.network(
                                meal['strMealThumb'] ?? '',
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              meal['strMeal'] ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
