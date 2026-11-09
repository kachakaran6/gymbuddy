package com.gymbuddy.application

import android.content.Intent
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.gymbuddy.application/play_services"
    private lateinit var playManager: PlayUpdateReviewManager

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        playManager = PlayUpdateReviewManager(this)

        // Automatically check for in-app updates on launch (lifecycle-safe)
        playManager.checkForUpdate()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Expose native Play Core methods to Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkForUpdate" -> {
                    playManager.checkForUpdate()
                    result.success(true)
                }
                "completeUpdate" -> {
                    playManager.completeUpdate()
                    result.success(true)
                }
                "requestReview" -> {
                    val force = call.argument<Boolean>("force") ?: false
                    playManager.requestReview(force) { shown ->
                        result.success(shown)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        // Checks if an update was downloaded and is awaiting install, or resumes an immediate update
        if (::playManager.isInitialized) {
            playManager.onResume()
        }
    }

    override fun onDestroy() {
        if (::playManager.isInitialized) {
            playManager.onDestroy()
        }
        super.onDestroy()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (::playManager.isInitialized) {
            playManager.onActivityResult(requestCode, resultCode, data)
        }
    }
}
