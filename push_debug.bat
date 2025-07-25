@echo off
echo ====================================
echo    COMPILATION ET INSTALLATION DEBUG
echo ====================================
echo.

echo [1/2] Compilation de l'application en mode debug...
echo.
call .\gradlew.bat assembleDebug

if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ ERREUR: La compilation a echoue!
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Compilation reussie!
echo.

echo [2/2] Installation de l'APK sur le device...
echo.
E:\ANDROID_SDK\platform-tools\adb.exe install "E:\Spotifix\app\build\outputs\apk\debug\app-debug.apk"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ ERREUR: L'installation a echoue!
    echo Verifiez que:
    echo - Un device Android est connecte
    echo - Le debogage USB est active
    echo - Les pilotes ADB sont installes
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Installation reussie!
echo L'application debug a ete installee sur votre device.
echo.
pause
