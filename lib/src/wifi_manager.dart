import 'dart:async';

import 'dhcp_info.dart';
import 'events.dart';
import 'impl.dart';
import 'scan_result.dart';
import 'wifi_configuration.dart';
import 'wifi_info.dart';

abstract interface class WiFiManager {
  static WiFiManager? _instance;

  factory WiFiManager() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = WiFiManagerImpl();
    }
    return instance;
  }

  bool get enabled;
  set enabled(bool value);

  Stream<WiFiStateChangedEvent> get stateChanged;

  List<ScanResult> get scanResults;

  List<WiFiConfiguration> get configuredNetworks;
  WiFiInfo get connectionInfo;
  DHCPInfo get dhcpInfo;

  int addNetwork(WiFiConfiguration config);
  void enableNetwork(int netId, bool attemptConnect);
  void disableNetwork(int netId);
  void disconnect();

  bool checkPermissions();
  Future<bool> requestPermissions();
}
