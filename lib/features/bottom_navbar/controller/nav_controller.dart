import 'package:flux_app/features/Discover/view/search_view.dart';
import 'package:flux_app/features/cart/view/cart_page_view.dart';
import 'package:flux_app/features/favorites/view/favorites_page.dart';
import 'package:flux_app/features/home/view/home_view.dart';
import 'package:flux_app/features/myProfile/view/my_profile_page.dart';
import 'package:get/get.dart';

class NavBarController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    const HomeView(),
    SearchView(),
    const CartPage(),
    const MyProfilePage(),
    const FavoritesPage(),
  ];
}
