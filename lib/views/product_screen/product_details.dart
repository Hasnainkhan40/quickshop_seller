import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/images.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: darkGrey),
        ),
        title: boldText(text: "${data['P_name']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
              autoPlay: true,
              height: 350,
              itemCount: data['P_imgs'].length,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              itemBuilder: (contex, index) {
                return Image.network(
                  data['P_imgs'][index],
                  // data['P_imgs'][index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
            10.heightBox,
            //title and detail section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                    text: "${data['P_name']}",
                    color: fontGrey,
                    size: 16.0,
                  ),
                  10.heightBox,
                  Row(
                    children: [
                      boldText(
                        text: "${data['P_category']}",
                        color: fontGrey,
                        size: 16.0,
                      ),
                      10.heightBox,
                      boldText(
                        text: "${data['P_subcategory']}",
                        color: fontGrey,
                        size: 16.0,
                      ),
                    ],
                  ),
                  10.heightBox,
                  //rating
                  VxRating(
                    isSelectable: false,
                    value: double.parse(data['P_reting']),

                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    size: 25,
                    maxRating: 5,
                  ),
                  10.heightBox,
                  boldText(text: "${data['P_price']}", color: red, size: 18.0),
                  //color section
                  20.heightBox,
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(text: "Color", color: fontGrey),
                            // child: "Color: ".text.color(textfieldGrey).make(),
                          ),
                          Row(
                            children: List.generate(
                              3,
                              (index) => VxBox()
                                  .size(40, 40)
                                  .roundedFull
                                  .color(Color(data['P_colors'][index]))
                                  .margin(
                                    const EdgeInsets.symmetric(horizontal: 4),
                                  )
                                  .make()
                                  .onTap(() {}),
                            ),
                          ),
                        ],
                      ),

                      10.heightBox,
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: normalText(
                              text: "Quantity",
                              color: fontGrey,
                            ),
                          ),
                          boldText(
                            text: "${data['P_quantity']} items",
                            color: fontGrey,
                          ),
                        ],
                      ),
                    ],
                  ).box.white.padding(EdgeInsets.all(8)).make(),
                  //description section
                  Divider(),
                  20.heightBox,
                  boldText(text: "Description", color: fontGrey),
                  10.heightBox,
                  boldText(text: "${data['P_desc']}", color: darkGrey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
