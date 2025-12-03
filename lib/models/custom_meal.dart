import 'package:cloud_firestore/cloud_firestore.dart';

class CustomMeal {
  final String id;
  final String name;
  final String? category;
  final String? area;

  CustomMeal({
    required this.id,
    required this.name,
    this.category,
    this.area,
  });

  factory CustomMeal.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CustomMeal(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'],
      area: data['area'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'area': area,
    };
  }
}
