import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/firebase_const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/const/lists.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/controller/product_controller.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/product_screen/add_product.dart';
import 'package:quickshop_seller/views/product_screen/product_details.dart';
import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => AddProduct());
        },
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(protected),
      body: StreamBuilder(
        stream: StoreServices.getProduct(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return lodingIndicator();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ProductDetails(data: data[index]));
                        },
                        leading:
                            (data[index]['P_imgs'] != null &&
                                    data[index]['P_imgs'] is List &&
                                    (data[index]['P_imgs'] as List).isNotEmpty)
                                ? Image.network(
                                  data[index]['P_imgs'][0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey.shade300,
                                  child: Icon(Icons.image_not_supported),
                                ),
                        title: boldText(
                          text: "${data[index]['P_name']}",
                          color: fontGrey,
                        ),
                        subtitle: Row(
                          children: [
                            normalText(
                              text: "\$${data[index]['P_price']}",
                              color: darkGrey,
                            ),
                            10.heightBox,
                            boldText(
                              text:
                                  data[index]['is_featured'] == true
                                      ? "   Featured"
                                      : '',
                              color: green,
                            ),
                          ],
                        ),
                        trailing: VxPopupMenu(
                          arrowSize: 0.0,
                          menuBuilder:
                              () =>
                                  Column(
                                    children: List.generate(
                                      popupMenuTitles.length,
                                      (i) => Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              popupMenuIcons[i],
                                              color:
                                                  data[index]['featured_id'] ==
                                                              currentUser!
                                                                  .uid &&
                                                          i == 0
                                                      ? green
                                                      : darkGrey,
                                            ),
                                            10.heightBox,
                                            normalText(
                                              text:
                                                  data[index]['featured_id'] ==
                                                              currentUser!
                                                                  .uid &&
                                                          i == 0
                                                      ? "Remove featured"
                                                      : popupMenuTitles[i],
                                              color: darkGrey,
                                            ),
                                          ],
                                        ).onTap(() {
                                          switch (i) {
                                            case 0:
                                              if (data[index]['is_featured'] ==
                                                  true) {
                                                controller.removeFeatured(
                                                  data[index].id,
                                                );
                                                VxToast.show(
                                                  context,
                                                  msg: "Remove",
                                                );
                                              } else {
                                                controller.addFeatured(
                                                  data[index].id,
                                                );
                                                VxToast.show(
                                                  context,
                                                  msg: "Added",
                                                );
                                              }
                                              break;
                                            case 1:
                                              break;
                                            case 2:
                                              controller.removeProduct(
                                                data[index].id,
                                              );
                                              VxToast.show(
                                                context,
                                                msg: "Product remove",
                                              );
                                              break;
                                            default:
                                          }
                                        }),
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
            );
          }
        },
      ),
    );
  }
}
