import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flux_app/core/widgets/buttons/costom_button.dart';
import 'package:flux_app/core/widgets/textfield/custom_text_feld.dart';
import 'package:flux_app/features/admin/controller/admin_controller.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  final AdminController controller = Get.put(AdminController());
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Obx(
                () => GestureDetector(
                  onTap: controller.pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.imageFile.value != null
                        ? FileImage(controller.imageFile.value!)
                        : null,
                    child: controller.imageFile.value == null
                        ? const Icon(Icons.add_a_photo, size: 40)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Category Name',
                controller: textController,
                onChanged: (val) {
                  controller.categoryName.value = val;
                },
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter category name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Add Category',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;

                    textController.clear();
                    Future.delayed(const Duration(seconds: 1), () {
                      isLoading.value = false;
                    });
                    await controller.saveCategory();
                  }
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 350,
                child: Obx(() {
                  if (isLoading.value) {
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 14,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: 150,
                                        height: 14,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // عرض البيانات الحقيقية من Firestore
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('categories')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("No categories found"),
                          );
                        }

                        final categories = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final data =
                                categories[index].data()
                                    as Map<String, dynamic>;
                            final docId = categories[index].id;

                            return ListTile(
                              leading:
                                  data['image'] != null && data['image'] != ''
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data['image'],
                                      ),
                                    )
                                  : const CircleAvatar(
                                      child: Icon(Icons.category),
                                    ),
                              title: Text(data['name'] ?? 'No Name'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _showEditDialog(
                                      context,
                                      docId,
                                      data['name'] ?? '',
                                      data['image'] ?? '',
                                    ),
                                  ),
                                  // icon delete
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      isLoading.value = true;
                                      await FirebaseFirestore.instance
                                          .collection('categories')
                                          .doc(docId)
                                          .delete();
                                      Future.delayed(
                                        const Duration(seconds: 1),
                                        () {
                                          isLoading.value = false;
                                        },
                                      );
                                      Get.snackbar(
                                        'Deleted',
                                        'Category deleted successfully',
                                        backgroundColor: Colors.green,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة فتح Dialog لتعديل الكاتيجوري (تم نقلها لأسفل)
  void _showEditDialog(
    BuildContext context,
    String docId,
    String currentName,
    String currentImage,
  ) {
    final AdminController controller = Get.find();
    final editController = TextEditingController(text: currentName);
    final editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Category"),
          content: Form(
            key: editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: controller.pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: controller.imageFile.value != null
                          ? FileImage(controller.imageFile.value!)
                          : (currentImage != ''
                                ? NetworkImage(currentImage) as ImageProvider
                                : null),
                      child:
                          controller.imageFile.value == null &&
                              currentImage == ''
                          ? const Icon(Icons.add_a_photo, size: 30)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Category Name',
                  controller: editController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please enter category name";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            CustomButton(onTap: () => Get.back(), text: 'Cancel'),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Save',
              onTap: () async {
                if (editFormKey.currentState!.validate()) {
                  Get.back();
                  isLoading.value = true;
                  String? imageUrl = currentImage;
                  if (controller.imageFile.value != null) {
                    final ref = FirebaseStorage.instance.ref().child(
                      'categories/${DateTime.now().millisecondsSinceEpoch}',
                    );
                    await ref.putFile(controller.imageFile.value!);
                    imageUrl = await ref.getDownloadURL();
                  }

                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(docId)
                      .update({
                        'name': editController.text.trim(),
                        'image': imageUrl,
                      });

                  controller.imageFile.value = null;
                  Future.delayed(const Duration(seconds: 1), () {
                    isLoading.value = false;
                    Get.snackbar(
                      'Success',
                      'Category updated successfully',
                      backgroundColor: Colors.green,
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
