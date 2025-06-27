import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: purpleColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: white),
          ),
          title: boldText(text: shopSetting, size: 16.0),
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
          padding: EdgeInsets.all(8.0),
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
