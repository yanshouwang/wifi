import 'package:jni/jni.dart';

import 'android/app/_package.dart';
import 'android/content/_package.dart';
import 'android/net/wifi/_package.dart';

Activity get activity {
  final reference = Jni.getCurrentActivity();
  return Activity.fromReference(reference);
}

Context get context {
  final reference = Jni.getCachedApplicationContext();
  return Context.fromReference(reference);
}

// ignore: camel_case_extensions
extension intX on int {
  bool get wifiState {
    switch (this) {
      case WifiManager.WIFI_STATE_DISABLED:
      case WifiManager.WIFI_STATE_ENABLING:
        return false;
      case WifiManager.WIFI_STATE_ENABLED:
      case WifiManager.WIFI_STATE_DISABLING:
        return true;
      default:
        throw ArgumentError.value(this);
    }
  }
}
