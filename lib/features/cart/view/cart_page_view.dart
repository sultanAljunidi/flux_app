import 'package:flutter/material.dart';
import 'package:flux_app/features/cart/controller/cart_controller.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.put(CartController());
  var showShimmer = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showShimmer = false;
      });
    });
  }

  Widget buildCartShimmer() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 110,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      Container(height: 14, width: 80, color: Colors.white),
                      const SizedBox(height: 10),
                      Container(height: 14, width: 100, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Obx(
                () => Text(
                  "\$${cartController.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: showShimmer
          ? buildCartShimmer()
          : Obx(() {
              if (cartController.cartItems.isEmpty) {
                return const Center(child: Text('Your Cart Is Empty '));
              } else {
                return ListView(
                  children: cartController.cartItems.entries.map((entry) {
                    ProductModel product = entry.key;
                    int quantity = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            if (product.image != null &&
                                product.image!.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Image.network(
                                  product.image!,
                                  width: 100,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "\$ ${product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Size: ${product.selectedSize} | Color.No",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      cartController.removeFromCart(product);
                                      Get.snackbar(
                                        "Removed",
                                        "${product.name} removed from cart",
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // لون الخلفية
                                      borderRadius: BorderRadius.circular(30),
                                      // البوردر ريديوس
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // زر النقصان
                                        GestureDetector(
                                          onTap: () {
                                            cartController.decreaseQuantity(
                                              product,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 20,
                                            ),
                                          ),
                                        ), // المسافة والكمية
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // زر الزيادة
                                        GestureDetector(
                                          onTap: () {
                                            cartController.increaseQuantity(
                                              product,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }),
    );
  }
}
