import 'dart:ui';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/controller/product_controller.dart';
import 'package:quickshop_seller/views/product_screen/components/product_dropdown_button.dart';
import 'package:quickshop_seller/views/product_screen/components/product_image.dart';
import 'package:quickshop_seller/views/widgets/custom_textfield.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    //OBX (=> Scaffold)
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.6),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),
        ),
        title: Text(
          "Add products",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black87,
          ),
        ),

        actions: [
          // controller.isloading.value
          //     ? lodingIndicator(circleColor: black)
          //     : TextButton(
          //       onPressed: () async {
          //         controller.isloading(true);
          //         await controller.uploadImages();
          //         await controller.uploadProduct(context);
          //         Get.back();
          //       },
          //       child: boldText(text: save, color: Colors.black87),
          //     ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextField(
                hint: "eg BMW",
                lable: "Product name",
                controller: controller.pnameController,
              ),
              10.heightBox,
              customTextField(
                hint: "eg. Nice product",
                lable: "Description",
                isDesc: true,
                controller: controller.pdescController,
              ),
              10.heightBox,
              customTextField(
                hint: "eg. \$100",
                lable: "Price",
                controller: controller.ppriceController,
              ),
              10.heightBox,
              customTextField(
                hint: "eg. 20",
                lable: "Quantity",
                controller: controller.pquantityController,
              ),
              10.heightBox,
              productDropdown(
                "Category",
                controller.categoryList,
                controller.categoryvalue,
                controller,
              ),
              10.heightBox,
              productDropdown(
                "Subcategory",
                controller.subcategoryList,
                controller.subcategoryvalue,
                controller,
              ),
              10.heightBox,
              Divider(color: Colors.black87),
              boldText(text: "Choose product images"),
              10.heightBox,
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (index) => GestureDetector(
                      onTap: () => controller.pickImage(index, context),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child:
                            controller.pImagesList[index] != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    controller.pImagesList[index],
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Image ${index + 1}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
              ),

              // Obx(
              //   () => Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: List.generate(
              //       3,
              //       (index) =>
              //           controller.pImagesList[index] != null
              //               ? Image.file(
              //                 controller.pImagesList[index],
              //                 width: 100,
              //               ).onTap(() {
              //                 controller.pickImage(index, context);
              //               })
              //               : productImages(label: "${index + 1}").onTap(() {
              //                 controller.pickImage(index, context);
              //               }),
              //     ),
              //   ),
              // ),
              5.heightBox,
              normalText(
                text: "First image will be your display image",
                color: black,
              ),
              Divider(color: black),
              10.heightBox,
              boldText(text: "Choose product colors"),
              Obx(
                () => Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    9,
                    (index) => Stack(
                      alignment: Alignment.center,
                      children: [
                        VxBox()
                            .color(Vx.randomPrimaryColor)
                            .roundedFull
                            .size(50, 50)
                            .make()
                            .onTap(() {
                              controller.selectedColorIndex.value = index;
                            }),
                        controller.selectedColorIndex.value == index
                            ? const Icon(Icons.done, color: black)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),

              //SizedBox(height: 30),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     padding: const EdgeInsets.all(8),
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         controller.isloading.value
              //             ? lodingIndicator(circleColor: black)
              //             : TextButton(
              //               onPressed: () async {
              //                 controller.isloading(true);
              //                 await controller.uploadImages();
              //                 await controller.uploadProduct(context);
              //                 Get.back();
              //               },
              //               child: boldText(
              //                 text: save,
              //                 color: Colors.black87,
              //               ),
              //             );
              //       },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: primaryColors,
              //         minimumSize: const Size(double.infinity, 50),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //       ),
              //       child: const Text(
              //         "Add to Cart",
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                controller.isloading.value
                    ? null
                    : () async {
                      controller.isloading(true);
                      await controller.uploadImages();
                      await controller.uploadProduct(context);
                      Get.back();
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColors,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child:
                controller.isloading.value
                    ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      save,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
