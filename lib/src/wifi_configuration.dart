import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'wifi_configuration_status.dart';
import 'wifi_plugin.dart';

abstract base class WifiConfiguration extends PlatformInterface {
  static final _token = Object();

  WifiConfiguration.impl() : super(token: _token);

  factory WifiConfiguration() => WifiPlugin.instance.newWifiConfiguration();

  Future<String> getBSSID();
  Future<String> getFQDN();
  Future<String> getSSID();
  Future<void> setSSID(String value);

  Future<bool> getHiddenSSID();
  Future<int> getNetworkId();

  Future<WifiConfigurationStatus> getStatus();
}
