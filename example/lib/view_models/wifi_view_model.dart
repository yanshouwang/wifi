import 'dart:async';

import 'package:clover/clover.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_example/models.dart';

final class WiFiViewModel extends ViewModel {
  final WifiManager _wifiManager;
  bool _enabled;
  List<WifiConfigurationModel> _configuredNetworks;
  WifiInfoModel? _connectionInfo;

  late final StreamSubscription _stateChangedSubscription;

  WiFiViewModel()
    : _wifiManager = WifiManager(),
      _enabled = false,
      _configuredNetworks = [] {
    _stateChangedSubscription = _wifiManager.stateChanged.listen((state) {
      _enabled = state == WifiState.enabled;
      notifyListeners();
    });
    _initialize();
  }

  @override
  void dispose() {
    _stateChangedSubscription.cancel();
    super.dispose();
  }

  bool get enabled => _enabled;

  List<WifiConfigurationModel> get configuredNetworks => _configuredNetworks;

  WifiInfoModel? get connectionInfo => _connectionInfo;

  Future<void> enable(bool value) => _wifiManager.setWifiEnabled(value);

  Future<void> connect(int netId) async {
    await _wifiManager.enableNetwork(netId, true);
  }

  Future<void> disconnect(int netId) async {
    await _wifiManager.disconnect();
  }

  void _initialize() async {
    var isGranted = await Permission.locationWhenInUse.isGranted;
    if (!isGranted) {
      final status = await Permission.locationWhenInUse.request();
      isGranted = status == PermissionStatus.granted;
    }
    if (!isGranted) {
      return;
    }
    _enabled = await _wifiManager.isWifiEnabled();
    _configuredNetworks = await _getConfiguredNetworks();
    _connectionInfo = await _getConnectionInfo();
    notifyListeners();
  }

  Future<List<WifiConfigurationModel>> _getConfiguredNetworks() async {
    final configuredNetworks = await _wifiManager.getConfiguredNetworks();
    final models = <WifiConfigurationModel>[];
    for (var network in configuredNetworks) {
      final networkId = await network.getNetworkId();
      final ssid = await network.getSSID();
      final status = await network.getStatus();
      final any = models.any((item) => item.networkId == networkId);
      if (any) {
        continue;
      }
      final model = WifiConfigurationModel(
        networkId: networkId,
        ssid: ssid,
        status: status,
      );
      models.add(model);
    }
    return models;
  }

  Future<WifiInfoModel> _getConnectionInfo() async {
    final connectionInfo = await _wifiManager.getConnectionInfo();
    final ssid = await connectionInfo.getSSID();
    final linkSpeed = await connectionInfo.getLinkSpeed();
    final model = WifiInfoModel(ssid: ssid, linkSpeed: linkSpeed);
    return model;
  }
}
