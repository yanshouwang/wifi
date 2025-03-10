import 'package:wifi/wifi.dart';

class WifiConfigurationModel {
  final int networkId;
  final String ssid;
  final WifiConfigurationStatus status;

  WifiConfigurationModel({
    required this.networkId,
    required this.ssid,
    required this.status,
  });
}
