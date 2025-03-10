import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dhcp_info.dart';
import 'wifi_configuration.dart';
import 'wifi_info.dart';
import 'wifi_plugin.dart';
import 'wifi_state.dart';

abstract base class WifiManager extends PlatformInterface {
  static final _token = Object();

  WifiManager.impl() : super(token: _token);

  factory WifiManager() => WifiPlugin.instance.newWifiManager();

  Stream<WifiState> get stateChanged;

  Future<bool> isWifiEnabled();
  Future<void> setWifiEnabled(bool value);

  Future<List<WifiConfiguration>> getConfiguredNetworks();
  Future<WifiInfo> getConnectionInfo();
  Future<DhcpInfo> getDhcpInfo();

  Future<int> addNetwork(WifiConfiguration config);
  Future<void> enableNetwork(int netId, bool attemptConnect);
  Future<void> disableNetwork(int netId);
  Future<void> disconnect();
}
