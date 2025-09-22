import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsController extends GetxController {
  final String productId;
  ProductDetailsController(this.productId);

  var product = Rx<ProductModel?>(null);
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
  }

  void fetchProduct() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (doc.exists) {
        product.value = ProductModel.fromJson(doc.data()!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
