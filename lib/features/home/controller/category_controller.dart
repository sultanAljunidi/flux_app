import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_app/features/home/model/categore_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      final snapshot = await firestore.collection('categories').get();
      categories.value = snapshot.docs
          .map((e) => CategoryModel.fromMap(e.data()))
          .toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
