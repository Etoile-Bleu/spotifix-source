@echo off
echo ====================================
echo    GENERATION DU KEYSTORE
echo ====================================
echo.

REM Trouver le JDK dans Android Studio ou Java
set JAVA_HOME=
set KEYTOOL_PATH=

REM Essayer différents emplacements de JDK
if exist "E:\ANDROID_SDK\jre\bin\keytool.exe" (
    set KEYTOOL_PATH=E:\ANDROID_SDK\jre\bin\keytool.exe
    echo ✅ JDK trouve dans E:\ANDROID_SDK\jre
) else if exist "E:\ANDROID_SDK\cmdline-tools\latest\bin\keytool.exe" (
    set KEYTOOL_PATH=E:\ANDROID_SDK\cmdline-tools\latest\bin\keytool.exe
    echo ✅ JDK trouve dans E:\ANDROID_SDK\cmdline-tools
) else if exist "%LOCALAPPDATA%\Android\Sdk\jre\bin\keytool.exe" (
    set KEYTOOL_PATH=%LOCALAPPDATA%\Android\Sdk\jre\bin\keytool.exe
    echo ✅ JDK trouve dans Android SDK par defaut
) else if exist "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" (
    set KEYTOOL_PATH=C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe
    echo ✅ JDK trouve dans Android Studio
) else if exist "C:\Program Files\Java\jdk*\bin\keytool.exe" (
    for /d %%i in ("C:\Program Files\Java\jdk*") do set KEYTOOL_PATH=%%i\bin\keytool.exe
    echo ✅ JDK trouve dans Program Files
) else (
    echo ❌ JDK non trouve automatiquement!
    echo.
    echo Emplacements tentes:
    echo - E:\ANDROID_SDK\jre\bin\keytool.exe
    echo - E:\ANDROID_SDK\cmdline-tools\latest\bin\keytool.exe
    echo.
    echo Ou specifiez le chemin manuellement:
    set /p KEYTOOL_PATH="Chemin vers keytool.exe: "
)

if "%KEYTOOL_PATH%"=="" (
    echo ❌ Impossible de continuer sans keytool
    pause
    exit /b 1
)

echo.
set /p ALIAS="Entrez l'alias de la cle (ex: spotify-key): "
set /p PASSWORD="Entrez le mot de passe: "
set /p VALIDITY="Entrez la validite en jours (ex: 10000): "

echo.
echo Generation du keystore avec %KEYTOOL_PATH%...
"%KEYTOOL_PATH%" -genkey -v -keystore spotify-keystore.jks -alias %ALIAS% -keyalg RSA -keysize 2048 -validity %VALIDITY%

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de la generation du keystore
    pause
    exit /b 1
)

echo.
echo Conversion en base64 pour GitHub Secrets...
if exist "spotify-keystore.jks" (
    certutil -encode spotify-keystore.jks keystore-b64.txt
    if %ERRORLEVEL% neq 0 (
        echo ⚠️  Erreur avec certutil, utilisation de PowerShell...
        powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('spotify-keystore.jks')) | Out-File -Encoding ASCII keystore-b64.txt"
    )
) else (
    echo ❌ Fichier keystore non trouve
    pause
    exit /b 1
)

echo.
echo ✅ Keystore genere!
echo.
echo Fichiers crees:
echo - spotify-keystore.jks (garde precieusement)
echo - keystore-b64.txt (copie le contenu dans KEYSTORE_B64)
echo.
echo ⚠️  IMPORTANT: 
echo - Sauvegarde spotify-keystore.jks en lieu sur
echo - Utilise le mot de passe "%PASSWORD%" pour PASSWORD
echo - Utilise "%ALIAS%" comme alias dans les workflows
echo.
pause
