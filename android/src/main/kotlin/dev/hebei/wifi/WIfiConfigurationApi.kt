package dev.hebei.wifi

import android.net.wifi.WifiConfiguration

class WIfiConfigurationApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiWifiConfiguration(registrar) {
    override fun pigeon_defaultConstructor(): WifiConfiguration {
        return WifiConfiguration()
    }

    override fun getBSSID(pigeon_instance: WifiConfiguration): String {
        return pigeon_instance.BSSID
    }

    override fun getFQDN(pigeon_instance: WifiConfiguration): String {
        return pigeon_instance.FQDN
    }

    override fun getSSID(pigeon_instance: WifiConfiguration): String {
        return pigeon_instance.SSID
    }

    override fun setSSID(pigeon_instance: WifiConfiguration, value: String) {
        pigeon_instance.SSID = value
    }

    override fun getHiddenSSID(pigeon_instance: WifiConfiguration): Boolean {
        return pigeon_instance.hiddenSSID
    }

    override fun getNetworkId(pigeon_instance: WifiConfiguration): Long {
        return pigeon_instance.networkId.toLong()
    }

    override fun getStatus(pigeon_instance: WifiConfiguration): WifiConfigurationStatus {
        return pigeon_instance.status.wifiConfigurationStatusArgs
    }
}

val Int.wifiConfigurationStatusArgs: WifiConfigurationStatus
    get() = when (this) {
        WifiConfiguration.Status.CURRENT -> WifiConfigurationStatus.CURRENT
        WifiConfiguration.Status.DISABLED -> WifiConfigurationStatus.DISABLED
        WifiConfiguration.Status.ENABLED -> WifiConfigurationStatus.ENABLED
        else -> throw IllegalArgumentException()
    }