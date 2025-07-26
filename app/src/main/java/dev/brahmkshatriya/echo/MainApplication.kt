package dev.brahmkshatriya.echo

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import android.os.Looper
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat
import coil3.ImageLoader
import coil3.PlatformContext
import coil3.SingletonImageLoader
import coil3.disk.DiskCache
import coil3.disk.directory
import coil3.memory.MemoryCache
import coil3.request.allowHardware
import coil3.request.crossfade
import dev.brahmkshatriya.echo.di.DI
import dev.brahmkshatriya.echo.extensions.ExtensionLoader
import dev.brahmkshatriya.echo.utils.AppShortcuts.configureAppShortcuts
import dev.brahmkshatriya.echo.utils.CoroutineUtils
import dev.brahmkshatriya.echo.utils.ExtensionDataManager
import androidx.preference.PreferenceManager
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.koin.android.ext.android.inject
import org.koin.android.ext.koin.androidContext
import org.koin.androidx.workmanager.koin.workManagerFactory
import org.koin.androix.startup.KoinStartup
import org.koin.core.annotation.KoinExperimentalAPI
import org.koin.dsl.koinConfiguration

@OptIn(KoinExperimentalAPI::class)
class MainApplication : Application(), KoinStartup, SingletonImageLoader.Factory {

    override fun onKoinStartup() = koinConfiguration {
        androidContext(this@MainApplication)
        modules(DI.appModule)
        workManagerFactory()
    }
    private val extensionLoader by inject<ExtensionLoader>()

    override fun onCreate() {
        super.onCreate()
        CoroutineUtils.setDebug()
        setDefaultPreferences()
        restoreExtensionDataIfNeeded()
        configureAppShortcuts(extensionLoader)
    }
    private fun setDefaultPreferences() {
        val preferences = getSharedPreferences("settings", Context.MODE_PRIVATE)
        if (!preferences.contains("first_run")) {
            preferences.edit().apply {
                putBoolean("disable_all_updates", true)
                putBoolean("first_run", false)
                apply()
            }
        }
    }

    private fun restoreExtensionDataIfNeeded() {
        GlobalScope.launch {
            try {
                if (ExtensionDataManager.hasRecentBackup(this@MainApplication)) {
                    ExtensionDataManager.restoreAllExtensionData(this@MainApplication)
                }
                ExtensionDataManager.startPeriodicBackup(this@MainApplication)
                
            } catch (e: Exception) {
                println("⚠️ Erreur lors de la restauration automatique: ${e.message}")
            }
        }
    }

    override fun newImageLoader(context: PlatformContext): ImageLoader {
        return ImageLoader.Builder(context)
            .memoryCache {
                MemoryCache.Builder()
                    .maxSizePercent(context, 0.25)
                    .build()
            }
            .diskCache {
                DiskCache.Builder()
                    .directory(cacheDir.resolve("image_cache"))
                    .maxSizeBytes(1024 * 1024 * 100) // 100MB
                    .build()
            }
            .allowHardware(false)
            .crossfade(true)
            .build()
    }

    override fun getPackageName(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) runCatching {
            val stackTrace = Looper.getMainLooper().thread.stackTrace
            val isChromiumCall = stackTrace.any { trace ->
                trace.className.equals(CLASS_NAME, ignoreCase = true)
                        && FUNCTION_SET.any { trace.methodName.equals(it, ignoreCase = true) }
            }
            if (isChromiumCall) return spoofedPackageName(applicationContext)
        }
        return super.getPackageName()
    }

    override fun onTerminate() {
        super.onTerminate()
        GlobalScope.launch {
            try {
                ExtensionDataManager.stopPeriodicBackup()
                ExtensionDataManager.backupAllExtensionData(this@MainApplication)
            } catch (e: Exception) {
            }
        }
    }

    private fun spoofedPackageName(context: Context): String {
        return runCatching {
            context.packageManager.getPackageInfo(CHROME_PACKAGE, PackageManager.GET_META_DATA)
            CHROME_PACKAGE
        }.getOrElse {
            SYSTEM_SETTINGS_PACKAGE
        }
    }

    companion object {
        private const val CHROME_PACKAGE = "com.android.chrome"
        private const val SYSTEM_SETTINGS_PACKAGE = "com.android.settings"
        private const val CLASS_NAME = "org.chromium.base.BuildInfo"
        private val FUNCTION_SET = setOf("getAll", "getPackageName", "<init>")

        fun applyLocale(sharedPref: SharedPreferences) {
            val value = sharedPref.getString("language", "system") ?: "system"
            val locale = if (value == "system") LocaleListCompat.getEmptyLocaleList()
            else LocaleListCompat.forLanguageTags(value)
            AppCompatDelegate.setApplicationLocales(locale)
        }
    }
}
