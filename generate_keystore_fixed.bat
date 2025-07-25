@echo off
echo ====================================
echo    GENERATION DU KEYSTORE (FIXED)
echo ====================================
echo.

echo Recherche de keytool...

REM Essayer de trouver keytool via JAVA_HOME
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\keytool.exe" (
        set KEYTOOL_CMD="%JAVA_HOME%\bin\keytool.exe"
        echo ✅ Keytool trouve via JAVA_HOME: %JAVA_HOME%\bin\keytool.exe
        goto FOUND
    )
)

REM Essayer de trouver via where java
for /f "tokens=*" %%i in ('where java 2^>nul') do (
    set JAVA_PATH=%%i
    for %%j in ("!JAVA_PATH!") do set JAVA_DIR=%%~dpj
    if exist "!JAVA_DIR!keytool.exe" (
        set KEYTOOL_CMD="!JAVA_DIR!keytool.exe"
        echo ✅ Keytool trouve: !JAVA_DIR!keytool.exe
        goto FOUND
    )
)

REM Chemins typiques pour Oracle JDK/OpenJDK
for %%p in ("C:\Program Files\Java\jdk*\bin\keytool.exe" "C:\Program Files\Eclipse Adoptium\jdk*\bin\keytool.exe" "C:\Program Files\OpenJDK\jdk*\bin\keytool.exe") do (
    for /f %%f in ('dir /b /od "%%p" 2^>nul') do (
        set KEYTOOL_CMD="%%f"
        echo ✅ Keytool trouve: %%f
        goto FOUND
    )
)

REM Android Studio JDK
if exist "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" (
    set KEYTOOL_CMD="C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"
    echo ✅ Keytool trouve dans Android Studio
    goto FOUND
)

echo ❌ Keytool non trouve automatiquement!
echo.
echo Saisie manuelle du chemin:
set /p KEYTOOL_CMD="Chemin complet vers keytool.exe: "
if "%KEYTOOL_CMD%"=="" (
    echo Annule.
    pause
    exit /b 1
)

:FOUND
setlocal enabledelayedexpansion
echo.
set /p ALIAS="Entrez l'alias de la cle (ex: spotifix): "
set /p PASSWORD="Entrez le mot de passe: "
set /p VALIDITY="Entrez la validite en jours (ex: 10000): "

echo.
echo Generation du keystore avec !KEYTOOL_CMD!...
!KEYTOOL_CMD! -genkey -v -keystore spotify-keystore.jks -alias %ALIAS% -keyalg RSA -keysize 2048 -validity %VALIDITY%

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de la generation du keystore
    pause
    exit /b 1
)

echo.
echo Conversion en base64...
if exist "spotify-keystore.jks" (
    powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('spotify-keystore.jks')) | Out-File -Encoding ASCII keystore-b64.txt"
    echo ✅ Conversion reussie!
) else (
    echo ❌ Fichier keystore non trouve
    pause
    exit /b 1
)

echo.
echo ✅ KEYSTORE CREE AVEC SUCCES!
echo.
echo 📁 Fichiers crees:
echo - spotify-keystore.jks (garde precieusement!)
echo - keystore-b64.txt (copie le contenu dans GitHub Secrets)
echo.
echo 🔑 INFORMATIONS IMPORTANTES:
echo - Mot de passe: %PASSWORD%
echo - Alias: %ALIAS%
echo.
echo 📋 LANCE MAINTENANT:
echo .\setup_secrets.bat
echo.
pause
