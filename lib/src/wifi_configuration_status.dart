import 'jni.dart' as jni;

enum WiFiConfigurationStatus {
  current(jni.WifiConfiguration_Status.CURRENT),
  disabled(jni.WifiConfiguration_Status.DISABLED),
  enabled(jni.WifiConfiguration_Status.ENABLED);

  final int value;

  const WiFiConfigurationStatus(this.value);
}
