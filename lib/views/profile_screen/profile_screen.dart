import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/views/messages_screen.dart/messages_screen.dart';
import 'package:quickshop_seller/views/profile_screen/edit_profilescreen.dart';
import 'package:quickshop_seller/views/shop_screen/shop_setting_screen.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
        title: boldText(text: settings, size: 16.0),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditProfilescreen());
            },
            icon: Icon(Icons.edit, color: lightGrey),
          ),
          TextButton(onPressed: () {}, child: normalText(text: logout)),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading:
                Image.asset(
                  imgProduct,
                ).box.roundedFull.clip(Clip.antiAlias).make(),
            title: boldText(text: "Vendor name"),
            subtitle: normalText(text: "vendor@email.com"),
          ),
          const Divider(),
          10.heightBox,
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: List.generate(
                proflileButtonTitles.length,
                (index) => ListTile(
                  onTap: () {
                    switch (index) {
                      case 0:
                        Get.to(() => ShopSetting());
                        break;
                      case 1:
                        Get.to(() => MessagesScreen());
                        break;
                      default:
                    }
                  },
                  leading: Icon(proflileButtonIcons[index], color: white),
                  title: normalText(text: proflileButtonTitles[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
