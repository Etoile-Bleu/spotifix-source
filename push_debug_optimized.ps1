# Script PowerShell optimisé pour build et install debug
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "   COMPILATION DEBUG OPTIMISÉE" -ForegroundColor Cyan  
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/2] Compilation de l'application en mode debug..." -ForegroundColor Yellow
Write-Host ""

# Variables d'optimisation Gradle
$env:GRADLE_OPTS = "-Xmx4g -XX:+UseParallelGC -XX:MaxMetaspaceSize=1g"

# Build avec optimisations
try {
    & .\gradlew.bat assembleDebug `
        --parallel `
        --build-cache `
        --configuration-cache `
        --daemon `
        "-Dorg.gradle.jvmargs=-Xmx4g -XX:+UseParallelGC" `
        "-Dkotlin.incremental=true" `
        "-Dkotlin.compiler.execution.strategy=in-process"
    
    if ($LASTEXITCODE -ne 0) {
        throw "Gradle build failed"
    }
    
    Write-Host ""
    Write-Host "✅ Compilation réussie!" -ForegroundColor Green
    
    # Trouver l'APK debug
    $apkPath = Get-ChildItem -Path "app\build\outputs\apk\debug" -Filter "*.apk" | Select-Object -First 1 -ExpandProperty FullName
    
    if (-not $apkPath) {
        Write-Host "❌ ERREUR: APK non trouvé!" -ForegroundColor Red
        pause
        exit 1
    }
    
    Write-Host "[2/2] Installation sur l'appareil..." -ForegroundColor Yellow
    Write-Host ""
    
    # Vérifier si ADB est disponible
    $adbPath = Get-Command adb -ErrorAction SilentlyContinue
    if (-not $adbPath) {
        Write-Host "❌ ERREUR: ADB non trouvé dans le PATH!" -ForegroundColor Red
        Write-Host "Veuillez installer Android SDK Platform Tools" -ForegroundColor Yellow
        pause
        exit 1
    }
    
    # Vérifier si un appareil est connecté
    $devices = & adb devices
    $deviceCount = ($devices | Select-String "device$").Count
    
    if ($deviceCount -eq 0) {
        Write-Host "❌ ERREUR: Aucun appareil Android détecté!" -ForegroundColor Red
        Write-Host "Veuillez connecter votre appareil ou démarrer un émulateur" -ForegroundColor Yellow
        pause
        exit 1
    }
    
    Write-Host "📱 Appareil(s) détecté(s): $deviceCount" -ForegroundColor Green
    
    # Installation
    & adb install -r $apkPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "🎉 SUCCÈS: Application installée et prête!" -ForegroundColor Green
        Write-Host "📱 Vous pouvez maintenant lancer Spotifix sur votre appareil" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "❌ ERREUR: Échec de l'installation ADB" -ForegroundColor Red
    }
    
} catch {
    Write-Host ""
    Write-Host "❌ ERREUR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
Write-Host "Appuyez sur une touche pour continuer..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
