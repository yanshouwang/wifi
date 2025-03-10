// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/wifi.g.dart',
    kotlinOut: 'android/src/main/kotlin/dev/hebei/wifi/Wifi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.hebei.wifi',
      errorClassName: 'WifiError',
    ),
  ),
)
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.wifi.WifiPlugin',
  ),
)
abstract class WifiPlugin {
  @static
  late final WifiPlugin instance;
  @attached
  late final Context context;
}

/// Interface to global information about an application environment. This is an
/// abstract class whose implementation is provided by the Android system. It
/// allows access to application-specific resources and classes, as well as up-calls
/// for application-level operations such as launching activities, broadcasting
/// and receiving intents, etc.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.content.Context',
  ),
)
abstract class Context {
  /// Unregister a previously registered BroadcastReceiver. All filters that have
  /// been registered for this BroadcastReceiver will be removed.
  void unregisterReceiver(BroadcastReceiver receiver);
}

/// Helper for accessing features in Context.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'androidx.core.content.ContextCompat',
  ),
)
abstract class ContextCompat {
  /// Return the handle to a system-level service by class.
  @static
  WifiManager? getWifiManager(Context context);

  /// Register a broadcast receiver.
  @static
  Intent? registerReceiver(Context context, BroadcastReceiver receiver,
      IntentFilter filter, ReceiverFlags flags);
}

/// An intent is an abstract description of an operation to be performed. It can
/// be used with startActivity to launch an Activity, broadcastIntent to send it
/// to any interested BroadcastReceiver components, and Context.startService(Intent)
/// or Context.bindService(Intent, BindServiceFlags, Executor, ServiceConnection)
/// to communicate with a background Service.
///
/// An Intent provides a facility for performing late runtime binding between the
/// code in different applications. Its most significant use is in the launching
/// of activities, where it can be thought of as the glue between activities. It
/// is basically a passive data structure holding an abstract description of an
/// action to be performed.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.content.Intent',
  ),
)
abstract class Intent {
  /// Retrieve the general action to be performed, such as ACTION_VIEW. The action
  /// describes the general way the rest of the information in the intent should
  /// be interpreted -- most importantly, what to do with the data returned by
  /// getData().
  IntentAction getAction();

  WifiState getWifiState();
}

/// Base class for code that receives and handles broadcast intents sent by
/// Context.sendBroadcast(Intent).
///
/// You can either dynamically register an instance of this class with
/// Context.registerReceiver() or statically declare an implementation with the
/// &lt;receiver&gt; tag in your AndroidManifest.xml.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.content.BroadcastReceiver',
  ),
)
abstract class BroadcastReceiver {
  BroadcastReceiver();

  /// This method is called when the BroadcastReceiver is receiving an Intent broadcast. During this time you can use the other methods on BroadcastReceiver to view/modify the current result values. This method is always called within the main thread of its process, unless you explicitly asked for it to be scheduled on a different thread using Context.registerReceiver(BroadcastReceiver, IntentFilter, String, android.os.Handler). When it runs on the main thread you should never perform long-running operations in it (there is a timeout of 10 seconds that the system allows before considering the receiver to be blocked and a candidate to be killed). You cannot launch a popup dialog in your implementation of onReceive().
  late final void Function(Context context, Intent intent) onReceive;
}

/// Structured description of Intent values to be matched. An IntentFilter can
/// match against actions, categories, and data (either via its type, scheme,
/// and/or path) in an Intent. It also includes a "priority" value which is used
/// to order multiple matching filters.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.content.IntentFilter',
  ),
)
abstract class IntentFilter {
  /// New IntentFilter that matches a single action with no data. If no data
  /// characteristics are subsequently specified, then the filter will only match
  /// intents that contain no data.
  IntentFilter(IntentAction action);
}

/// This class provides the primary API for managing all aspects of Wi-Fi
/// connectivity.
///
/// On releases before Build.VERSION_CODES.N, this object should only be obtained
/// from an application context, and not from any other derived context to avoid
/// memory leaks within the calling process.
///
/// It deals with several categories of items:
///
/// * The list of configured networks. The list can be viewed and updated, and
/// attributes of individual entries can be modified.
/// * The currently active Wi-Fi network, if any. Connectivity can be established
/// or torn down, and dynamic information about the state of the network can be
/// queried.
/// * Results of access point scans, containing enough information to make decisions
/// about what access point to connect to.
/// * It defines the names of various Intent actions that are broadcast upon any
/// sort of change in Wi-Fi state.
///
/// This is the API to use when performing Wi-Fi specific operations. To perform
/// operations that pertain to network connectivity at an abstract level, use
/// ConnectivityManager.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.net.wifi.WifiManager',
  ),
)
abstract class WifiManager {
  /// Add a new network description to the set of configured networks. The networkId
  /// field of the supplied configuration object is ignored.
  ///
  /// The new network will be marked DISABLED by default. To enable it, called
  /// enableNetwork(int, boolean).
  int addNetwork(WifiConfiguration config);

  /// Disable a configured network. The specified network will not be a candidate
  /// for associating. This may result in the asynchronous delivery of state change
  /// events. Applications are not allowed to disable networks created by other
  /// applications.
  bool disableNetwork(int netId);

  /// Disassociate from the currently active access point. This may result in the
  /// asynchronous delivery of state change events.
  bool disconnect();

  /// Allow a previously configured network to be associated with. If attemptConnect
  /// is true, an attempt to connect to the selected network is initiated. This
  /// may result in the asynchronous delivery of state change events.
  ///
  /// Note: Network communication may not use Wi-Fi even if Wi-Fi is connected;
  /// traffic may instead be sent through another network, such as cellular data,
  /// Bluetooth tethering, or Ethernet. For example, traffic will never use a Wi-Fi
  /// network that does not provide Internet access (e.g. a wireless printer), if
  /// another network that does offer Internet access (e.g. cellular data) is
  /// available. Applications that need to ensure that their network traffic uses
  /// Wi-Fi should use APIs such as Network.bindSocket(java.net.Socket),
  /// Network.openConnection(java.net.URL), or ConnectivityManager.bindProcessToNetwork
  /// to do so. Applications are not allowed to enable networks created by other
  /// applications.
  bool enableNetwork(int netId, bool attemptConnect);

  /// Return a list of all the networks configured for the current foreground user.
  /// Not all fields of WifiConfiguration are returned. Only the following fields are filled in:
  ///
  /// * networkId
  /// * SSID
  /// * BSSID
  /// * priority
  /// * allowedProtocols
  /// * allowedKeyManagement
  /// * allowedAuthAlgorithms
  /// * allowedPairwiseCiphers
  /// * allowedGroupCiphers
  /// * status
  ///
  /// Requires android.Manifest.permission#ACCESS_FINE_LOCATION and
  /// android.Manifest.permission#ACCESS_WIFI_STATE
  List<WifiConfiguration> getConfiguredNetworks();

  /// Return dynamic information about the current Wi-Fi connection, if any is
  /// active.
  WifiInfo getConnectionInfo();

  /// Return the DHCP-assigned addresses from the last successful DHCP request,
  /// if any.
  DhcpInfo getDhcpInfo();

  /// Return whether Wi-Fi is enabled or disabled.
  bool isWifiEnabled();

  /// Enable or disable Wi-Fi.
  ///
  /// Applications must have the android.Manifest.permission#CHANGE_WIFI_STATE
  /// permission to toggle wifi.
  bool setWifiEnabled(bool enabled);
}

/// A class representing a configured Wi-Fi network, including the security
/// configuration.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.net.wifi.WifiConfiguration',
  ),
)
abstract class WifiConfiguration {
  WifiConfiguration();

  /// When set, this network configuration entry should only be used when associating
  /// with the AP having the specified BSSID. The value is a string in the format
  /// of an Ethernet MAC address, e.g., XX:XX:XX:XX:XX:XX where each X is a hex
  /// digit.
  String getBSSID();

  /// Fully qualified domain name of a Passpoint configuration
  String getFQDN();

  /// The network's SSID. Can either be a UTF-8 string, which must be enclosed in
  /// double quotation marks (e.g., "MyNetwork"), or a string of hex digits, which
  /// are not enclosed in quotes (e.g., 01a243f405).
  String getSSID();
  void setSSID(String value);

  /// This is a network that does not broadcast its SSID, so an SSID-specific probe
  /// request must be used for scans.
  bool getHiddenSSID();

  /// The ID number that the supplicant uses to identify this network configuration
  /// entry. This must be passed as an argument to most calls into the supplicant.
  int getNetworkId();

  /// The current status of this network configuration entry.
  WifiConfigurationStatus getStatus();
}

/// Describes the state of any Wi-Fi connection that is active or is in the process
/// of being set up. In the connected state, access to location sensitive fields
/// requires the same permissions as WifiManager.getScanResults. If such access is
/// not allowed, getSSID() will return WifiManager.UNKNOWN_SSID and getBSSID() will
/// return "02:00:00:00:00:00". getApMldMacAddress() will return null. getNetworkId()
/// will return -1. getPasspointFqdn() will return null. getPasspointProviderFriendlyName()
/// will return null. getInformationElements() will return null. getMacAddress()
/// will return "02:00:00:00:00:00".
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.net.wifi.WifiInfo',
  ),
)
abstract class WifiInfo {
  /// Return the basic service set identifier (BSSID) of the current access point.
  /// In case of Multi Link Operation (MLO), the BSSID corresponds to the BSSID
  /// of the link used for association.
  ///
  /// The BSSID may be null, if there is no network currently connected.
  /// "02:00:00:00:00:00", if the caller has insufficient permissions to access
  /// the BSSID.
  String getBSSID();

  /// Returns the current frequency in FREQUENCY_UNITS. In case of Multi Link
  /// Operation (MLO), returned value is the frequency of the associated link with
  /// the highest RSSI.
  int getFrequency();
  bool getHiddenSSID();
  int getIpAddress();

  /// Returns the current link speed in LINK_SPEED_UNITS. In case of Multi Link
  /// Operation (MLO), returned value is the current link speed of the associated
  /// link with the highest RSSI.
  int getLinkSpeed();

  /// Returns the MAC address used for this connection. In case of Multi Link
  /// Operation (MLO), returned value is the Station MLD MAC address.
  String getMacAddress();

  /// Each configured network has a unique small integer ID, used to identify the
  /// network. This method returns the ID for the currently connected network.
  ///
  /// The networkId may be -1 if there is no currently connected network or if
  /// the caller has insufficient permissions to access the network ID.
  int getNetworkId();

  /// Returns the received signal strength indicator of the current 802.11 network,
  /// in dBm. In case of Multi Link Operation (MLO), returned RSSI is the highest
  /// of all associated links.
  ///
  /// Use WifiManager.calculateSignalLevel(int) to convert this number into an
  /// absolute signal level which can be displayed to a user.
  int getRssi();

  /// Returns the service set identifier (SSID) of the current 802.11 network.
  ///
  /// If the SSID can be decoded as UTF-8, it will be returned surrounded by double
  /// quotation marks. Otherwise, it is returned as a string of hex digits. The
  /// SSID may be WifiManager.UNKNOWN_SSID, if there is no network currently
  /// connected or if the caller has insufficient permissions to access the SSID.
  ///
  /// Prior to Build.VERSION_CODES.JELLY_BEAN_MR1, this method always returned
  /// the SSID with no quotes around it.
  String getSSID();
}

/// A simple object for retrieving the results of a DHCP request.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.net.DhcpInfo',
  ),
)
abstract class DhcpInfo {
  int getDNS1();
  int getDNS2();
  int getGateway();
  int getIpAddress();
  int getLeaseDuration();
  int getNetmask();
  int getServerAddress();
}

enum ReceiverFlags {
  exported,
  notExported,
  visibleToInstantApps,
}

enum IntentAction {
  unknown,
  wifiStateChanged,
}

enum WifiState {
  unknown,
  disabled,
  disabling,
  enabled,
  enabling,
}

enum WifiConfigurationStatus {
  current,
  disabled,
  enabled,
}
