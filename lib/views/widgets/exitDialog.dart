import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/styles.dart';
import 'package:quickshop_seller/views/widgets/our_button.dart';

Widget exitDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    backgroundColor: Colors.white,
    elevation: 8,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.exit_to_app_rounded,
              size: 40,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            "Exit App?",
            style: TextStyle(
              fontFamily: bold,
              fontSize: 20,
              color: darkFontGrey,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            "Are you sure you want to close QuickShop Seller?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: darkFontGrey.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ourButton(
                  color: Colors.grey.shade300,
                  onPress: () => Navigator.pop(context),
                  textcolor: darkFontGrey,
                  title: "No",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ourButton(
                  color: Colors.redAccent,
                  onPress: () => SystemNavigator.pop(),
                  textcolor: whiteColor,
                  title: "Yes",
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
