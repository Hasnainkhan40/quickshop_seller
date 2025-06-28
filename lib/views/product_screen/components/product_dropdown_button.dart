import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/controller/product_controller.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

Widget productDropdown(
  hint,
  List<String> list,
  dropvalue,
  ProductController controller,
) {
  return Obx(
    () =>
        DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: normalText(text: "$hint", color: fontGrey),
                value: dropvalue.value == '' ? null : dropvalue.value,
                isExpanded: true,
                items:
                    list.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: e.toString().text.make(),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  if (hint == "Category") {
                    controller.subcategoryvalue.value = '';
                    controller.populateSubcategory(newValue.toString());
                  }
                  dropvalue.value = newValue.toString();
                },
              ),
            ).box.white
            .padding(EdgeInsets.symmetric(horizontal: 4))
            .roundedSM
            .make(),
  );
}
