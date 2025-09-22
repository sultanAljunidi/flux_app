import 'package:flutter/material.dart';
import 'package:flux_app/features/Discover/controller/discover_controller.dart';
import 'package:flux_app/features/home/view/widget/home_drawer_widget.dart';
import 'package:flux_app/features/productDetails/view/product_details_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final DiscoverController controller = DiscoverController();
  final TextEditingController searchController = TextEditingController();

  Widget buildSearchShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
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
        title: const Text("Discover"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 9,
                top: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: HomeDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => controller.searchProducts(value),
            ),
            const SizedBox(height: 16),

            // عرض النتائج
            Expanded(
              child: Obx(() {
                if (controller.isSearching.value) {
                  return buildSearchShimmer();
                }

                // بعد ما يخلص البحث
                if (controller.hasSearched.value &&
                    controller.searchResults.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final product = controller.searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailsPage(product: product));
                      },
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
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
