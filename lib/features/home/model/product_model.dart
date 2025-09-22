class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? image;
  final List<String>? size; // كل الأحجام المتاحة
  final double? rating;
  final String? selectedSize; // الحجم الذي اختاره المستخدم

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.size,
    this.rating,
    this.selectedSize,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    String? selectedSize,
  }) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'],
      size: List<String>.from(json['size'] ?? []),
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      selectedSize: selectedSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'size': size,
      'selectedSize': selectedSize,
      'rating': rating,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          selectedSize == other.selectedSize;

  @override
  int get hashCode => Object.hash(id, selectedSize);
}
