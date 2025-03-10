package dev.hebei.wifi

import android.content.BroadcastReceiver
import android.content.Context

class ContextApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiContext(registrar) {
    override fun unregisterReceiver(pigeon_instance: Context, receiver: BroadcastReceiver) {
        pigeon_instance.unregisterReceiver(receiver)
    }
}