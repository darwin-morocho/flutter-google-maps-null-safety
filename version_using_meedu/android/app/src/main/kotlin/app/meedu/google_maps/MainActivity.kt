package app.meedu.google_maps

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL_NAME = "app.meedu/background-location"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME
        )

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val intent = Intent(this, MyForegroundService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                }
                "stop" -> {
                    stop()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

    }


    private fun stop() {
        val intent = Intent(this, MyForegroundService::class.java)
        stopService(intent)
    }


    override fun onDestroy() {
        stop()
        super.onDestroy()
    }
}
