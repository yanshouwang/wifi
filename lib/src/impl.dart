import 'dart:async';

import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:jni/jni.dart' as jni;

import 'dhcp_info.dart';
import 'events.dart';
import 'jni.dart' as jni;
import 'scan_result.dart';
import 'wifi_configuration.dart';
import 'wifi_configuration_status.dart';
import 'wifi_exception.dart';
import 'wifi_info.dart';
import 'wifi_manager.dart';
import 'wifi_state.dart';

final class WiFiManagerImpl
    with TypeLogger, LoggerController
    implements WiFiManager {
  final jni.WifiManager _jwm;
  final List<jni.JString> _jps;

  late final StreamController<WiFiStateChangedEvent> _stateChangedController;
  late final jni.BroadcastReceiverImpl _receiver;

  WiFiManagerImpl()
      : _jwm = jni.ContextCompat.getSystemService(
          jni.context,
          jni.WifiManager.type.jClass,
          T: jni.WifiManager.type,
        ),
        _jps = [
          jni.Manifest_permission.ACCESS_FINE_LOCATION,
        ] {
    _stateChangedController = StreamController.broadcast(
      onListen: _onListenStateChagned,
      onCancel: _onCancelStateChagned,
    );
    final callback = jni.BroadcastReceiverImpl_Callback.implement(
      jni.$BroadcastReceiverImpl_Callback(
        onReceive: (context, intent) {
          final state = intent
              .getIntExtra(
                jni.WifiManager.EXTRA_WIFI_STATE,
                jni.WifiManager.WIFI_STATE_UNKNOWN,
              )
              .toWiFiState();
          final event = WiFiStateChangedEvent(state);
          _stateChangedController.add(event);
        },
      ),
    );
    _receiver = jni.BroadcastReceiverImpl(callback);
  }

  @override
  bool get enabled {
    return _jwm.isWifiEnabled();
  }

  @override
  set enabled(bool value) {
    final ok = _jwm.setWifiEnabled(value);
    if (!ok) {
      throw WiFiException('setWifiEnabled $value failed.');
    }
  }

  @override
  Stream<WiFiStateChangedEvent> get stateChanged =>
      _stateChangedController.stream;

  void _onListenStateChagned() {
    final receiver = _receiver;
    final filter =
        jni.IntentFilter.new$1(jni.WifiManager.WIFI_STATE_CHANGED_ACTION);
    jni.ContextCompat.registerReceiver(
      jni.context,
      receiver,
      filter,
      jni.ContextCompat.RECEIVER_NOT_EXPORTED,
    );
  }

  void _onCancelStateChagned() {
    jni.context.unregisterReceiver(_receiver);
  }

  @override
  List<ScanResult> get scanResults =>
      _jwm.getScanResults().map((jsr) => ScanResultImpl.jni(jsr)).toList();

  @override
  bool checkPermissions() {
    return _jps.every((permission) =>
        jni.ContextCompat.checkSelfPermission(jni.context, permission) ==
        jni.PackageManager.PERMISSION_GRANTED);
  }

  @override
  Future<bool> requestPermissions() async {
    final completer = Completer<bool>();
    final jps = jni.JArray(jni.JString.type, _jps.length)
      ..setRange(0, _jps.length, _jps);
    const requestCode = 1949;
    final listener =
        jni.PluginRegistry_RequestPermissionsResultListener.implement(
      jni.$PluginRegistry_RequestPermissionsResultListener(
        onRequestPermissionsResult: (code, _, rs) {
          if (code != requestCode) {
            return false;
          }
          final isGranted = rs
              .getRange(0, rs.length)
              .every((r) => r == jni.PackageManager.PERMISSION_GRANTED);
          completer.complete(isGranted);
          return true;
        },
      ),
    );
    jni.ActivityX.INSTANCE.addRequestPermissionsResultListener(listener);
    try {
      jni.ActivityCompat.requestPermissions(jni.activity, jps, requestCode);
      return await completer.future;
    } finally {
      jni.ActivityX.INSTANCE.removeRequestPermissionsResultListener(listener);
    }
  }

  @override
  int addNetwork(WiFiConfiguration config) {
    if (config is! WiFiConfigurationImpl) {
      throw TypeError();
    }
    return _jwm.addNetwork(config._jwc);
  }

  @override
  List<WiFiConfiguration> get configuredNetworks => _jwm
      .getConfiguredNetworks()
      .map((jwc) => WiFiConfigurationImpl.jni(jwc))
      .toList();

  @override
  WiFiInfo get connectionInfo {
    final jwi = _jwm.getConnectionInfo();
    return WiFiInfoImpl.jni(jwi);
  }

  @override
  DHCPInfo get dhcpInfo {
    final jdi = _jwm.getDhcpInfo();
    return DHCPInfo(jdi);
  }

  @override
  void disableNetwork(int netId) {
    final ok = _jwm.disableNetwork(netId);
    if (!ok) {
      throw WiFiException('disableNetwork $netId failed.');
    }
  }

  @override
  void disconnect() {
    final ok = _jwm.disconnect();
    if (!ok) {
      throw WiFiException('disconnect failed.');
    }
  }

  @override
  void enableNetwork(int netId, bool attemptConnect) {
    final ok = _jwm.enableNetwork(netId, attemptConnect);
    if (!ok) {
      throw WiFiException('enableNetwork $netId, $attemptConnect failed.');
    }
  }
}

final class ScanResultImpl implements ScanResult {
  final jni.ScanResult _jsr;

  ScanResultImpl.jni(this._jsr);

  @override
  String get bssid => _jsr.BSSID.toDartString(
        releaseOriginal: true,
      );
  @override
  String get ssid => _jsr.SSID.toDartString(
        releaseOriginal: true,
      );
  @override
  String get capabilities => _jsr.capabilities.toDartString(
        releaseOriginal: true,
      );
  @override
  int get centerFreq0 => _jsr.centerFreq0;
  @override
  int get centerFreq1 => _jsr.centerFreq1;
  @override
  int get channelWidth => _jsr.channelWidth;
  @override
  int get frequency => _jsr.frequency;
  @override
  int get level => _jsr.level;
  @override
  String get operatorFriendlyName =>
      _jsr.operatorFriendlyName.toString$1().toDartString(
            releaseOriginal: true,
          );
  @override
  int get timestamp => _jsr.timestamp;
  @override
  String get venueName => _jsr.venueName.toString$1().toDartString(
        releaseOriginal: true,
      );
}

final class WiFiConfigurationImpl implements WiFiConfiguration {
  final jni.WifiConfiguration _jwc;

  WiFiConfigurationImpl() : _jwc = jni.WifiConfiguration();

  WiFiConfigurationImpl.jni(this._jwc);

  @override
  String? get bssid {
    final jbssid = _jwc.BSSID;
    return jbssid.isNull
        ? null
        : jbssid.toDartString(
            releaseOriginal: true,
          );
  }

  @override
  String? get fqdn {
    final jfqdn = _jwc.FQDN;
    return jfqdn.isNull
        ? null
        : jfqdn.toDartString(
            releaseOriginal: true,
          );
  }

  @override
  String get ssid => _jwc.SSID.toDartString(
        releaseOriginal: true,
      );
  @override
  set ssid(String value) => _jwc.SSID = value.toJString();

  @override
  bool get hiddenSSID => _jwc.hiddenSSID;
  @override
  int get networkId => _jwc.networkId;
  @override
  String? get preSharedKey {
    final jpsk = _jwc.preSharedKey;
    return jpsk.isNull
        ? null
        : jpsk.toDartString(
            releaseOriginal: true,
          );
  }

  @override
  set preSharedKey(String? value) {
    _jwc.preSharedKey = value == null
        ? jni.JString.fromReference(jni.jNullReference)
        : value.toJString();
  }

  @override
  WiFiConfigurationStatus get status => _jwc.status.toWiFiConfigurationStatus();

  @override
  List<String?> get wepKeys {
    final jwks = _jwc.wepKeys;
    final wks = <String?>[];
    for (var i = 0; i < jwks.length; i++) {
      final jwk = jwks[i];
      final wk = jwk.isNull
          ? null
          : jwk.toDartString(
              releaseOriginal: true,
            );
      wks.add(wk);
    }
    return List.unmodifiable(wks);
  }

  @override
  set wepKeys(List<String?> value) =>
      _jwc.wepKeys = jni.JArray(jni.JString.type, value.length)
        ..setRange(
          0,
          value.length,
          value.map((wk) => wk == null
              ? jni.JString.fromReference(jni.jNullReference)
              : wk.toJString()),
        );

  @override
  int get wepTxKeyIndex => _jwc.wepTxKeyIndex;
}

final class WiFiInfoImpl implements WiFiInfo {
  final jni.WifiInfo _jwi;

  WiFiInfoImpl.jni(this._jwi);

  @override
  String get bssid => _jwi.getBSSID().toDartString(
        releaseOriginal: true,
      );
  @override
  int get frequency => _jwi.getFrequency();
  @override
  bool get hiddenSSID => _jwi.getHiddenSSID();
  @override
  int get ipAddress => _jwi.getIpAddress();
  @override
  int get linkSpeed => _jwi.getLinkSpeed();
  @override
  String get macAddress => _jwi.getMacAddress().toDartString(
        releaseOriginal: true,
      );
  @override
  int get networkId => _jwi.getNetworkId();
  @override
  int get rssi => _jwi.getRssi();
  @override
  String get ssid => _jwi.getSSID().toDartString(
        releaseOriginal: true,
      );
}

extension on int {
  WiFiState toWiFiState() {
    switch (this) {
      case jni.WifiManager.WIFI_STATE_UNKNOWN:
        return WiFiState.unknown;
      case jni.WifiManager.WIFI_STATE_DISABLED:
        return WiFiState.disabled;
      case jni.WifiManager.WIFI_STATE_ENABLING:
        return WiFiState.enabling;
      case jni.WifiManager.WIFI_STATE_ENABLED:
        return WiFiState.enabled;
      case jni.WifiManager.WIFI_STATE_DISABLING:
        return WiFiState.disabling;
      default:
        throw ArgumentError.value(this);
    }
  }

  WiFiConfigurationStatus toWiFiConfigurationStatus() {
    switch (this) {
      case jni.WifiConfiguration_Status.CURRENT:
        return WiFiConfigurationStatus.current;
      case jni.WifiConfiguration_Status.DISABLED:
        return WiFiConfigurationStatus.disabled;
      case jni.WifiConfiguration_Status.ENABLED:
        return WiFiConfigurationStatus.enabled;
      default:
        throw ArgumentError.value(this);
    }
  }
}
