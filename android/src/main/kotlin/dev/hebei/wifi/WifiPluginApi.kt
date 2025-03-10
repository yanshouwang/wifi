package dev.hebei.wifi

import android.content.Context

class WifiPluginApi(registrar: WifiPigeonProxyApiRegistrar, private val instance: WifiPlugin) :
    PigeonApiWifiPlugin(registrar) {
    override fun instance(): WifiPlugin {
        return instance
    }

    override fun context(pigeon_instance: WifiPlugin): Context {
        return pigeon_instance.context
    }
}