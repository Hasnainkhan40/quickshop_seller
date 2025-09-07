import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/controller/auth_controller.dart';
import 'package:quickshop_seller/views/auth_screen/forgetPass.dart';

/*Color 01: Color(0xFF2F4B4E)
Color 02: Color(0xFFBFC7C8)
Color 03: Color(0xFFA5B384)
Color 04: Color(0xFF152223)
Color 05: Color(0xFFDCDEDE)*/

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(AuthControler());
  String passwordStrength = '';
  bool isPasswordVisible = false;

  void checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        passwordStrength = '';
      } else if (password.length < 6) {
        passwordStrength = 'Weak';
      } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
        passwordStrength = 'Medium';
      } else {
        passwordStrength = 'Strong';
      }
    });
  }

  Color getStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // const Icon(
              //   Icons.shopping_bag_rounded,
              //   size: 60,
              //   color: Colors.white,
              // ),
              Center(child: Image.asset(icAppLogo, height: 100, color: white)),
              const SizedBox(height: 10),
              const Text(
                "Welcome back 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please login to continue selling",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login to Quickshop Seller",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.emailController,
                          decoration: const InputDecoration(
                            hintText: "Enter your email address",
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: !isPasswordVisible,
                          controller: controller.passwordController,
                          onChanged: checkPasswordStrength,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (passwordStrength.isNotEmpty)
                          Row(
                            children: [
                              const Text(
                                'Strength: ',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                passwordStrength,
                                style: TextStyle(
                                  color: getStrengthColor(passwordStrength),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => ForgotPasswordScreen());
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.loginMethod(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColors,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("or continue with"),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            socialIcon(FontAwesomeIcons.google, Colors.red),
                            const SizedBox(width: 7),
                            socialIcon(FontAwesomeIcons.facebookF, Colors.blue),
                            const SizedBox(width: 7),
                            socialIcon(FontAwesomeIcons.apple, Colors.black),
                          ],
                        ),
                        const SizedBox(height: 150),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Don't have an account?"),
                            SizedBox(width: 4),
                            Text(
                              "Sign up",
                              style: TextStyle(color: Color(0xFF2F4B4E)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget socialIcon(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Icon(icon, color: color, size: 24),
  );
}

//**************************************** */
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quickshop_seller/const/const.dart';
// import 'package:quickshop_seller/const/images.dart';
// import 'package:quickshop_seller/const/loading_indicator.dart';
// import 'package:quickshop_seller/controller/auth_controller.dart';
// import 'package:quickshop_seller/views/home_screen/home.dart';
// import 'package:quickshop_seller/views/widgets/our_button.dart';
// import 'package:quickshop_seller/views/widgets/text_style.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(AuthControler());
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: purpleColor,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               normalText(text: welcome, size: 18.0),
//               20.heightBox,
//               Row(
//                 children: [
//                   Image.asset(icLogo, width: 70, height: 70).box
//                       .border(color: white)
//                       .rounded
//                       .padding(EdgeInsets.all(8))
//                       .make(),
//                   10.widthBox,
//                   boldText(text: appname, size: 20.0),
//                 ],
//               ),
//               40.heightBox,
//               normalText(text: loginTo, size: 18.0, color: lightGrey),
//               10.heightBox,
//               Obx(
//                 () =>
//                     Column(
//                           children: [
//                             TextFormField(
//                               controller: controller.emailController,
//                               decoration: const InputDecoration(
//                                 fillColor: textfieldGrey,
//                                 filled: true,
//                                 prefixIcon: Icon(
//                                   Icons.email,
//                                   color: purpleColor,
//                                 ),
//                                 border: InputBorder.none,
//                                 hintText: emailHint,
//                               ),
//                             ),
//                             10.heightBox,

//                             TextFormField(
//                               obscureText: true,
//                               controller: controller.passwordController,
//                               decoration: const InputDecoration(
//                                 fillColor: textfieldGrey,
//                                 filled: true,
//                                 prefixIcon: Icon(
//                                   Icons.lock_rounded,
//                                   color: purpleColor,
//                                 ),
//                                 border: InputBorder.none,
//                                 hintText: passwordHint,
//                               ),
//                             ),
//                             10.heightBox,
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton(
//                                 onPressed: () {},
//                                 child: normalText(
//                                   text: forgotPassword,
//                                   color: purpleColor,
//                                 ),
//                               ),
//                             ),
//                             20.heightBox,
//                             SizedBox(
//                               width: context.screenWidth - 100,
//                               child:
//                                   controller.isLoding.value
//                                       ? lodingIndicator()
//                                       : ourButton(
//                                         title: login,
//                                         onPress: () async {
//                                           //Get.to(() => Home());
//                                           controller.isLoding(true);

//                                           await controller
//                                               .loginMethod(context: context)
//                                               .then((value) {
//                                                 if (value != null) {
//                                                   VxToast.show(
//                                                     context,
//                                                     msg: "Logged in",
//                                                   );
//                                                   controller.isLoding(false);
//                                                   Get.offAll(
//                                                     () => const Home(),
//                                                   );
//                                                 } else {
//                                                   controller.isLoding(false);
//                                                 }
//                                               });
//                                         },
//                                       ),
//                             ),
//                           ],
//                         ).box.white.rounded.outerShadowMd
//                         .padding(EdgeInsets.all(6))
//                         .make(),
//               ),
//               10.heightBox,
//               Center(child: normalText(text: anyProblem, color: lightGrey)),
//               const Spacer(),
//               Center(child: boldText(text: credit)),
//               20.heightBox,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
