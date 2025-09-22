import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminController extends GetxController {
  var categoryName = ''.obs;
  var imageFile = Rx<File?>(null);
  final picker = ImagePicker();
  var categoryImageFile = Rx<File?>(null);
  RxBool isLoading = false.obs;
  var productsByCategory = <ProductModel>[].obs;
  // للمنتجات
  var productName = ''.obs;
  var productDescription = ''.obs;
  var productPrice = 0.0.obs;
  var productImage = Rx<File?>(null);
  var selectedCategoryId = ''.obs;
  var productSize = <String>[].obs;
  var productRating = 0.0.obs;

  Future<void> fetchProductsByCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      productsByCategory.clear();
      return;
    }
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategoryId.value)
          .collection('products')
          .get();

      productsByCategory.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          image: data['image'] ?? '',
          size: List<String>.from(data['size'] ?? []),
          rating: (data['rating'] ?? 0).toDouble(),
        );
      }).toList();
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false; // انتهاء التحميل
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      // حذف المنتج من الـ collection 'products'
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategoryId.value)
          .collection('products')
          .doc(productId)
          .delete();
      // إعادة جلب المنتجات بعد الحذف لتحديث واجهة المستخدم
      await fetchProductsByCategory(selectedCategoryId.value);

      Get.snackbar(
        "Deleted",
        "Product deleted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete product: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // اختيار صورة
  Future<void> pickImage({bool isProduct = false}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isProduct) {
        productImage.value = File(pickedFile.path);
      } else {
        categoryImageFile.value = File(pickedFile.path);
      }
    }
  }

  Future<void> saveCategory() async {
    try {
      String? imageUrl;
      // رفع الصورة إذا موجودة
      if (imageFile.value != null) {
        final ref = FirebaseStorage.instance.ref().child(
          'categories/${DateTime.now().millisecondsSinceEpoch}',
        );
        await ref.putFile(imageFile.value!);
        imageUrl = await ref.getDownloadURL();
      }

      final docRef = FirebaseFirestore.instance.collection('categories').doc();

      await docRef.set({
        'id': docRef.id,
        'name': categoryName.value,
        'image': imageUrl ?? '',
      });

      Get.snackbar(
        'Success',
        'Category saved successfully',
        backgroundColor: Colors.green,
      );

      // إعادة تعيين الحقول
      categoryName.value = '';
      imageFile.value = null;
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  // حفظ منتج جديد
  Future<void> saveProduct() async {
    if (productName.value.trim().isEmpty ||
        productDescription.value.trim().isEmpty ||
        selectedCategoryId.value.isEmpty) {
      return;
    }

    String? imageUrl;
    if (productImage.value != null) {
      final ref = FirebaseStorage.instance.ref().child(
        'products/${DateTime.now().millisecondsSinceEpoch}',
      );
      await ref.putFile(productImage.value!);
      imageUrl = await ref.getDownloadURL();
    }

    // إنشاء ID تلقائي من Firestore
    final docRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(selectedCategoryId.value)
        .collection('products')
        .doc();

    await docRef.set({
      'id': docRef.id,
      'name': productName.value.trim(),
      'description': productDescription.value.trim(),
      'price': productPrice.value,
      'image': imageUrl ?? '',
      'size': productSize,
      'rating': productRating.value,
    });

    if (selectedCategoryId.value.isNotEmpty) {
      await fetchProductsByCategory(selectedCategoryId.value);
    }

    // تنظيف القيم
    productName.value = '';
    productDescription.value = '';
    productPrice.value = 0.0;
    productImage.value = null;
    productSize.clear();
    productRating.value = 0.0;
  }
}
