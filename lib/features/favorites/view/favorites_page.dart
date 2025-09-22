import 'package:flutter/material.dart';
import 'package:flux_app/features/favorites/controller/favorites_controller.dart';
import 'package:flux_app/features/productDetails/view/product_details_view.dart';
import 'package:get/get.dart';
import 'package:flux_app/features/home/model/product_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesController favoritesController = Get.put(
    FavoritesController(),
  );
  bool showShimmer = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });
  }

  Widget buildFavoritesShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Container(
                width: 100,
                height: 110,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                      Container(
                        height: 15,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                      Container(height: 15, width: 80, color: Colors.grey[300]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: showShimmer
          ? buildFavoritesShimmer()
          : Obx(() {
              if (favoritesController.favoriteItems.isEmpty) {
                return const Center(child: Text('No Favorites Product '));
              } else {
                return ListView.builder(
                  itemCount: favoritesController.favoriteItems.length,
                  itemBuilder: (context, index) {
                    ProductModel product =
                        favoritesController.favoriteItems[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailsPage(product: product));
                      },
                      child: Padding(
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${product.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                color: Colors.redAccent,
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  favoritesController.removeFavorite(product);
                                  Get.snackbar(
                                    "Removed",
                                    "${product.name} removed from favorites",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
    );
  }
}
