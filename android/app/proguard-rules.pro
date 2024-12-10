# Flutter-specific ProGuard rules

# Flutter apps use reflection to perform many operations including:
# Looking up classes on startup (e.g., by class name string)
# Finding method and field indices
# Invoking methods and accessing fields using the above method/field indices
# So Flutter apps need to avoid obfuscation/minification entirely for reflection.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }

# Add any other custom ProGuard rules you need for your Flutter project here

-verbose
-optimizationpasses 14
-allowaccessmodification
-overloadaggressively
-flattenpackagehierarchy
-keeppackagenames doNotKeepAThing

-obfuscationdictionary dictionary.txt
-classobfuscationdictionary classdictionary.txt

# *******************************************************************************************************
-keep class * { native <methods>; }
-keep class androidx.core.app.** { public *; }
-keep class com.google.android.** { *; }
-keep class com.google.mlkit.** { *; }
-keep class net.zetetic.** { *; }
-keep interface com.google.android.** { *; }

-keep public class javax.mail.** { *; }
-keep public class com.sun.mail.** { *; }
-keep public class org.apache.harmony.** { *; }

# *******************************************************************************************************
-keep class net.sqlcipher.** { *; }
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** { **[] $VALUES; public *; }

# ************************************
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }