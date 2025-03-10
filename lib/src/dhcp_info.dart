import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract base class DhcpInfo extends PlatformInterface {
  static final _token = Object();

  DhcpInfo.impl() : super(token: _token);

  Future<int> getDNS1();
  Future<int> getDNS2();
  Future<int> getGateway();
  Future<int> getIpAddress();
  Future<int> getLeaseDuration();
  Future<int> getNetmask();
  Future<int> getServerAddress();
}
