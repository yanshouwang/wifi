package dev.hebei.wifi

import android.content.Intent
import android.net.wifi.WifiManager

class IntentApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiIntent(registrar) {
    override fun getAction(pigeon_instance: Intent): IntentAction {
        return pigeon_instance.action?.intentActionArgs ?: IntentAction.UNKNOWN
    }

    override fun getWifiState(pigeon_instance: Intent): WifiState {
        val state = pigeon_instance.getIntExtra(WifiManager.EXTRA_WIFI_STATE, WifiManager.WIFI_STATE_UNKNOWN)
        return state.wifiStateArgs
    }
}

val String.intentActionArgs: IntentAction
    get() = when (this) {
        WifiManager.WIFI_STATE_CHANGED_ACTION -> IntentAction.WIFI_STATE_CHANGED
        else -> IntentAction.UNKNOWN
    }

val Int.wifiStateArgs: WifiState
    get() = when (this) {
        WifiManager.WIFI_STATE_DISABLED -> WifiState.DISABLED
        WifiManager.WIFI_STATE_DISABLING -> WifiState.DISABLING
        WifiManager.WIFI_STATE_ENABLED -> WifiState.ENABLED
        WifiManager.WIFI_STATE_ENABLING -> WifiState.ENABLING
        else -> WifiState.UNKNOWN
    }