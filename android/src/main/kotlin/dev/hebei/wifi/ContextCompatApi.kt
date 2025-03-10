package dev.hebei.wifi

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.wifi.WifiManager
import androidx.core.content.ContextCompat

class ContextCompatApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiContextCompat(registrar) {
    override fun getWifiManager(context: Context): WifiManager? {
        return ContextCompat.getSystemService(context, WifiManager::class.java)
    }

    override fun registerReceiver(
        context: Context, receiver: BroadcastReceiver, filter: IntentFilter, flags: ReceiverFlags
    ): Intent? {
        return ContextCompat.registerReceiver(context, receiver, filter, flags.obj)
    }
}

val ReceiverFlags.obj: Int
    get() = when (this) {
        ReceiverFlags.EXPORTED -> ContextCompat.RECEIVER_EXPORTED
        ReceiverFlags.NOT_EXPORTED -> ContextCompat.RECEIVER_NOT_EXPORTED
        ReceiverFlags.VISIBLE_TO_INSTANT_APPS -> ContextCompat.RECEIVER_VISIBLE_TO_INSTANT_APPS
    }