package com.delgendy.com.flutter_dynamic_app_icon

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "dynamic_icon"
    private val packagePrefix = "com.delgendy.com.flutter_dynamic_app_icon"

    // All launcher aliases. MainActivity itself is disabled in the manifest and
    // never touched at runtime — only these aliases are enabled/disabled.
    private val aliases = listOf("DayIcon", "NightIcon")

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setIcon" -> {
                        val iconName = call.argument<String>("icon")
                        if (iconName == null) {
                            result.error("INVALID_ARGUMENT", "Icon name is required", null)
                            return@setMethodCallHandler
                        }
                        setIcon(iconName)
                        result.success(null)
                    }
                    "getIcon" -> result.success(getActiveIcon())
                    else -> result.notImplemented()
                }
            }
    }

    private fun getActiveIcon(): String {
        val pm = applicationContext.packageManager
        for (alias in aliases) {
            val component = ComponentName(applicationContext, "$packagePrefix.$alias")
            if (pm.getComponentEnabledSetting(component) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
                return alias
            }
        }
        // Fresh install: neither alias has been touched by PackageManager yet.
        // DayIcon is enabled=true in the manifest, so it is the active one.
        return "DayIcon"
    }

    private fun setIcon(targetAlias: String) {
        val pm = applicationContext.packageManager
        for (alias in aliases) {
            val component = ComponentName(applicationContext, "$packagePrefix.$alias")
            val state = if (alias == targetAlias)
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED

            pm.setComponentEnabledSetting(component, state, PackageManager.DONT_KILL_APP)
        }
    }
}
