import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/const/firebase_const.dart';
import 'package:quickshop_seller/const/lists.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/controller/product_controller.dart';
import 'package:quickshop_seller/services/store_services.dart';
import 'package:quickshop_seller/views/product_screen/add_product.dart';
import 'package:quickshop_seller/views/product_screen/product_details.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return Scaffold(
      backgroundColor: lightGrey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColors,

        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const AddProduct());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder(
        stream: StoreServices.getProduct(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return lodingIndicator();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var product = data[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetails(data: product));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              (product['P_imgs'] != null &&
                                      product['P_imgs'] is List &&
                                      (product['P_imgs'] as List).isNotEmpty)
                                  ? Image.network(
                                    product['P_imgs'][0],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 12),

                        // Name + Price + Featured
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['P_name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${product['P_price']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              if (product['is_featured'] == true)
                                const SizedBox(height: 4),
                              if (product['is_featured'] == true)
                                Text(
                                  "Featured",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: green,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Likes + Heart + Popup Menu
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            VxPopupMenu(
                              arrowSize: 0.0,
                              menuBuilder:
                                  () =>
                                      Column(
                                        children: List.generate(
                                          popupMenuTitles.length,
                                          (i) => Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  popupMenuIcons[i],
                                                  color:
                                                      product['featured_id'] ==
                                                                  currentUser!
                                                                      .uid &&
                                                              i == 0
                                                          ? green
                                                          : darkGrey,
                                                ),
                                                10.heightBox,
                                                Text(
                                                  product['featured_id'] ==
                                                              currentUser!
                                                                  .uid &&
                                                          i == 0
                                                      ? "Remove featured"
                                                      : popupMenuTitles[i],
                                                  style: TextStyle(
                                                    color: darkGrey,
                                                  ),
                                                ),
                                              ],
                                            ).onTap(() {
                                              switch (i) {
                                                case 0:
                                                  if (product['is_featured'] ==
                                                      true) {
                                                    controller.removeFeatured(
                                                      product.id,
                                                    );
                                                    VxToast.show(
                                                      context,
                                                      msg: "Removed",
                                                    );
                                                  } else {
                                                    controller.addFeatured(
                                                      product.id,
                                                    );
                                                    VxToast.show(
                                                      context,
                                                      msg: "Added",
                                                    );
                                                  }
                                                  break;
                                                case 1:
                                                  // Edit feature can be added
                                                  break;
                                                case 2:
                                                  controller.removeProduct(
                                                    product.id,
                                                  );
                                                  VxToast.show(
                                                    context,
                                                    msg: "Product removed",
                                                  );
                                                  break;
                                                default:
                                              }
                                            }),
                                          ),
                                        ),
                                      ).box.white.rounded.width(200).make(),
                              clickType: VxClickType.singleClick,
                              child: const Icon(Icons.more_vert_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quickshop_seller/const/colors.dart';
// import 'package:quickshop_seller/const/firebase_const.dart';
// import 'package:quickshop_seller/const/images.dart';
// import 'package:quickshop_seller/const/lists.dart';
// import 'package:quickshop_seller/const/loading_indicator.dart';
// import 'package:quickshop_seller/controller/product_controller.dart';
// import 'package:quickshop_seller/services/store_services.dart';
// import 'package:quickshop_seller/views/product_screen/add_product.dart';
// import 'package:quickshop_seller/views/product_screen/product_details.dart';
// import 'package:quickshop_seller/views/widgets/appbar_widget.dart';
// import 'package:quickshop_seller/views/widgets/text_style.dart';
// import 'package:velocity_x/velocity_x.dart';

// class ProductScreen extends StatelessWidget {
//   const ProductScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ProductController());
//     return Scaffold(
//       backgroundColor: lightGrey,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: purpleColor,
//         onPressed: () async {
//           await controller.getCategories();
//           controller.populateCategoryList();
//           Get.to(() => AddProduct());
//         },
//         child: const Icon(Icons.add),
//       ),
//       appBar: appbarWidget(title: "Products"),
//       body: StreamBuilder(
//         stream: StoreServices.getProduct(currentUser!.uid),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return lodingIndicator();
//           } else {
//             var data = snapshot.data!.docs;
//             return Padding(
//               padding: EdgeInsets.all(8.0),
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Column(
//                   children: List.generate(
//                     data.length,
//                     (index) => Card(
//                       child: ListTile(
//                         onTap: () {
//                           Get.to(() => ProductDetails(data: data[index]));
//                         },

//                         leading:
//                             (data[index]['P_imgs'] != null &&
//                                     data[index]['P_imgs'] is List &&
//                                     (data[index]['P_imgs'] as List).isNotEmpty)
//                                 ? Image.network(
//                                   data[index]['P_imgs'][0],
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 )
//                                 : Container(
//                                   width: 100,
//                                   height: 100,
//                                   color: Colors.grey.shade300,
//                                   child: Icon(Icons.image_not_supported),
//                                 ),
//                         title: boldText(
//                           text: "${data[index]['P_name']}",
//                           color: fontGrey,
//                         ),
//                         subtitle: Row(
//                           children: [
//                             normalText(
//                               text: "\$${data[index]['P_price']}",
//                               color: darkGrey,
//                             ),
//                             10.heightBox,
//                             boldText(
//                               text:
//                                   data[index]['is_featured'] == true
//                                       ? "   Featured"
//                                       : '',
//                               color: green,
//                             ),
//                           ],
//                         ),
//                         trailing: VxPopupMenu(
//                           arrowSize: 0.0,
//                           menuBuilder:
//                               () =>
//                                   Column(
//                                     children: List.generate(
//                                       popupMenuTitles.length,
//                                       (i) => Padding(
//                                         padding: EdgeInsets.all(12.0),
//                                         child: Row(
//                                           children: [
//                                             Icon(
//                                               popupMenuIcons[i],
//                                               color:
//                                                   data[index]['featured_id'] ==
//                                                               currentUser!
//                                                                   .uid &&
//                                                           i == 0
//                                                       ? green
//                                                       : darkGrey,
//                                             ),
//                                             10.heightBox,
//                                             normalText(
//                                               text:
//                                                   data[index]['featured_id'] ==
//                                                               currentUser!
//                                                                   .uid &&
//                                                           i == 0
//                                                       ? "Remove featured"
//                                                       : popupMenuTitles[i],
//                                               color: darkGrey,
//                                             ),
//                                           ],
//                                         ).onTap(() {
//                                           switch (i) {
//                                             case 0:
//                                               if (data[index]['is_featured'] ==
//                                                   true) {
//                                                 controller.removeFeatured(
//                                                   data[index].id,
//                                                 );
//                                                 VxToast.show(
//                                                   context,
//                                                   msg: "Remove",
//                                                 );
//                                               } else {
//                                                 controller.addFeatured(
//                                                   data[index].id,
//                                                 );
//                                                 VxToast.show(
//                                                   context,
//                                                   msg: "Added",
//                                                 );
//                                               }
//                                               break;
//                                             case 1:
//                                               break;
//                                             case 2:
//                                               controller.removeProduct(
//                                                 data[index].id,
//                                               );
//                                               VxToast.show(
//                                                 context,
//                                                 msg: "Product remove",
//                                               );
//                                               break;
//                                             default:
//                                           }
//                                         }),
//                                       ),
//                                     ),
//                                   ).box.white.rounded.width(200).make(),
//                           clickType: VxClickType.singleClick,
//                           child: Icon(Icons.more_vert_rounded),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
