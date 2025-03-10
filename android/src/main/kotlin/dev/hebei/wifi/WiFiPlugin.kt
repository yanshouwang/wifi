package dev.hebei.wifi

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** WifiPlugin */
class WifiPlugin : FlutterPlugin {
    private lateinit var applicationContext: Context
    private lateinit var registrar: WifiPigeonProxyApiRegistrar

    val context: Context get() = applicationContext

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        registrar = WifiRegistrar(binding.binaryMessenger, this)
        registrar.setUp()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        registrar.tearDown()
        registrar.instanceManager.stopFinalizationListener()
    }
}
