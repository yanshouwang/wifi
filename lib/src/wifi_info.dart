import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract base class WifiInfo extends PlatformInterface {
  static final _token = Object();

  WifiInfo.impl() : super(token: _token);

  Future<String> getBSSID();
  Future<int> getFrequency();
  Future<bool> getHiddenSSID();
  Future<int> getIpAddress();
  Future<int> getLinkSpeed();
  Future<String> getMacAddress();
  Future<int> getNetworkId();
  Future<int> getRssi();
  Future<String> getSSID();
}
