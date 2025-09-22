import 'package:flutter/material.dart';
import 'package:flux_app/features/Discover/view/search_view.dart';
import 'package:flux_app/features/cart/view/cart_page_view.dart';
import 'package:flux_app/features/home/view/home_view.dart';
import 'package:flux_app/features/login/controller/login_controller.dart';
import 'package:flux_app/features/myProfile/view/my_profile_page.dart';
import 'package:flux_app/features/setting/view/setting_page.dart';
import 'package:get/get.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.isDarkMode;
    final String profileImage =
        'https://www.w3schools.com/howto/img_avatar.png';

    Get.put(LoginController());
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(profileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  GetBuilder<LoginController>(
                    builder: (loginController) {
                      final name = loginController.userData?.name ?? "No Name";
                      final email =
                          loginController.userData?.email ?? "No Email";
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Main menu
            _drawerItem(Icons.home, 'Homepage', false, () {
              Get.to(() => HomeView());
            }),
            _drawerItem(Icons.search, 'Discover', false, () {
              Get.to(() => SearchView());
            }),
            _drawerItem(Icons.shopping_bag_outlined, 'My Order', false, () {
              Get.to(() => CartPage());
            }),
            _drawerItem(Icons.person_outline, 'My profile', false, () {
              Get.to(() => MyProfilePage());
            }),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OTHER",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _drawerItem(Icons.settings_outlined, 'Setting', false, () {
              Get.to(() => SettingsPage());
            }),
            _drawerItem(Icons.email_outlined, 'Support', false, () {}),
            _drawerItem(Icons.info_outline, 'About us', false, () {}),
            _drawerItem(Icons.logout_outlined, 'LogOut', false, () {
              Get.put(LoginController()).logout();
            }),

            const Spacer(),
            // Theme toggle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.changeThemeMode(ThemeMode.light);
                    },
                    child: _themeButton(
                      Icons.wb_sunny_outlined,
                      'Light',
                      !isDarkMode,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.changeThemeMode(ThemeMode.dark);
                    },
                    child: _themeButton(
                      Icons.nightlight_round,
                      'Dark',
                      isDarkMode,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _drawerItem(
    IconData icon,
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Material(
            color: selected
                ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Icon(icon, color: theme.iconTheme.color),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _themeButton(IconData icon, String title, bool selected) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: theme.iconTheme.color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
            ],
          ),
        );
      },
    );
  }
}
