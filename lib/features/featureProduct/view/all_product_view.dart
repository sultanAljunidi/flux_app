import 'package:flutter/material.dart';
import 'package:flux_app/features/featureProduct/controller/all_prouduct_controller.dart';
import 'package:flux_app/features/productDetails/view/product_details_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AllProductsHorizontalView extends StatelessWidget {
  final AllProductController controller = Get.put(AllProductController());

  AllProductsHorizontalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allProducts.isEmpty) {
        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5, // عدد العناصر الوهمية
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(height: 16, width: 100, color: Colors.white),
                      SizedBox(height: 4),
                      Container(height: 14, width: 60, color: Colors.white),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }

      return SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.allProducts.length,
          itemBuilder: (context, index) {
            final product = controller.allProducts[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailsPage(product: product));
              },
              child: Container(
                width: 160,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.image ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image, size: 100),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "\$${product.price}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
