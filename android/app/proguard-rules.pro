# -------------------------
# LINE SDK keep rules
# -------------------------
-keep class com.linecorp.linesdk.** { *; }
-dontwarn com.linecorp.linesdk.**

# -------------------------
# DataBinding keep rules
# -------------------------
-keep class **.databinding.* { *; }
-keep class **.BR { *; }
