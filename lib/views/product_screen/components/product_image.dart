import 'package:flutter/material.dart';
import 'package:quickshop_seller/const/colors.dart';
import 'package:velocity_x/velocity_x.dart';

Widget productImages({required label, onPress}) {
  return "$label".text.bold
      .color(fontGrey)
      .size(16.0)
      .makeCentered()
      .box
      .color(lightGrey)
      .roundedSM
      .make();
}
