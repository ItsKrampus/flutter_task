import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/custom_meal.dart';

class CustomMealService {
  final _db = FirebaseFirestore.instance;
  final String _collection = "meals_custom";

  Stream<List<CustomMeal>> watchMeals() {
    return _db
        .collection(_collection)
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => CustomMeal.fromDoc(doc)).toList());
  }

  Future<void> createMeal({
    required String name,
    required String category,
    required String area,
  }) async {
    await _db.collection(_collection).add({
      'name': name,
      'category': category,
      'area': area,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateMeal(CustomMeal meal) async {
    await _db.collection(_collection).doc(meal.id).update(meal.toMap());
  }

  Future<void> deleteMeal(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
