import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/controller/orders_controller.dart';
import 'package:quickshop_seller/views/orders_screen/components/order_place.dart';

class OrdersDetails extends StatefulWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  State<OrdersDetails> createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  var controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 0.5),
                  ),
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Order Details",
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),

        // Confirm Order Button (Bottom CTA)
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColors,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  controller.confirmed(true);
                  controller.changeStatus(
                    title: "order_confirmed",
                    status: true,
                    docID: widget.data.id,
                  );
                },
                child: Text(
                  "Confirm Order",
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (controller.confirmed.value) _buildTimeline(),

              const SizedBox(height: 20),

              // Order Info
              _buildCard(
                child: Column(
                  children: [
                    orderPlaceDetails(
                      d1: "${widget.data['order_code']}",
                      d2: "${widget.data['shipping_method']}",
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    orderPlaceDetails(
                      d1: intl.DateFormat().add_yMd().format(
                        (widget.data['order_date'].toDate()),
                      ),
                      d2: "${widget.data['payment_method']}",
                      title1: "Order Date",
                      title2: "Payment Method",
                    ),
                    orderPlaceDetails(
                      d1: "Unpaid",
                      d2: "Order Placed",
                      title1: "Payment Status",
                      title2: "Delivery Status",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Address + Total
              _buildCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Shipping Address
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Shipping Address"),
                          const SizedBox(height: 8),
                          ...[
                            widget.data['order_by_name'],
                            widget.data['order_by_email'],
                            widget.data['order_by_address'],
                            widget.data['order_by_city'],
                            widget.data['order_by_state'],
                            widget.data['order_by_phone'],
                            widget.data['order_by_postalcode'],
                          ].map((e) => _addressLine(e)).toList(),
                        ],
                      ),
                    ),
                    // Total Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        _sectionTitle("Total Amount"),
                        const SizedBox(height: 6),
                        Text(
                          "\$${widget.data['total_amount']}",
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Ordered Products
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Ordered Products"),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.orders.length,
                      itemBuilder: (context, index) {
                        var item = controller.orders[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.shopping_bag,
                                    color: Colors.black87,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "${item['title']}  •  ${item['qty']}x",
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    "\$${item['tprice']}",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: Colors.black87,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Color(item['color']),
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Timeline (Modern Style)
  Widget _buildTimeline() {
    List<Map<String, dynamic>> steps = [
      {"title": "Placed", "done": true},
      {"title": "Confirmed", "done": controller.confirmed.value},
      {"title": "On Delivery", "done": controller.ondelivery.value},
      {"title": "Delivered", "done": controller.delivered.value},
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Order Status"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                steps.map((step) {
                  bool active = step['done'];
                  return Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? Colors.green : Colors.grey.shade300,
                          boxShadow:
                              active
                                  ? [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                  : [],
                        ),
                        child: Icon(
                          active ? Icons.check : Icons.circle_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step['title'],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper Widgets
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _addressLine(String? text) {
    return Text(
      text ?? "",
      style: GoogleFonts.inter(fontSize: 13, color: Colors.black87),
    );
  }
}






























// import 'dart:ui';

// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:quickshop_seller/const/const.dart';
// import 'package:quickshop_seller/controller/orders_controller.dart';
// import 'package:quickshop_seller/views/orders_screen/components/order_place.dart';
// import 'package:quickshop_seller/views/widgets/our_button.dart';
// import 'package:quickshop_seller/views/widgets/text_style.dart';
// import 'package:intl/intl.dart' as intl;

// class OrdersDetails extends StatefulWidget {
//   final dynamic data;
//   const OrdersDetails({super.key, this.data});

//   @override
//   State<OrdersDetails> createState() => _OrdersDetailsState();
// }

// class _OrdersDetailsState extends State<OrdersDetails> {
//   var controller = Get.find<OrdersController>();

//   @override
//   void initState() {
//     super.initState();
//     controller.getOrders(widget.data);
//     controller.confirmed.value = widget.data['order_confirmed'];
//     controller.ondelivery.value = widget.data['order_on_delivery'];
//     controller.delivered.value = widget.data['order_delivered'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         backgroundColor: lightGrey,
//         appBar: AppBar(
//           backgroundColor: Colors.white.withOpacity(0.6), // ✅ translucent
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           flexibleSpace: ClipRRect(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ iOS blur
//               child: Container(color: Colors.white.withOpacity(0.2)),
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios_new,
//               size: 20,
//               color: Colors.black87,
//             ),
//             onPressed: () => Get.back(),
//           ),
//           title: Text(
//             "Order details",
//             style: GoogleFonts.inter(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//               letterSpacing: -0.2,
//             ),
//           ),

//           // leading: IconButton(
//           //   onPressed: () {
//           //     Get.back();
//           //   },
//           //   icon: Icon(Icons.arrow_back, color: darkGrey),
//           // ),
//           // title: boldText(text: "Order details", color: fontGrey, size: 16.0),
//         ),
//         bottomNavigationBar: Visibility(
//           visible: !controller.confirmed.value,
//           child: SizedBox(
//             height: 60,
//             width: context.screenWidth,
//             child: ourButton(
//               color: primaryColors,
//               onPress: () {
//                 controller.confirmed(true);
//                 controller.changeStatus(
//                   title: "order_confirmed",
//                   status: true,
//                   docID: widget.data.id,
//                 );
//               },
//               title: "Confirm Order",
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 Visibility(
//                   visible: controller.confirmed.value,
//                   child:
//                       Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               boldText(
//                                 text: "Order status",
//                                 color: fontGrey,
//                                 size: 16.0,
//                               ),
//                               SwitchListTile(
//                                 activeColor: green,
//                                 value: true,
//                                 onChanged: (value) {},
//                                 title: boldText(
//                                   text: "Placed",
//                                   color: fontGrey,
//                                 ),
//                               ),
//                               SwitchListTile(
//                                 activeColor: green,
//                                 value: controller.confirmed.value,
//                                 onChanged: (value) {
//                                   controller.confirmed.value = value;
//                                 },
//                                 title: boldText(
//                                   text: "Confirmed",
//                                   color: fontGrey,
//                                 ),
//                               ),
//                               SwitchListTile(
//                                 activeColor: green,
//                                 value: controller.ondelivery.value,
//                                 onChanged: (value) {
//                                   controller.ondelivery.value = value;

//                                   controller.changeStatus(
//                                     title: "order_on_delivery",
//                                     status: value,
//                                     docID: widget.data.id,
//                                   );
//                                 },
//                                 title: boldText(
//                                   text: "on Delivery",
//                                   color: fontGrey,
//                                 ),
//                               ),
//                               SwitchListTile(
//                                 activeColor: green,
//                                 value: controller.delivered.value,
//                                 onChanged: (value) {
//                                   controller.delivered.value = value;
//                                   controller.changeStatus(
//                                     title: "order_delivered",
//                                     status: value,
//                                     docID: widget.data.id,
//                                   );
//                                 },
//                                 title: boldText(
//                                   text: "Delivered",
//                                   color: fontGrey,
//                                 ),
//                               ),
//                             ],
//                           ).box
//                           .padding(EdgeInsets.all(8))
//                           .outerShadow
//                           .color(lightGrey)
//                           //.border(color: lightGrey)
//                           .roundedSM
//                           .make(),
//                 ),
//                 Column(
//                   children: [
//                     orderPlaceDetails(
//                       d1: "${widget.data['order_code']}",
//                       d2: "${widget.data['shipping_method']}",
//                       title1: "Order Code",
//                       title2: "shipping Method",
//                     ),
//                     orderPlaceDetails(
//                       //d1: DateTime.now(),
//                       d1: intl.DateFormat().add_yMd().format(
//                         (widget.data['order_date'].toDate()),
//                       ),
//                       d2: "${widget.data['payment_method']}",
//                       title1: "Order Date",
//                       title2: "Payment Method",
//                     ),
//                     orderPlaceDetails(
//                       d1: "Unpaid",
//                       d2: "Order Placed",
//                       title1: "Payment Status",
//                       title2: "Delivery Status",
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0,
//                         vertical: 8,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               //"Shipping Address".text.fontFamily(semibold).make(),
//                               boldText(
//                                 text: "Shipping Address",
//                                 color: purpleColor,
//                               ),
//                               "${widget.data['order_by_name']}".text
//                                   .color(Colors.black87)
//                                   .make(),
//                               "${widget.data['order_by_email']}".text
//                                   .color(Colors.black87)
//                                   .make(),
//                               "${widget.data['order_by_address']}".text
//                                   .color(Colors.black87)
//                                   .make(),
//                               "${widget.data['order_by_city']}".text
//                                   .color(Colors.black87)
//                                   .make(),
//                               "${widget.data['order_by_state']}".text
//                                   .color(Colors.black87)
//                                   .make(),
//                               "${widget.data['order_by_phone']}".text
//                                   .color(Colors.black87)
//                                   .make(),
//                               "${widget.data['order_by_postalcode']}".text
//                                   .color(Colors.black87)
//                                   .make(),
//                             ],
//                           ),
//                           SizedBox(
//                             width: 130,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 boldText(
//                                   text: "Total Amount",
//                                   color: purpleColor,
//                                 ),
//                                 boldText(
//                                   text: "\$${widget.data['total_amount']}",
//                                   color: red,
//                                   size: 16.0,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//                 10.heightBox,

//                 boldText(text: "Orderred Product", color: fontGrey, size: 16.0),
//                 10.heightBox,
//                 ListView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   children:
//                       List.generate(controller.orders.length, (index) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             orderPlaceDetails(
//                               title1: "\$${controller.orders[index]['title']}",
//                               title2: "\$${controller.orders[index]['tprice']}",
//                               d1: "${controller.orders[index]['qty']}x",
//                               d2: "Refundable",
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: Container(
//                                 width: 30,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(
//                                     controller.orders[index]['color'],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const Divider(),
//                           ],
//                         );
//                       }).toList(),
//                 ),
//                 20.heightBox,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

