package dev.hebei.wifi

import android.net.wifi.WifiInfo

class WifiInfoApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiWifiInfo(registrar) {
    override fun getBSSID(pigeon_instance: WifiInfo): String {
        return pigeon_instance.bssid
    }

    override fun getFrequency(pigeon_instance: WifiInfo): Long {
        return pigeon_instance.frequency.toLong()
    }

    override fun getHiddenSSID(pigeon_instance: WifiInfo): Boolean {
        return pigeon_instance.hiddenSSID
    }

    override fun getIpAddress(pigeon_instance: WifiInfo): Long {
        return pigeon_instance.ipAddress.toLong()
    }

    override fun getLinkSpeed(pigeon_instance: WifiInfo): Long {
        return pigeon_instance.linkSpeed.toLong()
    }

    override fun getMacAddress(pigeon_instance: WifiInfo): String {
        return pigeon_instance.macAddress
    }

    override fun getNetworkId(pigeon_instance: WifiInfo): Long {
        return pigeon_instance.networkId.toLong()
    }

    override fun getRssi(pigeon_instance: WifiInfo): Long {
        return pigeon_instance.rssi.toLong()
    }

    override fun getSSID(pigeon_instance: WifiInfo): String {
        return pigeon_instance.ssid
    }
}