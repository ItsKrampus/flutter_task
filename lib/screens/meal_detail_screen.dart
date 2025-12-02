import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal.dart';
import '../services/meal_api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService _api = MealApiService();
  late Future<MealDetail> _futureMeal;

  @override
  void initState() {
    super.initState();
    _futureMeal = _api.getMealById(widget.mealId);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Details"),
      ),
      body: FutureBuilder<MealDetail>(
        future: _futureMeal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final meal = snapshot.data;
          if (meal == null) {
            return const Center(child: Text("Meal not found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meal.thumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      meal.thumbnail!,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 16),

                Text(
                  meal.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                Text(
                  "${meal.category ?? 'Unknown Category'} • ${meal.area ?? 'Unknown Area'}",
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 16),

                if (meal.tags != null)
                  Wrap(
                    spacing: 8,
                    children: meal.tags!
                        .split(',')
                        .map(
                          (tag) => Chip(
                            label: Text(tag.trim()),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 24),

                Text(
                  "Ingredients",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                ...meal.ingredients.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.ingredient),
                        Text(item.measure),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "Instructions",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(meal.instructions ?? "No instructions available."),

                const SizedBox(height: 24),

                if (meal.source != null)
                  GestureDetector(
                    onTap: () => _openUrl(meal.source!),
                    child: Text(
                      "Source Recipe",
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                if (meal.youtubeUrl != null)
                  GestureDetector(
                    onTap: () => _openUrl(meal.youtubeUrl!),
                    child: Text(
                      "Watch on YouTube",
                      style: TextStyle(
                        color: Colors.red.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                if (meal.dateModified != null)
                  Text(
                    "Last modified: ${meal.dateModified}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
