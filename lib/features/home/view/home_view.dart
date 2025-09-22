import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flux_app/core/theme/app_images.dart';
import 'package:flux_app/features/cart/controller/cart_controller.dart';
import 'package:flux_app/features/featureProduct/view/all_product_view.dart';
import 'package:flux_app/features/home/view/widget/home_drawer_widget.dart';
import 'package:flux_app/features/home/view/widget/category_product_card.dart';
import 'package:flux_app/features/home/controller/category_controller.dart';
import 'package:flux_app/features/showAllPage/view/show_all_page.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

part 'widget/product_show.dart';
part 'widget/home_category.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isRefreshing = false;
  var cartController = Get.put(CartController());

  Widget buildHomeShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 175,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(height: 20, width: 150, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(height: 14, width: 120, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(height: 12, width: 60, color: Colors.white),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          Column(
            children: List.generate(3, (index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "GemStore",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
          onRefresh: () async {
            setState(() {
              _isRefreshing = true;
            });

            final CategoryController categoryController = Get.find();
            await categoryController.getCategories();
            await Future.delayed(const Duration(seconds: 1));

            if (mounted) {
              setState(() {
                _isRefreshing = false;
              });
            }
          },
          child: _isRefreshing
              ? buildHomeShimmer()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HomeCategory(),
                      _ProductShow(),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Feature Products",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => ShowAllPage());
                              },
                              child: Text(
                                "Show all",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).appBarTheme.foregroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Featured Section
                      AllProductsHorizontalView(),
                      Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "| NEW COLLECTION",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).appBarTheme.foregroundColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "HANG OUT\n & PARTY",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [Image.asset('assets/png/HangOut.png')],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "| Sale up to 40%",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).appBarTheme.foregroundColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "FOR SLIM \n & BEAUTY",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [Image.asset('assets/png/forslim.png')],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "| Summer Collection 2021",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).appBarTheme.foregroundColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Most sexy\n & fabulous\ndesign",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Image.asset('assets/png/sexyMost.png'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            // T-Shirts Card
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor, // background color
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/png/t shirt.png',
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'T-Shirts',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'The\nOffice\nLife',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 20),

                            // Dresses Card
                            Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor, // background color
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Dresses',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Text(
                                        'Elegant\nDesign',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'assets/png/dress.png',
                                    fit: BoxFit.cover,
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
        ),
      ),
    );
  }
}
