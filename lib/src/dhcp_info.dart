import 'jni.dart' as jni;

final class DHCPInfo {
  final jni.DhcpInfo _jdi;

  DHCPInfo(this._jdi);

  int get dns1 => _jdi.dns1;
  int get dns2 => _jdi.dns2;
  int get gateway => _jdi.gateway;
  int get ipAddress => _jdi.ipAddress;
  int get leaseDuration => _jdi.leaseDuration;
  int get netmask => _jdi.netmask;
  int get serverAddress => _jdi.serverAddress;
}
