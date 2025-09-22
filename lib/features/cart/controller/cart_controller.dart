import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <ProductModel, int>{}.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  var isLoading = true.obs;
  int get totalUniqueItems => cartItems.length;
  @override
  void onInit() {
    super.onInit();
    loadCartFromFirebase();
  }

  Future<void> addToCart(ProductModel product, String selectedSize) async {
    ProductModel productWithSize = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      image: product.image,
      size: product.size,
      rating: product.rating,
      selectedSize: selectedSize,
    );
    if (cartItems.containsKey(productWithSize)) {
      cartItems[productWithSize] = cartItems[productWithSize]! + 1;
      await saveProductToFirebase(productWithSize, cartItems[productWithSize]!);
    } else {
      cartItems[productWithSize] = 1;
      await saveProductToFirebase(productWithSize, 1);
    }
  }

  Future<void> removeFromCart(ProductModel product) async {
    cartItems.remove(product);
    await _firestore
        .collection('cart')
        .doc(userId)
        .collection('items')
        .doc(_getDocId(product))
        .delete();
  }

  void increaseQuantity(ProductModel product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
      saveProductToFirebase(product, cartItems[product]!);
    }
  }

  void decreaseQuantity(ProductModel product) {
    if (cartItems.containsKey(product) && cartItems[product]! > 1) {
      cartItems[product] = cartItems[product]! - 1;
      saveProductToFirebase(product, cartItems[product]!);
    }
  }

  double get totalPrice => cartItems.entries
      .map((e) => e.key.price * e.value)
      .fold(0, (prev, amount) => prev + amount);
  Future<void> saveProductToFirebase(ProductModel product, int quantity) async {
    await _firestore
        .collection('cart')
        .doc(userId)
        .collection('items')
        .doc(_getDocId(product))
        .set({
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'image': product.image,
          'size': product.selectedSize,
          'selectedSize': product.selectedSize,
          'rating': product.rating,
          'quantity': quantity,
        });
  }

  Future<void> loadCartFromFirebase() async {
    isLoading.value = true;
    var snapshot = await _firestore
        .collection('cart')
        .doc(userId)
        .collection('items')
        .get();
    cartItems.clear();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      ProductModel product = ProductModel(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        price: (data['price'] as num).toDouble(),
        image: data['image'],
        size: data['selectedSize'] != null ? [data['selectedSize']] : [],
        rating: (data['rating'] as num?)?.toDouble(),
        selectedSize: data['selectedSize'],
      );
      cartItems[product] = data['quantity'];
    }
    cartItems.refresh();
    isLoading.value =
        false; // الآن بعد ملء البيانات isLoading.value = false; // انتهاء التحميل → اختفاء الشيمر }
  }

  String _getDocId(ProductModel product) {
    return "${product.id}_${product.selectedSize}";
  }
}
