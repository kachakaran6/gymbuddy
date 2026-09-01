package com.gymbuddy.application

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.gymbuddy.application/play_services"
    private lateinit var playManager: PlayUpdateReviewManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        playManager = PlayUpdateReviewManager(this)

        // Automatically check for flexible in-app updates on launch
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
                "requestReview" -> {
                    // Triggers Google Play native in-app review bottom sheet
                    playManager.requestReview {
                        result.success(true)
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
        // Checks if an update was downloaded and is awaiting install
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
