package dev.hebei.wifi

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BroadcastReceiverApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiBroadcastReceiver(registrar) {
    override fun pigeon_defaultConstructor(): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                this@BroadcastReceiverApi.onReceive(this, context, intent) {}
            }
        }
    }
}