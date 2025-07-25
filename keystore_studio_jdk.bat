@echo off
echo ====================================
echo    KEYSTORE VIA POWERSHELL + JDK
echo ====================================
echo.

echo Recherche du JDK Android Studio...
set STUDIO_JDK=
if exist "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" (
    set STUDIO_JDK=C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe
    echo ✅ JDK Android Studio trouve!
) else (
    echo ❌ JDK Android Studio non trouve.
    echo.
    echo Verifie que Android Studio est installe dans:
    echo C:\Program Files\Android\Android Studio\
    echo.
    pause
    exit /b 1
)

echo.
set /p ALIAS="Alias (ex: spotify): "
set /p PASSWORD="Mot de passe: "

echo.
echo Creation du keystore...
"%STUDIO_JDK%" -genkey -v -keystore spotify-keystore.jks -alias %ALIAS% -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Spotifix, OU=Dev, O=Spotifix, L=Paris, S=IDF, C=FR" -storepass %PASSWORD% -keypass %PASSWORD%

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur
    pause
    exit /b 1
)

echo.
echo Conversion en base64...
powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('spotify-keystore.jks')) | Out-File -Encoding ASCII keystore-b64.txt"

echo.
echo ✅ TERMINE!
echo.
echo 📁 Fichiers:
echo - spotify-keystore.jks
echo - keystore-b64.txt
echo.
echo 🔑 Info:
echo - Password: %PASSWORD%
echo - Alias: %ALIAS%
echo.
echo Lance: .\setup_secrets.bat
pause
