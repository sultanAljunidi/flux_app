import 'package:flutter/material.dart';
import 'package:flux_app/core/widgets/buttons/costom_button.dart';
import 'package:flux_app/features/setting/view/setting_page.dart';
import 'package:flux_app/features/setting/controller/setting_controller.dart';
import 'package:get/get.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدم Get.find بدل Get.put
    final SettingsController controller = Get.put(SettingsController());
    final String profileImage =
        'https://www.w3schools.com/howto/img_avatar.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Obx(() {
        if (controller.name.value.isEmpty && controller.email.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(profileImage),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.name.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.email.value,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).appBarTheme.foregroundColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Your account info is shown here.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).appBarTheme.foregroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors
                                .white // Dark Mode => أبيض
                          : Colors.black, // Light Mode => أسود
                    ),
                    onPressed: () {
                      Get.to(() => SettingsPage());
                    },
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors
                                  .black // النص أسود إذا الخلفية بيضاء
                            : Colors.white, // النص أبيض إذا الخلفية سوداء
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
