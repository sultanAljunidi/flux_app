import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';

class AllProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var allProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProductsFromCategories();
  }

  void fetchAllProductsFromCategories() async {
    try {
      List<ProductModel> products = [];

      // جلب كل الكاتيجوريز
      QuerySnapshot categorySnapshot = await _firestore
          .collection('categories')
          .get();

      // لكل كاتيجوري، جلب الـ products من الـ subcollection
      for (var categoryDoc in categorySnapshot.docs) {
        QuerySnapshot prodSnapshot = await _firestore
            .collection('categories')
            .doc(categoryDoc.id)
            .collection('products')
            .get();

        products.addAll(
          prodSnapshot.docs
              .map(
                (doc) =>
                    ProductModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
      }

      allProducts.value = products; // تحديث الـ observable
      print("Fetched ${products.length} products");
    } catch (e) {
      print("Error fetching products from categories: $e");
    }
  }
}
