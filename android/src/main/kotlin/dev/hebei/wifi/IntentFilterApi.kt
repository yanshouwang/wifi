package dev.hebei.wifi

import android.content.IntentFilter
import android.net.wifi.WifiManager

class IntentFilterApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiIntentFilter(registrar) {
    override fun pigeon_defaultConstructor(action: IntentAction): IntentFilter {
        return IntentFilter(action.obj)
    }
}

val IntentAction.obj
    get() = when (this) {
        IntentAction.UNKNOWN -> throw IllegalArgumentException()
        IntentAction.WIFI_STATE_CHANGED -> WifiManager.WIFI_STATE_CHANGED_ACTION
    }