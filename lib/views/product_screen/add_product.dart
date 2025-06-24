import 'package:get/get.dart';
import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/views/product_screen/components/product_dropdown_button.dart';
import 'package:quickshop_seller/views/product_screen/components/product_image.dart';
import 'package:quickshop_seller/views/widgets/custom_textfield.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: white),
        ),
        title: boldText(text: "Add products", size: 16.0),
        actions: [
          TextButton(
            onPressed: () {},
            child: boldText(text: save, color: purpleColor),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextField(hint: "eg BMW", lable: "Product name"),
              10.heightBox,
              customTextField(
                hint: "eg. Nice product",
                lable: "Description",
                isDesc: true,
              ),
              10.heightBox,
              customTextField(hint: "eg. \$100", lable: "Price"),
              10.heightBox,
              customTextField(hint: "eg. 20", lable: "Quantity"),
              10.heightBox,
              productDropdown(),
              10.heightBox,
              productDropdown(),
              10.heightBox,
              Divider(color: white),
              boldText(text: "Choose product images"),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  3,
                  (index) => productImages(label: "${index + 1}"),
                ),
              ),
              5.heightBox,
              normalText(
                text: "First image will be your display image",
                color: lightGrey,
              ),
              Divider(color: white),
              10.heightBox,
              boldText(text: "Choose product colors"),
              Wrap(
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
                          .size(70, 70)
                          .make(),
                      const Icon(Icons.done, color: white),
                    ],
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
