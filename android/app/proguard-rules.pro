# Flutter related rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.** { *; }
-keepclassmembers class * {
    @io.flutter.embedding.android.FlutterActivity *;
    @io.flutter.embedding.engine.FlutterEngine *;
    @io.flutter.embedding.engine.plugins.activity.ActivityAware *;
    @io.flutter.embedding.engine.plugins.broadcastreceiver.BroadcastReceiverAware *;
    @io.flutter.embedding.engine.plugins.contentprovider.ContentProviderAware *;
    @io.flutter.embedding.engine.plugins.service.ServiceAware *;
    @io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry *;
    @io.flutter.plugin.common.PluginRegistry$Registrar *;
}

# Ensure that the Flutter framework's necessary classes and methods are kept
-keep class io.flutter.** { *; }

# Keeping the names of methods and classes that are accessed via reflection
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
    @org.xwalk.core.JavascriptInterface <methods>;
}
-keepclassmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}
