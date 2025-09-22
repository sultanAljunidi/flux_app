import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flux_app/features/home/model/categore_model.dart';
import 'package:flux_app/features/home/model/product_model.dart';

class ShowAllController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // قائمة الكاتيجوريز
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  // قائمة المنتجات
  final RxList<ProductModel> products = <ProductModel>[].obs;

  // حالات التحميل
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  // البحث
  final RxString searchQuery = ''.obs;

  // دعم الباجنيشن
  DocumentSnapshot? lastDocument;
  static const int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// جلب الكاتيجوريز
  Future<void> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      categories.assignAll(
        snapshot.docs.map((d) {
          final data = d.data();
          data['id'] = d.id;
          return CategoryModel.fromMap(data);
        }),
      );

      if (categories.isNotEmpty) selectCategory(categories.first);
    } catch (e) {
      print("Error fetching categories: $e");
      categories.clear();
    }
  }

  /// اختيار كاتيجوري جديد
  void selectCategory(CategoryModel category) {
    selectedCategory.value = category;
    products.clear();
    lastDocument = null;
    fetchProducts();
  }

  /// تحديث البحث
  void searchProducts(String query) {
    searchQuery.value = query.trim();
    products.clear();
    lastDocument = null;
    fetchProducts();
  }

  /// جلب المنتجات مع دعم البحث والباجنيشن
  Future<void> fetchProducts() async {
    if (selectedCategory.value == null) return;

    try {
      isLoading.value = true;

      Query query = _firestore
          .collection('categories')
          .doc(selectedCategory.value!.id)
          .collection('products')
          .limit(limit);

      if (searchQuery.value.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: searchQuery.value)
            .where('name', isLessThanOrEqualTo: searchQuery.value + '\uf8ff');
      }

      final querySnapshot = await query.get();

      final fetchedProducts = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // تحويل صريح
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();

      products.assignAll(fetchedProducts);

      if (querySnapshot.docs.isNotEmpty) lastDocument = querySnapshot.docs.last;
    } catch (e) {
      print("Error fetching products: $e");
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// تحميل المزيد عند التمرير
  Future<void> fetchMoreProducts() async {
    if (selectedCategory.value == null || lastDocument == null) return;

    try {
      isLoadingMore.value = true;

      Query query = _firestore
          .collection('categories')
          .doc(selectedCategory.value!.id)
          .collection('products')
          .startAfterDocument(lastDocument!)
          .limit(limit);

      if (searchQuery.value.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: searchQuery.value)
            .where('name', isLessThanOrEqualTo: '${searchQuery.value}\uf8ff');
      }

      final querySnapshot = await query.get();

      final fetchedProducts = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();

      products.addAll(fetchedProducts);

      if (querySnapshot.docs.isNotEmpty) lastDocument = querySnapshot.docs.last;
    } catch (e) {
      print("Error fetching more products: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}
