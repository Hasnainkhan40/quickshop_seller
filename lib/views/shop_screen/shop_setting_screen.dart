import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/const/strings.dart';
import 'package:quickshop_seller/controller/profile_controller.dart';
import 'package:quickshop_seller/views/widgets/custom_textfield.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class ShopSetting extends StatelessWidget {
  const ShopSetting({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(
      () => Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.6), // translucent
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ), // iOS blur effect
              child: Container(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          title: Text(
            shopSetting,
            style: GoogleFonts.inter(
              // or sfPro if added
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: -0.2, // iOS-like tight spacing
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.black87,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          //title: boldText(text: shopSetting, size: 16.0),
          actions: [
            controller.isLoading.value
                ? lodingIndicator(circleColor: white)
                : TextButton(
                  onPressed: () async {
                    controller.isLoading(true);
                    await controller.updateShop(
                      shopaddress: controller.shopAddressController.text,
                      shopname: controller.shopNameController.text,
                      shopmobile: controller.shopMobileController.text,
                      shopwebsite: controller.shopWebsiteController.text,
                      shopdesc: controller.shopDescController.text,
                    );
                    VxToast.show(context, msg: "Shop update");
                  },
                  child: normalText(text: save),
                ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              customTextField(
                lable: shopname,
                hint: nameHint,
                controller: controller.shopNameController,
              ),
              10.heightBox,
              customTextField(
                lable: address,
                hint: shopAddressHint,
                controller: controller.shopAddressController,
              ),
              10.heightBox,
              customTextField(
                lable: mobile,
                hint: shopMobileHint,
                controller: controller.shopMobileController,
              ),
              10.heightBox,
              customTextField(
                lable: website,
                hint: shopWebsiteHint,
                controller: controller.shopWebsiteController,
              ),
              10.heightBox,
              customTextField(
                isDesc: true,
                lable: description,
                hint: shopDescHint,
                controller: controller.shopDescController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
