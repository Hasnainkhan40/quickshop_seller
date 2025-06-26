import 'package:quickshop_seller/const/const.dart';

Widget lodingIndicator({circleColor = purpleColor}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(circleColor),
  );
}
