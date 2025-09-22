import 'package:flutter/material.dart';
import 'package:flux_app/core/theme/app_images.dart';
import 'package:flux_app/core/widgets/buttons/costom_button.dart';
import 'package:flux_app/core/widgets/textfield/custom_text_feld.dart';
import 'package:flux_app/features/login/view/login_view.dart';
import 'package:flux_app/features/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    'Crate \n your account',
                    style: TextStyle(fontSize: 28),
                  ),

                  const SizedBox(height: 50),
                  CustomTextField(
                    controller: controller.nameController,
                    label: 'Enter your Name',
                    keyboardType: TextInputType.name,
                    validator: (username) {
                      if (username?.isEmpty ?? true) {
                        return 'Please enter your user name:';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: controller.emailController,
                    label: 'Email address',
                    validator: (email) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = RegExp(pattern);
                      if (email?.isEmpty ?? true) {
                        return 'Please enter your email';
                      } else if (!regex.hasMatch(email ?? '')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: (password) {
                      if (password?.isEmpty ?? true) {
                        return 'Please Enter your Password :';
                      } else if ((password?.length ?? 0) < 6) {
                        return 'Password must be at least 6 characters :';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: controller.confirmPasswordController,
                    label: 'Confirm password',
                    obscureText: true,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Please confirm your password ';
                      } else if (password !=
                          controller.passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: CustomButton(
                      text: 'Log In',
                      color: Colors.black,
                      height: 60,
                      width: 167,
                      borderRadius: 50,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          SignupController.instance.register(
                            controller.nameController.text.trim(),
                            controller.emailController.text.trim(),
                            controller.passwordController.text.trim(),
                            controller.confirmPasswordController.text.trim(),
                          );
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'or log in with',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      _buildSocialButton(AppImages.apple),
                      const SizedBox(width: 16),
                      _buildSocialButton(AppImages.google),
                      const SizedBox(width: 16),
                      _buildSocialButton(AppImages.facebook),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => LoginView());
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSocialButton(String assetPath) {
  return Container(
    width: 50,
    height: 50,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,

      border: Border.all(color: Colors.grey.shade300, width: 1.5),
    ),
    child: Image.asset(assetPath),
  );
}
