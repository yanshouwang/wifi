import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'impl.dart';
import 'wifi_configuration.dart';
import 'wifi_manager.dart';

abstract class WifiPlugin extends PlatformInterface {
  /// Constructs a WifiPlugin.
  WifiPlugin() : super(token: _token);

  static final Object _token = Object();

  static WifiPlugin? _instance;

  /// The default instance of [WifiPlugin] to use.
  static WifiPlugin get instance {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = WifiPluginImpl();
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WifiPlugin] when
  /// they register themselves.
  static set instance(WifiPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  WifiManager newWifiManager();
  WifiConfiguration newWifiConfiguration();
}
