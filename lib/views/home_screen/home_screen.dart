import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/product_screen/product_details.dart';
import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
import 'package:quickshop_seller/views/widgets/dasbord_button.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProduct(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return lodingIndicator();
          } else {
            var data = snapshot.data!.docs;
            data = data.sortedBy(
              (a, b) =>
                  b['P_wishlist'].length.compareTo(a['P_wishlist'].length),
            );
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashboardButton(
                        context,
                        title: products,
                        count: "${data.length}",
                        icon: icProducts,
                      ),
                      dashboardButton(
                        context,
                        title: orders,
                        count: "15",
                        icon: icOrders,
                      ),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dashboardButton(
                        context,
                        title: rating,
                        count: "60",
                        icon: icStar,
                      ),
                      dashboardButton(
                        context,
                        title: orders,
                        count: "15",
                        icon: icOrders,
                      ),
                    ],
                  ),
                  10.heightBox,
                  const Divider(),
                  10.heightBox,
                  boldText(text: popular, color: fontGrey, size: 16.0),
                  20.heightBox,
                  ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      data.length,
                      (index) =>
                          data[index]['P_wishlist'].length == 0
                              ? const SizedBox()
                              : ListTile(
                                onTap: () {
                                  Get.to(
                                    () => ProductDetails(data: data[index]),
                                  );
                                },
                                leading: Image.network(
                                  data[index]['P_imgs'][0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                title: boldText(
                                  text: "${data[index]['P_name'][0]}",
                                  color: fontGrey,
                                ),
                                subtitle: normalText(
                                  text: "\$${data[index]['P_price'][0]}",
                                  color: darkGrey,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
