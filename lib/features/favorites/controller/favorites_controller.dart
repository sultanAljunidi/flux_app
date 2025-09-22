import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  var favoriteItems = <ProductModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    loadFavoritesFromFirebase();
  }

  bool isFavorite(ProductModel product) {
    return favoriteItems.any((p) => p.id == product.id);
  }

  void addFavorite(ProductModel product) {
    if (!isFavorite(product)) {
      _firestore
          .collection('favorites')
          .doc(userId)
          .collection('items')
          .doc(product.id)
          .set({
            'id': product.id,
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'image': product.image,
            'size': product.size,
            'rating': product.rating,
          });
    }
  }

  void removeFavorite(ProductModel product) {
    _firestore
        .collection('favorites')
        .doc(userId)
        .collection('items')
        .doc(product.id)
        .delete();
  }

  // تحميل المفضلات من Firebase بشكل مباشر مع أي تحديث (Realtime)
  void loadFavoritesFromFirebase() {
    _firestore
        .collection('favorites')
        .doc(userId)
        .collection('items')
        .snapshots()
        .listen((snapshot) {
          favoriteItems.value = snapshot.docs.map((doc) {
            var data = doc.data();
            return ProductModel(
              id: data['id'],
              name: data['name'],
              description: data['description'],
              price: (data['price'] as num).toDouble(),
              image: data['image'],
              size: (data['size'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList(),
              rating: (data['rating'] as num?)?.toDouble(),
            );
          }).toList();
        });
  }
}
