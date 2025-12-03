import 'package:flutter/material.dart';

import '../models/custom_meal.dart';
import '../services/custom_meal_service.dart';

class CustomMealEditScreen extends StatefulWidget {
  final CustomMeal? meal;

  const CustomMealEditScreen({super.key, this.meal});

  @override
  State<CustomMealEditScreen> createState() => _CustomMealEditScreenState();
}

class _CustomMealEditScreenState extends State<CustomMealEditScreen> {
  final _service = CustomMealService();

  late final TextEditingController nameCtrl;
  late final TextEditingController categoryCtrl;
  late final TextEditingController areaCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.meal?.name);
    categoryCtrl = TextEditingController(text: widget.meal?.category);
    areaCtrl = TextEditingController(text: widget.meal?.area);
  }

  Future<void> _showLoadingDialog() async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _save() async {
    final name = nameCtrl.text.trim();
    final category = categoryCtrl.text.trim();
    final area = areaCtrl.text.trim();
    final isNew = widget.meal == null;

    if (name.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal name required')),
      );
      return;
    }

    await _showLoadingDialog();

    if (isNew) {
      await _service.createMeal(
        name: name,
        category: category,
        area: area,
      );
    } else {
      final updated = CustomMeal(
        id: widget.meal!.id,
        name: name,
        category: category,
        area: area,
      );
      await _service.updateMeal(updated);
    }

    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pop();

    Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    final meal = widget.meal;
    if (meal == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete meal?"),
        content: Text("Delete '${meal.name}'?"),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext, rootNavigator: true).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext, rootNavigator: true).pop(true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _service.deleteMeal(meal.id);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.meal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Meal' : 'Create Meal'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _delete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Meal name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: areaCtrl,
              decoration: const InputDecoration(labelText: 'Area'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text(isEditing ? 'Save changes' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
