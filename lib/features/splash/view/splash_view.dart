import 'package:flutter/material.dart';
import 'package:flux_app/core/theme/app_images.dart';
import 'package:flux_app/features/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(AppImages.splash, fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // يمنع الـ overflow
                  children: [
                    Spacer(),
                    Text(
                      'Welcome to GemStore!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      'The home for a fashionista',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
