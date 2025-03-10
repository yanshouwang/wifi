import 'dart:async';

import 'dhcp_info.dart';
import 'wifi.g.dart' as api;
import 'wifi_configuration.dart';
import 'wifi_configuration_status.dart';
import 'wifi_exception.dart';
import 'wifi_info.dart';
import 'wifi_manager.dart';
import 'wifi_plugin.dart';
import 'wifi_state.dart';

api.Context get _context => api.WifiPlugin.instance.context;

final class WifiPluginImpl extends WifiPlugin {
  @override
  WifiManager newWifiManager() {
    return WifiManagerImpl();
  }

  @override
  WifiConfiguration newWifiConfiguration() {
    return WifiConfigurationImpl();
  }
}

final class WifiManagerImpl extends WifiManager {
  static WifiManagerImpl? _instance;

  final Future<api.WifiManager> _manager;

  late final StreamController<WifiState> _stateChangedController;
  late final api.BroadcastReceiver _receiver;

  WifiManagerImpl.api(this._manager) : super.impl() {
    _stateChangedController = StreamController.broadcast(
      onListen: _onListenStateChagned,
      onCancel: _onCancelStateChagned,
    );
    _receiver = api.BroadcastReceiver(
      onReceive: (_, context, intent) async {
        final action = await intent.getAction();
        if (action != api.IntentAction.wifiStateChanged) {
          return;
        }
        final state = await intent.getWifiState();
        _stateChangedController.add(state);
      },
    );
  }

  factory WifiManagerImpl() {
    var instance = _instance;
    if (instance == null) {
      final manager = api.ContextCompat.getWifiManager(_context)
          .then((e) => ArgumentError.checkNotNull(e));
      _instance = instance = WifiManagerImpl.api(manager);
    }
    return instance;
  }

  @override
  Stream<WifiState> get stateChanged => _stateChangedController.stream;

  @override
  Future<bool> isWifiEnabled() async {
    final manager = await _manager;
    final value = await manager.isWifiEnabled();
    return value;
  }

  @override
  Future<void> setWifiEnabled(bool value) async {
    final manager = await _manager;
    final ok = await manager.setWifiEnabled(value);
    if (!ok) {
      throw WifiException('setWifiEnabled $value failed.');
    }
  }

  void _onListenStateChagned() async {
    final context = _context;
    final receiver = _receiver;
    final filter = api.IntentFilter(
      action: api.IntentAction.wifiStateChanged,
    );
    final flags = api.ReceiverFlags.notExported;
    await api.ContextCompat.registerReceiver(context, receiver, filter, flags);
  }

  void _onCancelStateChagned() async {
    final context = _context;
    final receiver = _receiver;
    await context.unregisterReceiver(receiver);
  }

  @override
  Future<int> addNetwork(WifiConfiguration config) async {
    if (config is! WifiConfigurationImpl) {
      throw TypeError();
    }
    final manager = await _manager;
    return manager.addNetwork(config.args);
  }

  @override
  Future<List<WifiConfiguration>> getConfiguredNetworks() async {
    final manager = await _manager;
    final value = await manager.getConfiguredNetworks();
    return value.map((e) => e.obj).toList();
  }

  @override
  Future<WifiInfo> getConnectionInfo() async {
    final manager = await _manager;
    final value = await manager.getConnectionInfo();
    return value.obj;
  }

  @override
  Future<DhcpInfo> getDhcpInfo() async {
    final manager = await _manager;
    final value = await manager.getDhcpInfo();
    return value.obj;
  }

  @override
  Future<void> disableNetwork(int netId) async {
    final manager = await _manager;
    final ok = await manager.disableNetwork(netId);
    if (!ok) {
      throw WifiException('disableNetwork $netId failed.');
    }
  }

  @override
  Future<void> disconnect() async {
    final manager = await _manager;
    final ok = await manager.disconnect();
    if (!ok) {
      throw WifiException('disconnect failed.');
    }
  }

  @override
  Future<void> enableNetwork(int netId, bool attemptConnect) async {
    final manager = await _manager;
    final ok = await manager.enableNetwork(netId, attemptConnect);
    if (!ok) {
      throw WifiException('enableNetwork $netId, $attemptConnect failed.');
    }
  }
}

final class WifiConfigurationImpl extends WifiConfiguration {
  final api.WifiConfiguration _configuration;

  WifiConfigurationImpl.api(this._configuration) : super.impl();

  factory WifiConfigurationImpl() {
    final configuration = api.WifiConfiguration();
    return WifiConfigurationImpl.api(configuration);
  }

  @override
  Future<String> getBSSID() async {
    final value = await _configuration.getBSSID();
    return value;
  }

  @override
  Future<String> getFQDN() async {
    final value = await _configuration.getFQDN();
    return value;
  }

  @override
  Future<String> getSSID() async {
    final value = await _configuration.getSSID();
    return value;
  }

  @override
  Future<void> setSSID(String value) async {
    await _configuration.setSSID(value);
  }

  @override
  Future<bool> getHiddenSSID() async {
    final value = await _configuration.getHiddenSSID();
    return value;
  }

  @override
  Future<int> getNetworkId() async {
    final value = await _configuration.getNetworkId();
    return value;
  }

  @override
  Future<WifiConfigurationStatus> getStatus() async {
    final value = await _configuration.getStatus();
    return value;
  }
}

final class WifiInfoImpl extends WifiInfo {
  final api.WifiInfo _info;

  WifiInfoImpl.api(this._info) : super.impl();

  @override
  Future<String> getBSSID() async {
    final value = await _info.getBSSID();
    return value;
  }

  @override
  Future<int> getFrequency() async {
    final value = await _info.getFrequency();
    return value;
  }

  @override
  Future<bool> getHiddenSSID() async {
    final value = await _info.getHiddenSSID();
    return value;
  }

  @override
  Future<int> getIpAddress() async {
    final value = await _info.getIpAddress();
    return value;
  }

  @override
  Future<int> getLinkSpeed() async {
    final value = await _info.getLinkSpeed();
    return value;
  }

  @override
  Future<String> getMacAddress() async {
    final value = await _info.getMacAddress();
    return value;
  }

  @override
  Future<int> getNetworkId() async {
    final value = await _info.getNetworkId();
    return value;
  }

  @override
  Future<int> getRssi() async {
    final value = await _info.getRssi();
    return value;
  }

  @override
  Future<String> getSSID() async {
    final value = await _info.getSSID();
    return value;
  }
}

final class DhcpInfoImpl extends DhcpInfo {
  final api.DhcpInfo _info;

  DhcpInfoImpl.api(this._info) : super.impl();

  @override
  Future<int> getDNS1() async {
    final value = await _info.getDNS1();
    return value;
  }

  @override
  Future<int> getDNS2() async {
    final value = await _info.getDNS2();
    return value;
  }

  @override
  Future<int> getGateway() async {
    final value = await _info.getGateway();
    return value;
  }

  @override
  Future<int> getIpAddress() async {
    final value = await _info.getIpAddress();
    return value;
  }

  @override
  Future<int> getLeaseDuration() async {
    final value = await _info.getLeaseDuration();
    return value;
  }

  @override
  Future<int> getNetmask() async {
    final value = await _info.getNetmask();
    return value;
  }

  @override
  Future<int> getServerAddress() async {
    final value = await _info.getServerAddress();
    return value;
  }
}

extension on WifiConfigurationImpl {
  api.WifiConfiguration get args => _configuration;
}

extension on api.WifiConfiguration {
  WifiConfigurationImpl get obj => WifiConfigurationImpl.api(this);
}

extension on api.WifiInfo {
  WifiInfoImpl get obj => WifiInfoImpl.api(this);
}

extension on api.DhcpInfo {
  DhcpInfoImpl get obj => DhcpInfoImpl.api(this);
}
