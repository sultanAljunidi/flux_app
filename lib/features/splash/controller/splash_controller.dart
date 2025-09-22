import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux_app/features/admin/view/admin_view.dart';
import 'package:flux_app/features/bottom_navbar/view/bottom_navbar.dart';
import 'package:flux_app/features/login/model/login_response_model.dart';
import 'package:flux_app/features/login/view/login_view.dart';
import 'package:flux_app/features/splash/view/splash_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Get.offAll(() => const SplashScreen());
    _checkUserOnce();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<LoginResponseModel> userData = Rxn<LoginResponseModel>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _initialCheckDone = false;

  void _checkUserOnce() async {
    if (_initialCheckDone) return;
    _initialCheckDone = true;

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (isLoggedIn) {
      User? user = auth.currentUser;
      if (user != null) {
        await _loadUserData(user.uid);

        if (userData.value?.role == "admin") {
          Get.offAll(() => AdminView());
        } else {
          Get.offAll(() => CustomNavBarView());
        }
      } else {
        prefs.setBool('isLoggedIn', false);
        Get.offAll(() => const LoginView());
      }
    } else {
      Get.offAll(() => const LoginView());
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        userData.value = LoginResponseModel.fromMap(
          doc.data() as Map<String, dynamic>,
        );
      } else {
        userData.value = null;
      }
    } catch (e) {
      Get.snackbar(
        'Firestore Error',
        'Cannot load user data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
