package dev.brahmkshatriya.echo.utils

import android.content.Context
import android.content.SharedPreferences
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.File
import java.util.concurrent.atomic.AtomicBoolean

@Serializable
data class ExtensionData(
    val extensionId: String,
    val preferences: Map<String, String>
)

@Serializable
data class ExtensionBackup(
    val timestamp: Long,
    val appVersion: String,
    val extensions: List<ExtensionData>
)

object ExtensionDataManager {
    
    private const val BACKUP_FILE_NAME = "extensions_backup.json"
    private const val EXTENSION_PREFS_PREFIX = "extension_"
    private const val BACKUP_INTERVAL_MS = 30 * 60 * 1000L // 30 minutes
    
    private val json = Json {
        ignoreUnknownKeys = true
        encodeDefaults = true
    }
    
    private val isBackupRunning = AtomicBoolean(false)
    
    suspend fun startPeriodicBackup(context: Context) {
        if (isBackupRunning.compareAndSet(false, true)) {
            while (isBackupRunning.get()) {
                try {
                    backupAllExtensionData(context)
                    delay(BACKUP_INTERVAL_MS)
                } catch (e: Exception) {
                    delay(BACKUP_INTERVAL_MS)
                }
            }
        }
    }
    fun stopPeriodicBackup() {
        isBackupRunning.set(false)
    }
    suspend fun backupAllExtensionData(context: Context) = withContext(Dispatchers.IO) {
        try {
            val extensionsData = mutableListOf<ExtensionData>()
            val prefsDir = File(context.applicationInfo.dataDir, "shared_prefs")
            if (prefsDir.exists()) {
                prefsDir.listFiles()?.forEach { file ->
                    if (file.name.startsWith(EXTENSION_PREFS_PREFIX) && file.name.endsWith(".xml")) {
                        val extensionId = file.name
                            .removePrefix(EXTENSION_PREFS_PREFIX)
                            .removeSuffix(".xml")
                        
                        val prefs = context.getSharedPreferences("extension_$extensionId", Context.MODE_PRIVATE)
                        val prefsMap = getAllPreferences(prefs)
                        
                        if (prefsMap.isNotEmpty()) {
                            extensionsData.add(ExtensionData(extensionId, prefsMap))
                        }
                    }
                }
            }
            val backup = ExtensionBackup(
                timestamp = System.currentTimeMillis(),
                appVersion = getAppVersion(context),
                extensions = extensionsData
            )
            val backupFile = File(context.filesDir, BACKUP_FILE_NAME)
            backupFile.writeText(json.encodeToString(backup))
            
            println("✅ Sauvegarde automatique des extensions réussie: ${extensionsData.size} extensions")
            
        } catch (e: Exception) {
            println("❌ Erreur lors de la sauvegarde des extensions: ${e.message}")
        }
    }
    suspend fun restoreAllExtensionData(context: Context) = withContext(Dispatchers.IO) {
        try {
            val backupFile = File(context.filesDir, BACKUP_FILE_NAME)
            if (!backupFile.exists()) {
                println("ℹ️ Aucune sauvegarde d'extensions trouvée")
                return@withContext
            }
            
            val backupJson = backupFile.readText()
            val backup = json.decodeFromString<ExtensionBackup>(backupJson)
            
            var restoredCount = 0
            backup.extensions.forEach { extensionData ->
                try {
                    val prefs = context.getSharedPreferences("extension_${extensionData.extensionId}", Context.MODE_PRIVATE)
                    val editor = prefs.edit()
                    
                    extensionData.preferences.forEach { (key, value) ->
                        when {
                            value == "true" || value == "false" -> editor.putBoolean(key, value.toBoolean())
                            value.toLongOrNull() != null -> editor.putLong(key, value.toLong())
                            value.toIntOrNull() != null -> editor.putInt(key, value.toInt())
                            value.toFloatOrNull() != null -> editor.putFloat(key, value.toFloat())
                            else -> editor.putString(key, value)
                        }
                    }
                    
                    editor.apply()
                    restoredCount++
                    
                } catch (e: Exception) {
                    println("❌ Erreur lors de la restauration de l'extension ${extensionData.extensionId}: ${e.message}")
                }
            }
            
            println("✅ Restauration automatique réussie: $restoredCount/${backup.extensions.size} extensions restaurées")
            
        } catch (e: Exception) {
            println("❌ Erreur lors de la restauration des extensions: ${e.message}")
        }
    }
    fun hasRecentBackup(context: Context): Boolean {
        val backupFile = File(context.filesDir, BACKUP_FILE_NAME)
        if (!backupFile.exists()) return false
        
        try {
            val backup = json.decodeFromString<ExtensionBackup>(backupFile.readText())
            val daysSinceBackup = (System.currentTimeMillis() - backup.timestamp) / (1000 * 60 * 60 * 24)
            return daysSinceBackup < 7 
        } catch (e: Exception) {
            return false
        }
    }
    
    private fun getAllPreferences(prefs: SharedPreferences): Map<String, String> {
        val result = mutableMapOf<String, String>()
        
        prefs.all.forEach { (key, value) ->
            when (value) {
                is String -> result[key] = value
                is Boolean -> result[key] = value.toString()
                is Int -> result[key] = value.toString()
                is Long -> result[key] = value.toString()
                is Float -> result[key] = value.toString()
                is Set<*> -> {
                    try {
                        @Suppress("UNCHECKED_CAST")
                        val stringSet = value as Set<String>
                        result[key] = json.encodeToString(stringSet.toList())
                    } catch (e: Exception) {
                    }
                }
            }
        }
        
        return result
    }
    
    private fun getAppVersion(context: Context): String {
        return try {
            val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
            packageInfo.versionName ?: "unknown"
        } catch (e: Exception) {
            "unknown"
        }
    }
}
