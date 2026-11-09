# Proguard rules for GymBuddy (Flutter + Android)

# Flutter Engine & Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Native methods and JNI
-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }

# Google Play In-App Update & In-App Review
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.review.** { *; }
-keep class com.google.android.material.snackbar.** { *; }

# Drift & SQLite
-keep class com.simolus3.drift.** { *; }
-keep class sqlite3.** { *; }

# Community Plus Plugins
-keep class dev.fluttercommunity.plus.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }

# AndroidX Edge-To-Edge, Activity & Fragment
-keep class androidx.activity.** { *; }
-keep class androidx.fragment.** { *; }
-keep class androidx.core.view.WindowInsets** { *; }

# Application entry points
-keep class com.gymbuddy.application.** { *; }

# Kotlin Coroutines & Annotations
-dontwarn kotlinx.coroutines.**
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**

# Play Store split install & deferred components (not using dynamic feature modules)
-dontwarn com.google.android.gms.common.annotation.NoNullnessRewrite
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Preserve debugging attributes for Google Play crash reporting
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
