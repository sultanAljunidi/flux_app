import 'package:flutter/material.dart';
import 'package:flux_app/features/favorites/controller/favorites_controller.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:flux_app/features/home/controller/product_controller.dart';
import 'package:flux_app/features/productDetails/view/product_details_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProductCard extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  final ProductController productController = Get.put(ProductController());
  final FavoritesController favController = Get.put(FavoritesController());

  CategoryProductCard({
    super.key,
    required this.categoryId,
    required this.categoryName,
  }) {
    productController.getProductsByCategory(categoryId);
  }

  Widget buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  height: 14,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                ),
                const SizedBox(height: 6),

                Container(
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 6),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: List.generate(
                      5,
                      (i) => Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: 14,
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
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
      appBar: AppBar(title: Text(categoryName)),
      body: Obx(() {
        if (productController.isLoading.value) {
          return buildShimmerGrid();
        }

        if (productController.products.isEmpty) {
          return const Center(
            child: Text(
              "No Product Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await productController.getProductsByCategory(categoryId);
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final ProductModel product = productController.products[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetailsPage(product: product));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            if (product.image != null &&
                                product.image!.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.image!,
                                  height: 200,
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
                        child: Text("\$${product.price}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
            },
          ),
        );
      }),
    );
  }
}
