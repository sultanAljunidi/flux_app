import 'product_model.dart';

class CategoryModel {
  final String id;
  final String? image;
  final String name;
  final List<ProductModel>? products; // ← أضف هذا الحقل

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
    this.products,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
