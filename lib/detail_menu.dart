import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailMenuPage extends StatefulWidget {
  final String mealId;

  const DetailMenuPage({required this.mealId});

  @override
  _DetailMenuPageState createState() => _DetailMenuPageState();
}

class _DetailMenuPageState extends State<DetailMenuPage> {
  Map<String, dynamic>? mealDetails;

  @override
  void initState() {
    super.initState();
    _fetchMealDetails();
  }

  Future<void> _fetchMealDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          mealDetails = data['meals']?[0];
        });
      } else {
        throw Exception('Failed to load meal details');
      }
    } catch (e) {
      print('Error fetching meal details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 192, 136, 57),
        centerTitle: true,
        title: Text(
          'Meal Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: mealDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      mealDetails!['strMealThumb'] ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    mealDetails!['strMeal'] ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: ${mealDetails!['strCategory'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Area: ${mealDetails!['strArea'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    mealDetails!['strInstructions'] ?? 'No instructions available.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ..._buildIngredientList(),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildIngredientList() {
    List<Widget> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = mealDetails?['strIngredient$i'];
      final measure = mealDetails?['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '$ingredient - $measure',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }
    return ingredients;
  }
}
