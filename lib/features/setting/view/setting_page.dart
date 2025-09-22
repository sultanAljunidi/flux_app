import 'package:flutter/material.dart';
import 'package:flux_app/core/widgets/textfield/custom_text_feld.dart';
import 'package:flux_app/features/setting/controller/setting_controller.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController controller = Get.put(SettingsController());

  final String profileImage = 'https://www.w3schools.com/howto/img_avatar.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Obx(() {
        return Stack(
          children: [
            // ✅ محتوى الصفحة العادي
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: controller.nameController,
                      label: "Name",
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.emailController,
                      label: "Email",
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        controller.updateProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ شاشة اللودينغ تغطي الصفحة كاملة
            if (controller.isLoading.value)
              Container(
                color: Colors.black54, // خلفية شبه شفافة
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      }),
    );
  }
}
