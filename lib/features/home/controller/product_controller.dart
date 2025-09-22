import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final products = <ProductModel>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var showShimmer =
      true.obs; // هذا يتحكم بوقت ظهور الشيمر فقط (بغض النظر عن البيانات)

  Future<void> getProductsByCategory(String categoryId) async {
    try {
      isLoading.value = true;
      showShimmer.value = true;
      await Future.delayed(const Duration(seconds: 2));
      final snapshot = await firestore
          .collection('categories')
          .doc(categoryId)
          .collection('products')
          .get();

      products.value = snapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
