package com.gymbuddy.application

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.google.android.material.snackbar.Snackbar
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability
import com.google.android.play.core.review.ReviewManager
import com.google.android.play.core.review.ReviewManagerFactory

/**
 * PlayUpdateReviewManager
 *
 * Single reusable manager handling Google Play's native In-App Updates and In-App Reviews.
 * Strictly follows Google Play Core guidelines:
 * - Uses Flexible In-App Update flow with background download.
 * - Shows native Play Store snackbar upon download completion to trigger restart.
 * - Shows native In-App Review bottom sheet without any custom dialogs.
 * - Fails silently on review quotas or errors per Google's guidelines.
 *
 * Lifecycle Integration:
 * - Call [checkForUpdate] in Activity.onCreate() or on app launch.
 * - Call [onResume] in Activity.onResume() to check if a downloaded update is pending install.
 * - Call [onDestroy] in Activity.onDestroy() to unregister the install listener.
 * - Call [onActivityResult] in Activity.onActivityResult() to handle update result codes.
 * - Call [requestReview] after a meaningful positive user interaction (e.g. completed workout).
 */
class PlayUpdateReviewManager(private val activity: Activity) {

    companion object {
        private const val TAG = "PlayUpdateReviewMgr"
        const val REQUEST_CODE_FLEXIBLE_UPDATE = 53001
    }

    private val appUpdateManager: AppUpdateManager by lazy {
        AppUpdateManagerFactory.create(activity)
    }

    private val reviewManager: ReviewManager by lazy {
        ReviewManagerFactory.create(activity)
    }

    // Listener tracking download progress of flexible updates
    private val installStateUpdatedListener = InstallStateUpdatedListener { state ->
        when (state.installStatus()) {
            InstallStatus.DOWNLOADED -> {
                Log.d(TAG, "Flexible update downloaded. Prompting user to restart.")
                popupSnackbarForCompleteUpdate()
            }
            InstallStatus.DOWNLOADING -> {
                val bytesDownloaded = state.bytesDownloaded()
                val totalBytes = state.totalBytesToDownload()
                Log.d(TAG, "Update downloading: $bytesDownloaded / $totalBytes bytes")
            }
            InstallStatus.FAILED -> {
                Log.e(TAG, "Update installation failed with error code: ${state.installErrorCode()}")
            }
            InstallStatus.CANCELED -> {
                Log.d(TAG, "Update download canceled by user or system.")
            }
            else -> {
                Log.d(TAG, "InstallState updated: ${state.installStatus()}")
            }
        }
    }

    init {
        // Register listener for update status changes
        appUpdateManager.registerListener(installStateUpdatedListener)
    }

    // ─────────────────────────────────────────────────────────────
    // IN-APP UPDATE (Flexible Flow)
    // ─────────────────────────────────────────────────────────────

    /**
     * Checks if an update is available on Google Play and starts the Flexible download flow.
     * Call this in Activity.onCreate() or when app initializes.
     */
    fun checkForUpdate() {
        val appUpdateInfoTask = appUpdateManager.appUpdateInfo

        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo: AppUpdateInfo ->
            if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)
            ) {
                Log.d(TAG, "Update available (versionCode: ${appUpdateInfo.availableVersionCode()}). Starting flexible update.")
                startFlexibleUpdate(appUpdateInfo)
            } else if (appUpdateInfo.installStatus() == InstallStatus.DOWNLOADED) {
                // Update was already downloaded in a previous session
                popupSnackbarForCompleteUpdate()
            } else {
                Log.d(TAG, "No flexible update available. Availability: ${appUpdateInfo.updateAvailability()}")
            }
        }.addOnFailureListener { e ->
            Log.w(TAG, "Failed to check for in-app updates: ${e.message}")
        }
    }

    private fun startFlexibleUpdate(appUpdateInfo: AppUpdateInfo) {
        try {
            appUpdateManager.startUpdateFlowForResult(
                appUpdateInfo,
                activity,
                AppUpdateOptions.newBuilder(AppUpdateType.FLEXIBLE).build(),
                REQUEST_CODE_FLEXIBLE_UPDATE
            )
        } catch (e: Exception) {
            Log.e(TAG, "Error launching flexible update flow: ${e.message}", e)
        }
    }

    /**
     * Native Google Play completion snackbar prompting user to restart the app.
     * No custom UI — strictly uses native Material Snackbar triggering completeUpdate().
     */
    fun popupSnackbarForCompleteUpdate() {
        val rootView = activity.findViewById<android.view.View>(android.R.id.content) ?: return
        Snackbar.make(
            rootView,
            "An update has just been downloaded.",
            Snackbar.LENGTH_INDEFINITE
        ).apply {
            setAction("RESTART") {
                appUpdateManager.completeUpdate()
            }
            show()
        }
    }

    /**
     * Checks if a downloaded update is waiting to be installed when the user returns to the app.
     * Call this in Activity.onResume().
     */
    fun onResume() {
        appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            if (appUpdateInfo.installStatus() == InstallStatus.DOWNLOADED) {
                popupSnackbarForCompleteUpdate()
            }
        }
    }

    /**
     * Unregisters the listener to prevent memory leaks.
     * Call this in Activity.onDestroy().
     */
    fun onDestroy() {
        try {
            appUpdateManager.unregisterListener(installStateUpdatedListener)
        } catch (e: Exception) {
            Log.w(TAG, "Error unregistering install listener: ${e.message}")
        }
    }

    /**
     * Handles activity results from in-app update prompts.
     * Call this in Activity.onActivityResult().
     */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_CODE_FLEXIBLE_UPDATE) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    Log.d(TAG, "User accepted update request. Download starting.")
                }
                Activity.RESULT_CANCELED -> {
                    Log.d(TAG, "User declined or canceled update.")
                }
                com.google.android.play.core.install.model.ActivityResult.RESULT_IN_APP_UPDATE_FAILED -> {
                    Log.e(TAG, "In-app update failed to start or download.")
                }
                else -> {
                    Log.d(TAG, "In-app update resultCode: $resultCode")
                }
            }
            return true
        }
        return false
    }

    // ─────────────────────────────────────────────────────────────
    // IN-APP REVIEW (Native Bottom Sheet)
    // ─────────────────────────────────────────────────────────────

    /**
     * Requests and launches Google Play's native in-app review bottom sheet prompt.
     *
     * Per Google's official documentation:
     * - Only call this after a meaningful positive user interaction (e.g. logging a workout, hitting a PR).
     * - Do NOT build any custom rating UI, thumbs up/down, or dialogs.
     * - Fails silently if Google Play quota limits the prompt (quota is enforced by Play Store).
     */
    fun requestReview(onComplete: (() -> Unit)? = null) {
        val request = reviewManager.requestReviewFlow()
        request.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val reviewInfo = task.result
                val flow = reviewManager.launchReviewFlow(activity, reviewInfo)
                flow.addOnCompleteListener { _ ->
                    // The flow has finished. The API does not indicate whether the user
                    // reviewed or not, or even whether the dialog was shown.
                    // Continue regular app flow regardless.
                    Log.d(TAG, "In-app review flow completed.")
                    onComplete?.invoke()
                }
            } else {
                // Per Google Play guidelines: do not inform the user or show an error
                Log.w(TAG, "In-app review request failed or quota exceeded: ${task.exception?.message}")
                onComplete?.invoke()
            }
        }
    }
}
