package com.gymbuddy.application

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import com.google.android.material.snackbar.Snackbar
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.ActivityResult
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability
import com.google.android.play.core.review.ReviewManager
import com.google.android.play.core.review.ReviewManagerFactory

/**
 * PlayUpdateReviewManager
 *
 * Senior Android standard manager handling Google Play's official In-App Updates and In-App Reviews.
 * Strictly follows official Google Play Core specifications:
 * - Supports Flexible and Immediate In-App Update flows based on update priority and eligibility.
 * - Shows native Material snackbar upon flexible download completion to restart and install.
 * - Resumes interrupted immediate updates on app foregrounding.
 * - Shows official native In-App Review bottom sheet without any custom dialogs or imitation UIs.
 * - Enforces minimum 15-day cooldown and single-session execution for review requests.
 * - Handles offline state, service absence, and API errors gracefully without crashing.
 */
class PlayUpdateReviewManager(private val activity: Activity) {

    companion object {
        private const val TAG = "PlayUpdateReviewMgr"
        const val REQUEST_CODE_FLEXIBLE_UPDATE = 53001
        const val REQUEST_CODE_IMMEDIATE_UPDATE = 53002
        private const val HIGH_PRIORITY_UPDATE_THRESHOLD = 4
        private const val PREFS_NAME = "samyukt_play_services_prefs"
        private const val KEY_LAST_REVIEW_TIME_MS = "last_review_request_time_ms"
        private const val REVIEW_COOLDOWN_DAYS_MS = 15L * 24 * 60 * 60 * 1000L // 15 days
    }

    private val appUpdateManager: AppUpdateManager by lazy {
        AppUpdateManagerFactory.create(activity)
    }

    private val reviewManager: ReviewManager by lazy {
        ReviewManagerFactory.create(activity)
    }

    private val sharedPreferences: SharedPreferences by lazy {
        activity.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    @Volatile
    private var isUpdateFlowInProgress = false

    @Volatile
    private var hasRequestedReviewInThisSession = false

    private val installStateUpdatedListener = InstallStateUpdatedListener { state ->
        when (state.installStatus()) {
            InstallStatus.DOWNLOADED -> {
                Log.d(TAG, "Flexible update downloaded. Prompting user to restart.")
                isUpdateFlowInProgress = false
                popupSnackbarForCompleteUpdate()
            }
            InstallStatus.DOWNLOADING -> {
                val bytesDownloaded = state.bytesDownloaded()
                val totalBytes = state.totalBytesToDownload()
                Log.d(TAG, "Update downloading: $bytesDownloaded / $totalBytes bytes")
            }
            InstallStatus.FAILED -> {
                Log.e(TAG, "Update installation failed with error code: ${state.installErrorCode()}")
                isUpdateFlowInProgress = false
            }
            InstallStatus.CANCELED -> {
                Log.d(TAG, "Update download canceled by user or system.")
                isUpdateFlowInProgress = false
            }
            else -> {
                Log.d(TAG, "InstallState updated: ${state.installStatus()}")
            }
        }
    }

    init {
        try {
            appUpdateManager.registerListener(installStateUpdatedListener)
        } catch (e: Exception) {
            Log.w(TAG, "Failed to register install listener: ${e.message}")
        }
    }

    // ─────────────────────────────────────────────────────────────
    // IN-APP UPDATES (Official Google Play Core Flow)
    // ─────────────────────────────────────────────────────────────

    /**
     * Checks if an update is available on Google Play and triggers either
     * Immediate or Flexible update flow based on Play priority and flow rules.
     */
    fun checkForUpdate() {
        if (isUpdateFlowInProgress) {
            Log.d(TAG, "Update check skipped: update flow is already in progress.")
            return
        }

        try {
            val appUpdateInfoTask = appUpdateManager.appUpdateInfo
            appUpdateInfoTask.addOnSuccessListener { appUpdateInfo: AppUpdateInfo ->
                val availability = appUpdateInfo.updateAvailability()
                val installStatus = appUpdateInfo.installStatus()

                if (installStatus == InstallStatus.DOWNLOADED) {
                    popupSnackbarForCompleteUpdate()
                    return@addOnSuccessListener
                }

                if (availability == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
                    Log.d(TAG, "Developer-triggered update already in progress; resuming immediate flow.")
                    startImmediateUpdate(appUpdateInfo)
                    return@addOnSuccessListener
                }

                if (availability == UpdateAvailability.UPDATE_AVAILABLE) {
                    val priority = appUpdateInfo.updatePriority()
                    val versionCode = appUpdateInfo.availableVersionCode()
                    Log.d(TAG, "Update available! Priority: $priority, Target VersionCode: $versionCode")

                    // High priority updates (priority >= 4) trigger immediate flow if allowed
                    if (priority >= HIGH_PRIORITY_UPDATE_THRESHOLD && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                        Log.d(TAG, "Starting immediate update due to high priority ($priority).")
                        startImmediateUpdate(appUpdateInfo)
                    } else if (appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)) {
                        Log.d(TAG, "Starting flexible update flow.")
                        startFlexibleUpdate(appUpdateInfo)
                    } else if (appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                        Log.d(TAG, "Flexible not allowed; falling back to immediate update flow.")
                        startImmediateUpdate(appUpdateInfo)
                    } else {
                        Log.d(TAG, "No supported update type allowed by Play Core on this device.")
                    }
                } else {
                    Log.d(TAG, "No update available. Availability status: $availability")
                }
            }.addOnFailureListener { e ->
                Log.w(TAG, "Play in-app update check failed (offline or unresolvable): ${e.message}")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error in checkForUpdate: ${e.message}", e)
        }
    }

    private fun startImmediateUpdate(appUpdateInfo: AppUpdateInfo) {
        try {
            isUpdateFlowInProgress = true
            appUpdateManager.startUpdateFlowForResult(
                appUpdateInfo,
                activity,
                AppUpdateOptions.newBuilder(AppUpdateType.IMMEDIATE).build(),
                REQUEST_CODE_IMMEDIATE_UPDATE
            )
        } catch (e: Exception) {
            isUpdateFlowInProgress = false
            Log.e(TAG, "Error launching immediate update flow: ${e.message}", e)
        }
    }

    private fun startFlexibleUpdate(appUpdateInfo: AppUpdateInfo) {
        try {
            isUpdateFlowInProgress = true
            appUpdateManager.startUpdateFlowForResult(
                appUpdateInfo,
                activity,
                AppUpdateOptions.newBuilder(AppUpdateType.FLEXIBLE).build(),
                REQUEST_CODE_FLEXIBLE_UPDATE
            )
        } catch (e: Exception) {
            isUpdateFlowInProgress = false
            Log.e(TAG, "Error launching flexible update flow: ${e.message}", e)
        }
    }

    /**
     * Native Material Snackbar prompting user to restart the app to complete a flexible update.
     * Uses official appUpdateManager.completeUpdate() call.
     */
    fun popupSnackbarForCompleteUpdate() {
        val rootView = activity.findViewById<android.view.View>(android.R.id.content) ?: return
        Snackbar.make(
            rootView,
            "An update has just been downloaded.",
            Snackbar.LENGTH_INDEFINITE
        ).apply {
            setAction("RESTART") {
                completeUpdate()
            }
            show()
        }
    }

    fun completeUpdate() {
        try {
            appUpdateManager.completeUpdate()
        } catch (e: Exception) {
            Log.e(TAG, "Error executing completeUpdate: ${e.message}", e)
        }
    }

    /**
     * Resumes in-progress updates on activity resume.
     */
    fun onResume() {
        try {
            appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
                if (appUpdateInfo.installStatus() == InstallStatus.DOWNLOADED) {
                    popupSnackbarForCompleteUpdate()
                } else if (appUpdateInfo.updateAvailability() == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
                    startImmediateUpdate(appUpdateInfo)
                }
            }.addOnFailureListener { e ->
                Log.w(TAG, "Play in-app update onResume check failed: ${e.message}")
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error during onResume update check: ${e.message}")
        }
    }

    /**
     * Unregisters the listener to prevent memory leaks.
     */
    fun onDestroy() {
        try {
            appUpdateManager.unregisterListener(installStateUpdatedListener)
        } catch (e: Exception) {
            Log.w(TAG, "Error unregistering install listener: ${e.message}")
        }
    }

    /**
     * Handles Activity result from in-app update dialogs.
     */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_CODE_FLEXIBLE_UPDATE) {
            isUpdateFlowInProgress = false
            when (resultCode) {
                Activity.RESULT_OK -> Log.d(TAG, "User accepted flexible update. Download starting.")
                Activity.RESULT_CANCELED -> Log.d(TAG, "User canceled flexible update.")
                ActivityResult.RESULT_IN_APP_UPDATE_FAILED -> Log.e(TAG, "Flexible in-app update failed.")
                else -> Log.d(TAG, "Flexible update resultCode: $resultCode")
            }
            return true
        } else if (requestCode == REQUEST_CODE_IMMEDIATE_UPDATE) {
            isUpdateFlowInProgress = false
            when (resultCode) {
                Activity.RESULT_OK -> Log.d(TAG, "Immediate update succeeded or was accepted.")
                Activity.RESULT_CANCELED -> Log.d(TAG, "User canceled immediate update.")
                ActivityResult.RESULT_IN_APP_UPDATE_FAILED -> Log.e(TAG, "Immediate update failed.")
                else -> Log.d(TAG, "Immediate update resultCode: $resultCode")
            }
            return true
        }
        return false
    }

    // ─────────────────────────────────────────────────────────────
    // IN-APP REVIEWS (Official Google Play Core Flow)
    // ─────────────────────────────────────────────────────────────

    /**
     * Requests and launches Google Play's native in-app review bottom sheet.
     * Enforces minimum 15-day cooldown and prevents multiple requests in the same session.
     */
    fun requestReview(force: Boolean = false, onComplete: ((Boolean) -> Unit)? = null) {
        if (!force) {
            if (hasRequestedReviewInThisSession) {
                Log.d(TAG, "In-app review skipped: already requested in this session.")
                onComplete?.invoke(false)
                return
            }

            val lastTime = sharedPreferences.getLong(KEY_LAST_REVIEW_TIME_MS, 0L)
            val now = System.currentTimeMillis()
            if (now - lastTime < REVIEW_COOLDOWN_DAYS_MS) {
                val daysLeft = (REVIEW_COOLDOWN_DAYS_MS - (now - lastTime)) / (24 * 60 * 60 * 1000L)
                Log.d(TAG, "In-app review skipped: 15-day cooldown active (~$daysLeft days remaining).")
                onComplete?.invoke(false)
                return
            }
        }

        try {
            val request = reviewManager.requestReviewFlow()
            request.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val reviewInfo = task.result
                    val flow = reviewManager.launchReviewFlow(activity, reviewInfo)
                    flow.addOnCompleteListener { _ ->
                        hasRequestedReviewInThisSession = true
                        sharedPreferences.edit().putLong(KEY_LAST_REVIEW_TIME_MS, System.currentTimeMillis()).apply()
                        Log.d(TAG, "In-app review flow completed.")
                        onComplete?.invoke(true)
                    }
                } else {
                    Log.w(TAG, "In-app review request failed or quota exceeded: ${task.exception?.message}")
                    onComplete?.invoke(false)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error launching in-app review: ${e.message}", e)
            onComplete?.invoke(false)
        }
    }
}
