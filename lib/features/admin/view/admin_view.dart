import 'package:flutter/material.dart';
import 'package:flux_app/features/admin/view/add_categories.dart';
import 'package:flux_app/features/admin/view/users_management_view.dart';
import 'package:get/get.dart';
import 'package:flux_app/features/admin/view/add_product_view.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: "Manage Users",
            onPressed: () {
              Get.to(() => const UsersManagementView());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // زر إضافة منتج
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.to(() => AddProductView());
                },
                child: const Text(
                  "Add Product",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 16), // مسافة بين الزرين
            // زر إضافة تصنيف
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.to(() => const AddCategories());
                },
                child: const Text(
                  "Add Category",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
