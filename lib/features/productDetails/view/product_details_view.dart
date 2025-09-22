import 'package:flutter/material.dart';
import 'package:flux_app/features/cart/controller/cart_controller.dart';
import 'package:flux_app/features/favorites/controller/favorites_controller.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    final FavoritesController favController = Get.put(FavoritesController());
    final p = product;
    final RxString selectedSize = ''.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة المنتج
                  SizedBox(
                    child: Stack(
                      children: [
                        if (p.image != null && p.image!.isNotEmpty)
                          Image.network(
                            p.image!,
                            width: double.infinity,
                            height: 500,
                            fit: BoxFit.cover,
                          ),
                        Positioned(
                          top: 40,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 16,
                          child: Obx(
                            () => GestureDetector(
                              onTap: () => favController.isFavorite(product)
                                  ? favController.removeFavorite(product)
                                  : favController.addFavorite(product),
                              child: CircleAvatar(
                                backgroundColor: Colors.white70,
                                child: Icon(
                                  favController.isFavorite(product)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الاسم والسعر
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                p.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "\$${p.price}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // النجوم
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < (p.rating?.round() ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.green,
                              size: 20,
                            );
                          }),
                        ),
                        SizedBox(height: 16),

                        // Color
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Color",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children:
                                      [
                                        Color(0xFFF5F5DC),
                                        Colors.black,
                                        Colors.red,
                                      ].map((c) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 8),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: c,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),

                            // Size
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Size",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Obx(
                                    () => Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: (product.size ?? []).map((
                                        size,
                                      ) {
                                        final isSelected =
                                            selectedSize.value == size;
                                        return GestureDetector(
                                          onTap: () =>
                                              selectedSize.value = size,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.grey
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              size,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),
                        // Description & Reviews
                        ExpansionTile(
                          title: Text(
                            "Description",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                product.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),

                        ExpansionTile(
                          title: Text(
                            "Reviews",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // الرقم
                                  Text(
                                    product.rating?.toStringAsFixed(1) ?? "0.0",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  // النجوم
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < (product.rating?.round() ?? 0)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.green,
                                        size: 20,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 80), // مساحة للبوتوم شيت
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom sheet add to cart
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (selectedSize.value.isEmpty) {
                  Get.snackbar(
                    "Select Size",
                    "Please select a size before adding to cart.",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return;
                }

                final productToAdd = ProductModel(
                  id: product.id,
                  name: product.name,
                  description: product.description,
                  price: product.price,
                  image: product.image,

                  size: [?product.selectedSize],
                  rating: product.rating,
                  selectedSize: selectedSize.value,
                );

                cartController.addToCart(productToAdd, selectedSize.value);

                Get.snackbar(
                  "Added to Cart",
                  "${product.name} added to cart.",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },

              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_bag, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Add To Cart",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
