import 'package:flutter/material.dart';
import 'package:flux_app/core/theme/app_images.dart';
import 'package:flux_app/core/widgets/buttons/costom_button.dart';
import 'package:flux_app/core/widgets/textfield/custom_text_feld.dart';
import 'package:flux_app/features/login/controller/login_controller.dart';
import 'package:flux_app/features/signup/view/signup_view.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

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
                    'Log into \nyour account',
                    style: TextStyle(fontSize: 28),
                  ),

                  const SizedBox(height: 50),
                  // Email Field
                  CustomTextField(
                    controller: controller.emailController,
                    label: 'Email address',
                    validator: (email) {
                      if (email?.isEmpty ?? true) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  CustomTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: (password) {
                      if (password?.isEmpty ?? true) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Log In Button
                  Center(
                    child: CustomButton(
                      text: 'Log In',
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      height: 60,
                      width: 167,
                      borderRadius: 50,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.login(
                            controller.emailController.text.trim(),
                            controller.passwordController.text.trim(),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Center(
                    child: Text(
                      'or log in with',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Social Login Buttons
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

                  const SizedBox(height: 80),

                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Get.off(() => SignupView());
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).appBarTheme.foregroundColor,
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
}
