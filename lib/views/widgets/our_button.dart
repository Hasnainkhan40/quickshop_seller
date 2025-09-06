import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/const/styles.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

Widget ourButton({onPress, color, textcolor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress,
    child: title!.text.color(white).fontFamily(bold).make(),
  );
}
