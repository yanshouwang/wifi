package dev.hebei.wifi

import android.content.Intent
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

object ActivityX : RequestPermissionsResultListener, ActivityResultListener {
    private val rprListeners = mutableListOf<RequestPermissionsResultListener>()
    private val arListeners = mutableListOf<ActivityResultListener>()

    private var binding: ActivityPluginBinding? = null

    internal fun onAttachedToActivity(binding: ActivityPluginBinding) {
        onDetachedFromActivity()
        binding.addRequestPermissionsResultListener(this)
        binding.addActivityResultListener(this)
        this.binding = binding
    }

    internal fun onDetachedFromActivity() {
        val binding = this.binding ?: return
        binding.removeRequestPermissionsResultListener(this)
        binding.removeActivityResultListener(this)
        this.binding = null
    }

    fun addRequestPermissionsResultListener(listener: RequestPermissionsResultListener) {
        rprListeners.add(listener)
    }

    fun removeRequestPermissionsResultListener(listener: RequestPermissionsResultListener) {
        rprListeners.remove(listener)
    }

    fun addActivityResultListener(listener: ActivityResultListener) {
        arListeners.add(listener)
    }

    fun removeActivityResultListener(listener: ActivityResultListener) {
        arListeners.remove(listener)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        return rprListeners.map {
            it.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }.any { it }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return arListeners.map { it.onActivityResult(resultCode, resultCode, data) }.any { it }
    }
}