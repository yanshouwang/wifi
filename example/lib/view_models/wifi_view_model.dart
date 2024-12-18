import 'dart:async';

import 'package:clover/clover.dart';
import 'package:wifi/wifi.dart';

final class WiFiViewModel extends ViewModel {
  final WiFiManager _wm;

  late final StreamSubscription _stateChangedSubscription;

  WiFiViewModel() : _wm = WiFiManager() {
    _stateChangedSubscription = _wm.stateChanged.listen((event) {
      notifyListeners();
    });
    _checkPermissions();
  }

  bool get enabled => _wm.enabled;
  set enabled(bool value) => _wm.enabled = value;

  List<WiFiConfiguration> get configuredNetworks {
    final items = <WiFiConfiguration>[];
    final configuredNetworks = _wm.configuredNetworks;
    for (var configuredNetwork in configuredNetworks) {
      final any =
          items.any((item) => item.networkId == configuredNetwork.networkId);
      if (any) {
        continue;
      }
      items.add(configuredNetwork);
    }
    return items;
  }

  List<ScanResult> get scanResults => _wm.scanResults;
  WiFiInfo get connectionInfo => _wm.connectionInfo;

  @override
  void dispose() {
    _stateChangedSubscription.cancel();
    super.dispose();
  }

  void connect(int netId) {
    _wm.enableNetwork(netId, true);
  }

  void disconnect(int netId) {
    _wm.disconnect();
  }

  void _checkPermissions() async {
    var isGranted = _wm.checkPermissions();
    if (!isGranted) {
      isGranted = await _wm.requestPermissions();
    }
    if (!isGranted) {
      return;
    }
    notifyListeners();
  }
}
