import 'package:flutter/material.dart';
import 'package:flux_app/features/favorites/controller/favorites_controller.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:flux_app/features/productDetails/view/product_details_view.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final FavoritesController favController = Get.put(FavoritesController());
  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Get.to(() => ProductDetailsPage(product: product));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (product.image != null && product.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        product.image!,
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  // أيقونة القلب
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => favController.isFavorite(product)
                            ? favController.removeFavorite(product)
                            : favController.addFavorite(product),
                        child: Icon(
                          favController.isFavorite(product)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("\$${product.price.toStringAsFixed(2)}"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < (product.rating?.round() ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.green,
                    size: 16,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
