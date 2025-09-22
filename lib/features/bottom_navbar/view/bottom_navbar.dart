import 'package:flutter/material.dart';
import 'package:flux_app/features/bottom_navbar/controller/nav_controller.dart';
import 'package:get/get.dart';
import 'package:flux_app/features/cart/controller/cart_controller.dart';
import 'package:flux_app/features/favorites/controller/favorites_controller.dart';

class CustomNavBarView extends StatefulWidget {
  const CustomNavBarView({super.key});

  @override
  State<CustomNavBarView> createState() => _CustomNavBarViewState();
}

class _CustomNavBarViewState extends State<CustomNavBarView> {
  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavBarController());
    final cartController = Get.put(CartController());
    final favController = Get.put(FavoritesController());

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      return Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: navController.currentIndex.value,
          children: navController.pages,
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(32),
            color: colorScheme.surface,
            shadowColor: isDark ? Colors.black.withOpacity(0.6) : Colors.grey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  final isSelected = index == navController.currentIndex.value;

                  Widget iconData = [
                    const Icon(Icons.home_outlined, size: 30),
                    const Icon(Icons.search_outlined, size: 30),
                    Obx(() {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 30),
                          if (cartController.totalUniqueItems > 0)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  cartController.totalUniqueItems.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    const Icon(Icons.person_outline, size: 30),
                    Obx(() {
                      final favCount = favController.favoriteItems.length;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.favorite_border_outlined, size: 30),
                          if (favCount > 0)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  favCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ][index];

                  return GestureDetector(
                    onTap: () => navController.currentIndex.value = index,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 20 : 12,
                        vertical: isSelected ? 10 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: AnimatedScale(
                        scale: isSelected ? 1.25 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: iconData,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      );
    });
  }
}
