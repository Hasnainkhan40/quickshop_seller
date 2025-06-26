import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/controller/home_controller.dart';
import 'package:quickshop_seller/views/home_screen/home_screen.dart';
import 'package:quickshop_seller/views/orders_screen/orders_screen.dart';
import 'package:quickshop_seller/views/product_screen/product_screen.dart';
import 'package:quickshop_seller/views/profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navScreen = [
      HomeScreen(),
      ProductScreen(),
      OrdersScreen(),
      ProfileScreen(),
    ];

    var bottomNavbar = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: dashboard),
      BottomNavigationBarItem(
        icon: Image.asset(icProducts, color: darkGrey, width: 24),
        label: products,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icOrders, color: darkGrey, width: 24),
        label: orders,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icGeneralSetting, color: darkGrey, width: 24),
        label: settings,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) {
            // print("Tapped index: $index");
            controller.navIndex.value = index;
          },
          backgroundColor: white,
          currentIndex: controller.navIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: purpleColor,
          unselectedItemColor: darkGrey,
          items: bottomNavbar,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreen.elementAt(controller.navIndex.value)),
          ],
        ),
      ),
    );
  }
}
