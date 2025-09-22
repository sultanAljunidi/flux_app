import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux_app/features/login/view/login_view.dart';
import 'package:flux_app/features/login/model/login_response_model.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static SignupController instance = Get.find();
  // ---------- Loading ----------
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

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      showLoading();
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        LoginResponseModel newUser = LoginResponseModel(
          uid: user.uid,
          name: name,
          email: email,
          role: "user",
        );
        await firestore.collection("users").doc(user.uid).set({
          ...LoginResponseModel.toMap(newUser),
          "createdAt": FieldValue.serverTimestamp(),
        });
        hideLoading();
        Get.snackbar(
          'Success',
          'Account created successfully! Please login.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => const LoginView());
      }
    } catch (e) {
      hideLoading();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
