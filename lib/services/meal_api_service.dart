import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/meal.dart';

class MealApiService {
  static const _host = 'www.themealdb.com';

  Future<List<Meal>> searchMeals({String query = ''}) async {
    final uri = Uri.https(
      _host,
      '/api/json/v1/1/search.php',
      {'s': query},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to search meals (status ${response.statusCode})');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> mealsJson = data['meals'] ?? [];

    return mealsJson.map((item) => Meal.fromJson(item)).toList();
  }

  Future<MealDetail> getMealById(String id) async {
    final uri = Uri.https(
      _host,
      '/api/json/v1/1/lookup.php',
      {'i': id},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meal details (status ${response.statusCode})');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> mealsJson = data['meals'] ?? [];

    if (mealsJson.isEmpty) {
      throw Exception('Meal not found');
    }

    return MealDetail.fromJson(mealsJson.first);
  }
}
