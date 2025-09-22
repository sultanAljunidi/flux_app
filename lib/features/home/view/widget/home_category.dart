part of '../home_view.dart';

class _HomeCategory extends StatelessWidget {
  const _HomeCategory();

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.put(CategoryController());

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        if (categoryController.categories.isEmpty) {
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
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 60),
                child: GestureDetector(
                  onTap: () {
                    // الانتقال لصفحة المنتجات الخاصة بالكاتيجوري
                    Get.to(
                      () => CategoryProductCard(
                        categoryId: category.id,
                        categoryName: category.name,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            (category.image != null &&
                                category.image!.isNotEmpty)
                            ? NetworkImage(category.image!)
                            : null,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: TextStyle(
                          color: Theme.of(context).appBarTheme.foregroundColor,
                          fontSize: 12,
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
