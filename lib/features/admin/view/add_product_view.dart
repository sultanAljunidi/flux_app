import 'package:flutter/material.dart';
import 'package:flux_app/core/widgets/buttons/costom_button.dart';
import 'package:flux_app/core/widgets/textfield/custom_text_feld.dart';
import 'package:flux_app/features/admin/controller/admin_controller.dart';
import 'package:flux_app/features/home/model/product_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

class AddProductView extends StatelessWidget {
  AddProductView({super.key});

  final AdminController controller = Get.put(AdminController());
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final sizeController = TextEditingController();
  final ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Dropdown الفئات
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final categories = snapshot.data!.docs;
                    return DropdownButtonFormField<String>(
                      initialValue: controller.selectedCategoryId.value.isEmpty
                          ? null
                          : controller.selectedCategoryId.value,
                      items: categories.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(data['name'] ?? 'No Name'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.selectedCategoryId.value = val ?? '';
                        controller.fetchProductsByCategory(val ?? '');
                      },
                      decoration: const InputDecoration(
                        labelText: "Select Category",
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Select category";
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                // صورة المنتج
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.pickImage(isProduct: true),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.productImage.value != null
                          ? FileImage(controller.productImage.value!)
                          : null,
                      child: controller.productImage.value == null
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // حقول إضافة المنتج
                CustomTextField(
                  controller: nameController,
                  label: "Product Name",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Product name is required";
                    }
                    if (value.trim().length < 3) {
                      return "Name must be at least 3 characters";
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: descController,
                  label: "Description",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description is required";
                    }
                    if (value.trim().length < 10) {
                      return "Description must be at least 10 characters";
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: priceController,
                  label: "Price",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Price is required";
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return "Enter a valid positive number";
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: sizeController,
                  label: "Sizes (comma separated)",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Sizes are required";
                    }
                    final sizes = value
                        .split(",")
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList();
                    if (sizes.isEmpty) {
                      return "Enter at least one valid size";
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: ratingController,
                  label: "Rating",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Rating is required";
                    }
                    final rating = double.tryParse(value);
                    if (rating == null || rating < 0 || rating > 5) {
                      return "Rating must be between 0 and 5";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // عرض المنتجات الموجودة حسب الفئة
                Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: 4, // عدد العناصر الوهمية
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 60,
                            ),
                          );
                        },
                      ),
                    );
                  }

                  if (controller.productsByCategory.isEmpty) {
                    return const Text("No products available");
                  }

                  return SizedBox(
                    height: 160,
                    child: ListView.builder(
                      itemCount: controller.productsByCategory.length,
                      itemBuilder: (context, index) {
                        final p = controller.productsByCategory[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              p.image != null && p.image!.isNotEmpty
                                  ? Image.network(
                                      p.image!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image, size: 50),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "\$${p.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => showEditProductDialog(p),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  bool confirmed =
                                      await Get.defaultDialog<bool>(
                                        title: "Confirm Delete",
                                        middleText:
                                            "Are you sure you want to delete ${p.name}?",
                                        textCancel: "Cancel",
                                        textConfirm: "Delete",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () => Get.back(result: true),
                                        onCancel: () => Get.back(result: false),
                                      ) ??
                                      false;
                                  if (confirmed) {
                                    await controller.deleteProduct(p.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),

                // زر إضافة المنتج
                CustomButton(
                  text: 'Add Product',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      controller.productName.value = nameController.text.trim();
                      controller.productDescription.value = descController.text
                          .trim();
                      controller.productPrice.value =
                          double.tryParse(priceController.text) ?? 0.0;
                      controller.productSize.value = sizeController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList();
                      controller.productRating.value =
                          double.tryParse(ratingController.text) ?? 0.0;

                      await controller.saveProduct();

                      // تحديث المنتجات بعد الإضافة
                      await controller.fetchProductsByCategory(
                        controller.selectedCategoryId.value,
                      );

                      // تنظيف الحقول
                      nameController.clear();
                      descController.clear();
                      priceController.clear();
                      sizeController.clear();
                      ratingController.clear();

                      Get.snackbar(
                        'Success',
                        'Product added successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة تعديل المنتج
  void showEditProductDialog(ProductModel product) {
    final nameController = TextEditingController(text: product.name);
    final descController = TextEditingController(text: product.description);
    final priceController = TextEditingController(
      text: product.price.toString(),
    );
    final sizeController = TextEditingController(text: product.size?.join(','));
    final ratingController = TextEditingController(
      text: product.rating.toString(),
    );

    Get.defaultDialog(
      title: "Edit Product",
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(controller: nameController, label: "Name"),
              CustomTextField(controller: descController, label: "Description"),
              CustomTextField(
                controller: priceController,
                label: "Price",
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                controller: sizeController,
                label: "Sizes (comma separated)",
              ),
              CustomTextField(
                controller: ratingController,
                label: "Rating",
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      textCancel: "Cancel",
      textConfirm: "Save",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(controller.selectedCategoryId.value)
            .collection('products')
            .doc(product.id)
            .update({
              'name': nameController.text.trim(),
              'description': descController.text.trim(),
              'price': double.tryParse(priceController.text) ?? 0,
              'size': sizeController.text
                  .split(',')
                  .map((e) => e.trim())
                  .toList(),
              'rating': double.tryParse(ratingController.text) ?? 0,
            });
        await controller.fetchProductsByCategory(
          controller.selectedCategoryId.value,
        );
        Get.back();
        Get.snackbar(
          "Success",
          "Product updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }
}
