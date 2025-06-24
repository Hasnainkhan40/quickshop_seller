import 'package:quickshop_seller/const/const.dart';
import 'package:quickshop_seller/views/widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

AppBar appbarWidget(title) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: boldText(text: dashboard, color: fontGrey, size: 16.0),
    actions: [
      Center(
        child: normalText(
          text: intl.DateFormat(
            'EEE, MMM d, '
            'yy',
          ).format(DateTime.now()),
          color: fontGrey,
          size: 16.0,
        ),
      ),
      10.heightBox,
    ],
  );
}
