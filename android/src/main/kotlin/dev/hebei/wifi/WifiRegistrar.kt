package dev.hebei.wifi

import io.flutter.plugin.common.BinaryMessenger

class WifiRegistrar(binaryMessenger: BinaryMessenger, private val instance: WifiPlugin) :
    WifiPigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiWifiPlugin(): PigeonApiWifiPlugin {
        return WifiPluginApi(this, instance)
    }

    override fun getPigeonApiContext(): PigeonApiContext {
        return ContextApi(this)
    }

    override fun getPigeonApiContextCompat(): PigeonApiContextCompat {
        return ContextCompatApi(this)
    }

    override fun getPigeonApiIntent(): PigeonApiIntent {
        return IntentApi(this)
    }

    override fun getPigeonApiBroadcastReceiver(): PigeonApiBroadcastReceiver {
        return BroadcastReceiverApi(this)
    }

    override fun getPigeonApiIntentFilter(): PigeonApiIntentFilter {
        return IntentFilterApi(this)
    }

    override fun getPigeonApiWifiManager(): PigeonApiWifiManager {
        return WifiManagerApi(this)
    }

    override fun getPigeonApiWifiConfiguration(): PigeonApiWifiConfiguration {
        return WIfiConfigurationApi(this)
    }

    override fun getPigeonApiWifiInfo(): PigeonApiWifiInfo {
        return WifiInfoApi(this)
    }

    override fun getPigeonApiDhcpInfo(): PigeonApiDhcpInfo {
        return DhcpInfoApi(this)
    }
}