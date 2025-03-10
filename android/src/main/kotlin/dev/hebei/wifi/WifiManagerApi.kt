package dev.hebei.wifi

import android.net.DhcpInfo
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager

class WifiManagerApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiWifiManager(registrar) {
    override fun addNetwork(pigeon_instance: WifiManager, config: WifiConfiguration): Long {
        return pigeon_instance.addNetwork(config).toLong()
    }

    override fun disableNetwork(pigeon_instance: WifiManager, netId: Long): Boolean {
        return pigeon_instance.disableNetwork(netId.toInt())
    }

    override fun disconnect(pigeon_instance: WifiManager): Boolean {
        return pigeon_instance.disconnect()
    }

    override fun enableNetwork(pigeon_instance: WifiManager, netId: Long, attemptConnect: Boolean): Boolean {
        return pigeon_instance.enableNetwork(netId.toInt(), attemptConnect)
    }

    override fun getConfiguredNetworks(pigeon_instance: WifiManager): List<WifiConfiguration> {
        return pigeon_instance.configuredNetworks
    }

    override fun getConnectionInfo(pigeon_instance: WifiManager): WifiInfo {
        return pigeon_instance.connectionInfo
    }

    override fun getDhcpInfo(pigeon_instance: WifiManager): DhcpInfo {
        return pigeon_instance.dhcpInfo
    }

    override fun isWifiEnabled(pigeon_instance: WifiManager): Boolean {
        return pigeon_instance.isWifiEnabled
    }

    override fun setWifiEnabled(pigeon_instance: WifiManager, enabled: Boolean): Boolean {
        return pigeon_instance.setWifiEnabled(enabled)
    }
}