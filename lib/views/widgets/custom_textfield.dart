import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';

Widget customTextField({lable, hint, controller, isDesc = false}) {
  return TextFormField(
    style: TextStyle(color: white),
    controller: controller,
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
      isDense: true,
      label: normalText(text: lable),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: lightGrey),
    ),
  );
}
