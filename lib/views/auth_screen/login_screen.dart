import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/const/loading_indicator.dart';
import 'package:quickshop_seller/controller/auth_controller.dart';
import 'package:quickshop_seller/views/home_screen/home.dart';
import 'package:quickshop_seller/views/widgets/our_button.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthControler());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              normalText(text: welcome, size: 18.0),
              20.heightBox,
              Row(
                children: [
                  Image.asset(icLogo, width: 70, height: 70).box
                      .border(color: white)
                      .rounded
                      .padding(EdgeInsets.all(8))
                      .make(),
                  10.widthBox,
                  boldText(text: appname, size: 20.0),
                ],
              ),
              40.heightBox,
              normalText(text: loginTo, size: 18.0, color: lightGrey),
              10.heightBox,
              Obx(
                () =>
                    Column(
                          children: [
                            TextFormField(
                              controller: controller.emailController,
                              decoration: const InputDecoration(
                                fillColor: textfieldGrey,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: purpleColor,
                                ),
                                border: InputBorder.none,
                                hintText: emailHint,
                              ),
                            ),
                            10.heightBox,

                            TextFormField(
                              obscureText: true,
                              controller: controller.passwordController,
                              decoration: const InputDecoration(
                                fillColor: textfieldGrey,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock_rounded,
                                  color: purpleColor,
                                ),
                                border: InputBorder.none,
                                hintText: passwordHint,
                              ),
                            ),
                            10.heightBox,
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: normalText(
                                  text: forgotPassword,
                                  color: purpleColor,
                                ),
                              ),
                            ),
                            20.heightBox,
                            SizedBox(
                              width: context.screenWidth - 100,
                              child:
                                  controller.isLoding.value
                                      ? lodingIndicator()
                                      : ourButton(
                                        title: login,
                                        onPress: () async {
                                          //Get.to(() => Home());
                                          controller.isLoding(true);

                                          await controller
                                              .loginMethod(context: context)
                                              .then((value) {
                                                if (value != null) {
                                                  VxToast.show(
                                                    context,
                                                    msg: "Logged in",
                                                  );
                                                  controller.isLoding(false);
                                                  Get.offAll(
                                                    () => const Home(),
                                                  );
                                                } else {
                                                  controller.isLoding(false);
                                                }
                                              });
                                        },
                                      ),
                            ),
                          ],
                        ).box.white.rounded.outerShadowMd
                        .padding(EdgeInsets.all(6))
                        .make(),
              ),
              10.heightBox,
              Center(child: normalText(text: anyProblem, color: lightGrey)),
              const Spacer(),
              Center(child: boldText(text: credit)),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
