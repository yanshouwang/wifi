package dev.hebei.wifi

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BroadcastReceiverImpl(private val callback: Callback) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        callback.onReceive(context, intent)
    }

    interface Callback {
        fun onReceive(context: Context, intent: Intent)
    }
}