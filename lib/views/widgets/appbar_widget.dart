import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

AppBar appbarWidget({title, bool arrow_back = false, bool isTime = false}) {
  return AppBar(
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
      title,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        letterSpacing: -0.2,
      ),
    ),
    leading:
        arrow_back
            ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            )
            : null,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child:
            isTime
                ? Center(
                  child: Text(
                    intl.DateFormat('EEE, MMM d').format(DateTime.now()),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )
                : null,
      ),
    ],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
  );
}
