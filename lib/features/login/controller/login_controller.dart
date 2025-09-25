import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux_app/features/admin/view/admin_view.dart';
import 'package:flux_app/features/home/view/home_view.dart';
import 'package:flux_app/features/login/view/login_view.dart';
import 'package:flux_app/features/login/model/login_response_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  LoginResponseModel? userData;

  @override
  void onInit() {
    super.onInit();
    loadUserOnStart();
  }

  void showLoading() {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }
  }

  void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  Future<void> loadUserOnStart() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      final user = auth.currentUser;
      if (user != null) {
        await _loadUserData(user.uid);
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      showLoading();
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await _loadUserData(user.uid);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        hideLoading();
        if (userData?.role == "admin") {
          Get.offAll(() => AdminView());
        } else {
          Get.offAll(() => HomeView());
        }
        Get.snackbar(
          'Success',
          'Login successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      hideLoading();
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        default:
          message = 'Login failed. Please try again.';
      }
      Get.snackbar(
        'Error',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      hideLoading();
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        userData = LoginResponseModel.fromjson(
          doc.data() as Map<String, dynamic>,
        );

        update();
      } else {
        userData = null;
        update();
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

  Future<void> logout() async {
    showLoading();
    await Future.delayed(const Duration(seconds: 2));
    await auth.signOut();
    userData = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    hideLoading();
    Get.offAll(() => const LoginView());
  }

  Future<void> updateUserRole(String uid, String newRole) async {
    showLoading();
    await firestore.collection("users").doc(uid).update({"role": newRole});
    if (userData != null && userData!.uid == uid) {
      userData = LoginResponseModel(
        uid: userData!.uid,
        name: userData!.name,
        email: userData!.email,
        role: newRole,
        createdAt: userData!.createdAt,
      );
    }
    hideLoading();
    Get.snackbar(
      "Success",
      "Role updated to $newRole",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    hideLoading();
  }
}
