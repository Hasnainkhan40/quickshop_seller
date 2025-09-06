import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/product_screen/product_details.dart';
import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // <<-- IMPORTANT
// import other files as needed

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: appbarWidget(title: dashboard),
      body: StreamBuilder<QuerySnapshot>(
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row (top two small cards)
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          title: products,
                          value: "${data.length}",
                          change: "+10.1%",
                          isDarkCard: false, // Blue gradient
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          title: orders,
                          value: "15",
                          change: "-0.3%",
                          isDarkCard: true, // Black background
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          title: "New buyer",
                          value: "256",
                          change: "+15.0%",
                          isDarkCard: true, // Black background
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          title: "Active buyer",
                          value: "231",
                          change: "+6.08%",
                          isDarkCard: false, // Blue gradient
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Line Chart Card (Users)
                  const SizedBox(height: 18),

                  // Device traffic (bar chart)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Traffic",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              majorGridLines: const MajorGridLines(width: 0),
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                            primaryYAxis: NumericAxis(isVisible: false),
                            series: <CartesianSeries<_ChartData, String>>[
                              LineSeries<_ChartData, String>(
                                dataSource: [
                                  _ChartData('Jan', 20),
                                  _ChartData('Feb', 38),
                                  _ChartData('Mar', 30),
                                  _ChartData('Apr', 46),
                                  _ChartData('May', 28),
                                  _ChartData('Jun', 40),
                                ],
                                xValueMapper: (_ChartData d, _) => d.month,
                                yValueMapper: (_ChartData d, _) => d.value,
                                color: Colors.purple,
                                width: 3,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Popular Products (from Firestore)
                  Text(
                    "Popular Products",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (data[index]['P_wishlist'].length == 0)
                        return const SizedBox();
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap:
                              () => Get.to(
                                () => ProductDetails(data: data[index]),
                              ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              data[index]['P_imgs'][0],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            "${data[index]['P_name']}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "\$${data[index]['P_price']}",
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            "${data[index]['P_wishlist'].length} ❤️",
                            style: GoogleFonts.poppins(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String change,
    required bool isDarkCard,
    Color startColor = const Color(0xFF4A90E2), // gradient start
    Color endColor = const Color(0xFF007AFF), // gradient end
  }) {
    return Container(
      width: 160,
      height: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient:
            isDarkCard
                ? null
                : LinearGradient(
                  colors: [startColor, endColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        color: isDarkCard ? Colors.black87 : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const Icon(Icons.trending_up, size: 18, color: Colors.white70),
            ],
          ),
          const Spacer(),
          // Value
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          // Change %
          Text(
            change,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  change.startsWith('-')
                      ? Colors.redAccent
                      : Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabHeader(List<String> tabs) {
    return Row(
      children:
          tabs.map((t) {
            final bool active = t == "Users";
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                t,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? Colors.purple : Colors.grey,
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _ChartData {
  final String month;
  final double value;
  _ChartData(this.month, this.value);
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quickshop_seller/const/const.dart';
// import 'package:quickshop_seller/const/images.dart';
// import 'package:quickshop_seller/const/loading_indicator.dart';
// import 'package:quickshop_seller/services/store_services.dart';
// import 'package:quickshop_seller/views/product_screen/product_details.dart';
// import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
// import 'package:quickshop_seller/views/widgets/dasbord_button.dart';
// import 'package:quickshop_seller/views/widgets/text_style.dart';
// import 'package:velocity_x/velocity_x.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightGrey,
//       appBar: appbarWidget(dashboard),

//       body: StreamBuilder(
//         stream: StoreServices.getProduct(currentUser!.uid),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return lodingIndicator();
//           } else {
//             var data = snapshot.data!.docs;
//             data = data.sortedBy(
//               (a, b) =>
//                   b['P_wishlist'].length.compareTo(a['P_wishlist'].length),
//             );
//             return Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       dashboardButton(
//                         context,
//                         title: products,
//                         count: "${data.length}",
//                         icon: icProducts,
//                       ),
//                       dashboardButton(
//                         context,
//                         title: orders,
//                         count: "15",
//                         icon: icOrders,
//                       ),
//                     ],
//                   ),
//                   10.heightBox,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       dashboardButton(
//                         context,
//                         title: rating,
//                         count: "60",
//                         icon: icStar,
//                       ),
//                       dashboardButton(
//                         context,
//                         title: orders,
//                         count: "15",
//                         icon: icOrders,
//                       ),
//                     ],
//                   ),
//                   10.heightBox,
//                   const Divider(),
//                   10.heightBox,
//                   boldText(text: popular, color: fontGrey, size: 16.0),
//                   20.heightBox,
//                   ListView(
//                     physics: BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     children: List.generate(
//                       data.length,
//                       (index) =>
//                           data[index]['P_wishlist'].length == 0
//                               ? const SizedBox()
//                               : ListTile(
//                                     onTap: () {
//                                       Get.to(
//                                         () => ProductDetails(data: data[index]),
//                                       );
//                                     },
//                                     leading: Image.network(
//                                       data[index]['P_imgs'][0],
//                                       width: 100,
//                                       height: 100,
//                                       fit: BoxFit.cover,
//                                     ),
//                                     title: boldText(
//                                       text: "${data[index]['P_name']}",
//                                       color: fontGrey,
//                                     ),
//                                     subtitle: normalText(
//                                       text: "\$${data[index]['P_price']}",
//                                       color: darkGrey,
//                                     ),
//                                   ).box.white.roundedSM.shadowXs
//                                   .margin(
//                                     const EdgeInsets.symmetric(vertical: 4),
//                                   )
//                                   .padding(const EdgeInsets.all(8))
//                                   .make(),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
