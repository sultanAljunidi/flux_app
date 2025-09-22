import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_app/features/home/model/product_model.dart';

class DiscoverController extends GetxController {
  var searchResults = <ProductModel>[].obs;
  var isSearching = false.obs;
  var hasSearched = false.obs;
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    isSearching.value = true;
    hasSearched.value = true;

    await Future.delayed(const Duration(seconds: 2));

    List<ProductModel> allProducts = [];

    // جلب كل الكاتيجوري
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .get();

    for (var categoryDoc in categoriesSnapshot.docs) {
      final productsSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryDoc.id)
          .collection('products')
          .get();

      for (var doc in productsSnapshot.docs) {
        final data = doc.data();
        final product = ProductModel(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          image: data['image'] ?? '',
          size: List<String>.from(data['size'] ?? []),
          rating: (data['rating'] ?? 0).toDouble(),
        );

        // فلترة حسب الاسم
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          allProducts.add(product);
        }
      }
    }

    searchResults.value = allProducts;
    isSearching.value = false; // 🔹 بعد الانتهاء من كل الجلب والفلاتر
  }
}
