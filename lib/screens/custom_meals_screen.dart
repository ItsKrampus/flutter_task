import 'package:flutter/material.dart';
import '../models/custom_meal.dart';
import '../services/custom_meal_service.dart';
import 'custom_meal_edit_screen.dart';

class CustomMealsScreen extends StatelessWidget {
  CustomMealsScreen({super.key});

  final _service = CustomMealService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Custom Meals'),
      ),
      body: StreamBuilder<List<CustomMeal>>(
        stream: _service.watchMeals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final meals = snapshot.data!;

          if (meals.isEmpty) {
            return const Center(
              child: Text(
                'No custom meals yet.\nTap + to add one!',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];

              return ListTile(
                title: Text(meal.name),
                subtitle: Text(
                  '${meal.category ?? "No category"} • ${meal.area ?? "No area"}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomMealEditScreen(meal: meal),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Changes saved!")),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomMealEditScreen(),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Meal created!")),
          );
        },
      ),
    );
  }
}
