import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/const/lists.dart';
import 'package:quickshop_seller/views/product_screen/add_product.dart';
import 'package:quickshop_seller/views/product_screen/product_details.dart';
import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () {
          Get.to(() => AddProduct());
        },
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(protected),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: List.generate(
              20,
              (index) => Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => ProductDetails());
                  },
                  leading: Image.asset(
                    imgProduct,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: boldText(text: "Product title", color: fontGrey),
                  subtitle: Row(
                    children: [
                      normalText(text: "\$40.0", color: darkGrey),
                      10.heightBox,
                      boldText(text: "Featured", color: green),
                    ],
                  ),
                  trailing: VxPopupMenu(
                    arrowSize: 0.0,
                    menuBuilder:
                        () =>
                            Column(
                              children: List.generate(
                                popupMenuTitles.length,
                                (index) => Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(popupMenuIcons[index]),
                                      10.heightBox,
                                      normalText(
                                        text: popupMenuTitles[index],
                                        color: darkGrey,
                                      ),
                                    ],
                                  ).onTap(() {}),
                                ),
                              ),
                            ).box.white.rounded.width(200).make(),
                    clickType: VxClickType.singleClick,
                    child: Icon(Icons.more_vert_rounded),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
