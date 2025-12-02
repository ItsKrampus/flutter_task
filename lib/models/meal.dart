class Meal {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? thumbnail;
  final String? instructions;

  Meal({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.thumbnail,
    this.instructions,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      thumbnail: json['strMealThumb'] as String?,
      instructions: json['strInstructions'] as String?,
    );
  }
}

// ---------- Detail model ----------

class IngredientMeasure {
  final String ingredient;
  final String measure;

  IngredientMeasure({required this.ingredient, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String? alternateName;
  final String? category;
  final String? area;
  final String? instructions;
  final String? thumbnail;
  final String? tags;
  final String? youtubeUrl;
  final String? source;
  final DateTime? dateModified;
  final List<IngredientMeasure> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    this.alternateName,
    this.category,
    this.area,
    this.instructions,
    this.thumbnail,
    this.tags,
    this.youtubeUrl,
    this.source,
    this.dateModified,
    this.ingredients = const [],
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <IngredientMeasure>[];

    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'] as String?;
      final meas = json['strMeasure$i'] as String?;
      if ( ing != null && ing.trim().isNotEmpty ) {
        ingredients.add(
          IngredientMeasure(
            ingredient: ing.trim(),
            measure: (meas ?? '').trim(),
          ),
        );
      }
    }

    DateTime? parsedDate;
    final dateStr = json['dateModified'] as String?;
    if (dateStr != null && dateStr.trim().isNotEmpty) {
      parsedDate = DateTime.tryParse(dateStr);
    }

    String? _clean(String? v) =>
        (v == null || v.trim().isEmpty) ? null : v.trim();

    return MealDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      alternateName: _clean(json['strMealAlternate'] as String?),
      category: _clean(json['strCategory'] as String?),
      area: _clean(json['strArea'] as String?),
      instructions: json['strInstructions'] as String?,
      thumbnail: _clean(json['strMealThumb'] as String?),
      tags: _clean(json['strTags'] as String?),
      youtubeUrl: _clean(json['strYoutube'] as String?),
      source: _clean(json['strSource'] as String?),
      dateModified: parsedDate,
      ingredients: ingredients,
    );
  }
}
