# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# keep NFC
-keep public class org.jmrtd.* {
<fields>;
<methods>;
}
-dontwarn org.jmrtd.*
-keepattributes Exceptions, Signature, InnerClasses
-keep class org.jmrtd.JMRTDSecurityProvider**
-keepclassmembers class org.jmrtd.JMRTDSecurityProvider** {
*;
}
-keep public class org.spongycastle.* {
<fields>;
<methods>;
}
-dontwarn org.spongycastle.*
-keepattributes Exceptions, Signature, InnerClasses
-keep public class net.sf.scuba.* {
<fields>;
<methods>;
*;
}
-dontwarn net.sf.scuba.*
-keepattributes Exceptions, Signature, InnerClasses
-keep public class org.ejbca.* {
<fields>;
<methods>;
}
-dontwarn org.ejbca.*
-keepattributes Exceptions, Signature, InnerClasses
-keep class org.bouncycastle.** {*;}
# MRZ
-keep public class org.slf4j.* {
<fields>;
<methods>;
}
-dontwarn org.slf4j.*
-keepattributes Exceptions, Signature, InnerClasses
-keep public class cz.adaptech.android.* {
<fields>;
<methods>;
}
-dontwarn cz.adaptech.android.*
-keepattributes Exceptions, Signature, InnerClasses
# end MRZ

-dontwarn net.sf.scuba.*
-keepattributes Exceptions, Signature, InnerClasses
-keep class net.sf.scuba.smartcards.IsoDepCardService**
-keepclassmembers class net.sf.scuba.smartcards.IsoDepCardService** {
*;
}

-keep public class org.jmrtd.* {
  <fields>;
  <methods>;
}
-dontwarn org.jmrtd.*
-keepattributes Exceptions, Signature, InnerClasses
-keep class org.jmrtd.JMRTDSecurityProvider**
-keepclassmembers class org.jmrtd.JMRTDSecurityProvider** {
    *;
}

-keep public class org.spongycastle.* {
  <fields>;
  <methods>;
}
-dontwarn org.spongycastle.*
-keepattributes Exceptions, Signature, InnerClasses


-keep public class org.ejbca.* {
  <fields>;
  <methods>;
}
-dontwarn org.ejbca.*
-keepattributes Exceptions, Signature, InnerClasses

-keep class org.bouncycastle.** {*;}

##---------------Begin: proguard configuration for Gson  ----------
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
#-keep class com.google.gson.stream.** { *; }

# Application classes that will be serialized/deserialized over Gson
-keep class com.google.gson.examples.android.model.** { <fields>; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
 @com.google.gson.annotations.SerializedName <fields>;
}

##---------------End: proguard configuration for Gson  ----------
