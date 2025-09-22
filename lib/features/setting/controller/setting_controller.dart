import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var name = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;

  // TextField controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // جلب بيانات المستخدم
  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      email.value = user.email ?? '';
      var doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        name.value = doc['name'] ?? '';
      }

      nameController.text = name.value;
      emailController.text = email.value;
    }
  }

  // إعادة التوثيق
  Future<void> reauthenticate(String oldPassword) async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  // تحديث البيانات
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      User? user = _auth.currentUser;
      if (user == null) return;

      // تحديث الاسم والإيميل في Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': nameController.text.trim(),
      });
      // تحديث القيم في الـ Rx
      name.value = nameController.text.trim();

      Get.back();
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
