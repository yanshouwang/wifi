abstract interface class ScanResult {
  String get bssid;
  String get ssid;
  String get capabilities;
  int get centerFreq0;
  int get centerFreq1;
  int get channelWidth;
  int get frequency;
  int get level;
  String get operatorFriendlyName;
  int get timestamp;
  String get venueName;
}
