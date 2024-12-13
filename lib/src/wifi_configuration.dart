import 'impl.dart';
import 'wifi_configuration_status.dart';

abstract interface class WiFiConfiguration {
  factory WiFiConfiguration() => WiFiConfigurationImpl();

  String? get bssid;
  String? get fqdn;
  String get ssid;
  set ssid(String value);

  // BitSet get allowedAuthAlgorithms;
  // BitSet get allowedGroupCiphers;
  // BitSet get allowedKeyManagement;
  // BitSet get allowedPairwiseCiphers;
  // BitSet get allowedProtocols;
  // WiFiEnterpriseConfig get enterpriseConfig;
  bool get hiddenSSID;
  int get networkId;
  String? get preSharedKey;
  set preSharedKey(String? value);

  WiFiConfigurationStatus get status;
  List<String?> get wepKeys;
  set wepKeys(List<String?> value);

  int get wepTxKeyIndex;
}
