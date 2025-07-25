@echo off
echo ====================================
echo    GENERATION DU KEYSTORE (Simple)
echo ====================================
echo.

@echo off
echo ====================================
echo    GENERATION DU KEYSTORE (Simple)
echo ====================================
echo.

echo Verification de Java...
java -version 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Java non trouve dans le PATH!
    echo.
    echo Solutions:
    echo 1. Installer JDK depuis: https://adoptium.net/
    echo 2. Ou utiliser Android Studio Built-in JDK
    echo.
    set /p JAVA_PATH="Entrez le chemin vers java.exe (ou ENTER pour quitter): "
    if "%JAVA_PATH%"=="" exit /b 1
    set KEYTOOL_CMD="%JAVA_PATH%\..\bin\keytool.exe"
) else (
    echo ✅ Java trouve!
    set KEYTOOL_CMD=keytool
)

echo.
set /p ALIAS="Entrez l'alias de la cle (ex: spotify-key): "
set /p PASSWORD="Entrez le mot de passe: "
set /p VALIDITY="Entrez la validite en jours (ex: 10000): "

echo.
echo Generation du keystore...
%KEYTOOL_CMD% -genkey -v -keystore spotify-keystore.jks -alias %ALIAS% -keyalg RSA -keysize 2048 -validity %VALIDITY%

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
echo 📋 PROCHAINES ETAPES:
echo 1. Copie le contenu de keystore-b64.txt dans le secret KEYSTORE_B64
echo 2. Utilise "%PASSWORD%" pour le secret PASSWORD
echo 3. L'alias "%ALIAS%" est deja configure dans les workflows
echo.
pause
