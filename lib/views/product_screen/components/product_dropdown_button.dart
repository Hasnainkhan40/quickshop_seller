import 'package:flutter/material.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

Widget productDropdown() {
  return DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      hint: normalText(text: "Choose category", color: fontGrey),
      value: null,
      isExpanded: true,

      items: const [],
      onChanged: (value) {},
    ),
  ).box.white.padding(EdgeInsets.symmetric(horizontal: 4)).roundedSM.make();
}
