import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/const/strings.dart';
import 'package:quickshop_seller/controller/orders_controller.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/orders_screen/orders_details.dart';
import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(OrdersController());
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: appbarWidget(title: orders, arrow_back: false),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid),
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
                  children: List.generate(data.length, (index) {
                    var time = data[index]['order_date'].toDate();
                    return ListTile(
                          onTap: () {
                            Get.to(() => OrdersDetails(data: data[index]));
                          },

                          textColor: textfieldGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: boldText(
                            text: "${data[index]['order_code']}",
                            color: purpleColor,
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: fontGrey,
                                  ),
                                  10.heightBox,
                                  boldText(
                                    text: intl.DateFormat().add_yMd().format(
                                      time,
                                    ),
                                    color: fontGrey,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.payment, color: fontGrey),
                                  10.heightBox,
                                  boldText(text: unpaid, color: red),
                                ],
                              ),
                            ],
                          ),
                          trailing: boldText(
                            text: "\$ ${data[index]['total_amount']}",
                            color: purpleColor,
                            size: 16.0,
                          ),
                        ).box.roundedLg
                        .color(Colors.white70)
                        .margin(EdgeInsets.all(4))
                        .make();
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
