# Flutter & Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep MainActivity
-keep class com.kavery.matrimony.app.MainActivity { *; }

# Keep Parcelable classes
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Gson support (if used)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Firebase (if used)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Play Core (for deferred components / dynamic features)
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

# Fix common R8 reflection issues (optional safety net)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod
