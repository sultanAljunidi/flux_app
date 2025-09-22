import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../controller/show_all_controller.dart';
import 'product_card.dart';

class ShowAllPage extends StatelessWidget {
  ShowAllPage({super.key});

  final ShowAllController controller = Get.put(ShowAllController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !controller.isLoadingMore.value) {
        controller.fetchMoreProducts();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('All Products'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Obx(() {
              return DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Icon(Icons.category, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Select Category',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  items: controller.categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.label_important,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  value: controller.selectedCategory.value,
                  onChanged: (value) {
                    if (value != null) controller.selectCategory(value);
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueAccent),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                    iconSize: 26,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),

            // قائمة المنتجات مع Pagination
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.products.isEmpty) {
                  return const Center(child: Text("No products found."));
                }

                return GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                      controller.products.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.products.length) {
                      return ProductCard(product: controller.products[index]);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
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
