import 'package:quickshop_seller/const/const.dart';

Widget lodingIndicator({circleColor = primaryColors}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(circleColor),
  );
}
