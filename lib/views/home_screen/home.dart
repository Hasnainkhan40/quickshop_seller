import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/controller/home_controller.dart';
import 'package:quickshop_seller/views/home_screen/home_screen.dart';
import 'package:quickshop_seller/views/orders_screen/orders_screen.dart';
import 'package:quickshop_seller/views/product_screen/product_screen.dart';
import 'package:quickshop_seller/views/profile_screen/profile_screen.dart';
import 'package:quickshop_seller/views/widgets/exitDialog.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navScreen = [
      const HomeScreen(),
      const ProductScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        body: Obx(() => navScreen[controller.navIndex.value]),
        bottomNavigationBar: Obx(
          () => Container(
            height: 65,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.90),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  controller,
                  index: 0,
                  icon: Icons.home,
                  label: "Home",
                ),
                _buildNavItem(
                  controller,
                  index: 1,
                  iconWidget: Image.asset(
                    icProducts,
                    color: Colors.white70,
                    width: 22,
                  ),
                  label: "Products",
                ),
                _buildNavItem(
                  controller,
                  index: 2,
                  iconWidget: Image.asset(
                    icOrders,
                    color: Colors.white70,
                    width: 22,
                  ),
                  label: "Orders",
                ),
                _buildNavItem(
                  controller,
                  index: 3,
                  icon: Icons.person_outline,
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    HomeController controller, {
    required int index,
    IconData? icon,
    Widget? iconWidget,
    required String label,
  }) {
    bool isSelected = controller.navIndex.value == index;

    return GestureDetector(
      onTap: () => controller.navIndex.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 0,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Color(0xFF007AFF).withOpacity(0.80)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            iconWidget ??
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white70,
                  size: 22,
                ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              // Text(
              //   label,
              //   style: const TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //     color: Colors.white,
              //   ),
              // ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
