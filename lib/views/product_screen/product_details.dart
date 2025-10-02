import 'package:flutter/material.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarWidget(title: "${data['P_name']}", arrow_back: true),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                VxSwiper.builder(
                  autoPlay: true,
                  height: 280,
                  itemCount: data['P_imgs'].length,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  itemBuilder: (context, index) {
                    return Image.network(
                      data['P_imgs'][index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title, Price, Seller
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['P_name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${data['P_price']}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Seller: ${data['P_seller'] ?? 'Unknown'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Ratings + Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "${data['P_reting'] ?? '4.5'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Color options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Color",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: List.generate(
                      data['P_colors'].length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(data['P_colors'][index]),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tabs
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: primaryColors,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryColors,
                    tabs: [
                      Tab(text: "Description"),
                      Tab(text: "Specifications"),
                      Tab(text: "Reviews"),
                    ],
                  ),
                  SizedBox(
                    height: 180,
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            data['P_desc'] ??
                                "No description available for this product.",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const Center(child: Text("Specifications content")),
                        const Center(child: Text("Reviews content")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
