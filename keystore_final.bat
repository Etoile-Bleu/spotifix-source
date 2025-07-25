@echo off
echo ====================================
echo    KEYSTORE AVEC TON JDK
echo ====================================
echo.

set KEYTOOL_PATH=C:\Program Files\Java\jdk-17.0.5\bin\keytool.exe

if not exist "%KEYTOOL_PATH%" (
    echo ❌ Keytool non trouve: %KEYTOOL_PATH%
    pause
    exit /b 1
)

echo ✅ Keytool trouve: %KEYTOOL_PATH%
echo.

set /p ALIAS="Alias (ex: spotify): "
set /p PASSWORD="Mot de passe: "

echo.
echo Creation du keystore...
"%KEYTOOL_PATH%" -genkey -v -keystore spotify-keystore.jks -alias %ALIAS% -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Spotifix, OU=Dev, O=Spotifix, L=Paris, S=IDF, C=FR" -storepass %PASSWORD% -keypass %PASSWORD%

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de la creation
    pause
    exit /b 1
)

echo.
echo Conversion en base64...
powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('spotify-keystore.jks')) | Out-File -Encoding ASCII keystore-b64.txt"

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de la conversion
    pause
    exit /b 1
)

echo.
echo ✅ KEYSTORE CREE AVEC SUCCES!
echo.
echo 📁 Fichiers crees:
echo - spotify-keystore.jks (garde precieusement!)
echo - keystore-b64.txt (pour GitHub Secrets)
echo.
echo 🔑 Informations:
echo - Password: %PASSWORD%
echo - Alias: %ALIAS%
echo.
echo 📋 PROCHAINE ETAPE:
echo .\setup_secrets.bat
echo.
pause
