part of '../home_view.dart';

class _HomeCategory extends StatefulWidget {
  const _HomeCategory();

  @override
  State<_HomeCategory> createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<_HomeCategory> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.put(CategoryController());

    // MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Obx(() {
        if (categoryController.categories.isEmpty) {
          /// 🔹 شاشة اللودينج (Shimmer)
          return SizedBox(
            height: screenHeight * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: screenWidth * 0.4,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.03,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          height: screenHeight * 0.02,
                          width: screenWidth * 0.25,
                          color: Colors.white,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Container(
                          height: screenHeight * 0.018,
                          width: screenWidth * 0.15,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return SizedBox(
          height: 100,
          child: Listener(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: categoryController.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryController.categories[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 80),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CategoryProductCard(
                            categoryId: category.id,
                            categoryName: category.name,
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                (category.image != null &&
                                    category.image!.isNotEmpty)
                                ? NetworkImage(category.image!)
                                : null,
                          ),
                          SizedBox(height: 5),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).appBarTheme.foregroundColor,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
