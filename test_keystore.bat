@echo off
echo ====================================
echo    TEST DU KEYSTORE
echo ====================================
echo.

set /p PASSWORD="Entrez le mot de passe du keystore pour test: "

echo.
echo Test du keystore avec le mot de passe fourni...
keytool -list -keystore spotify-keystore.jks -storepass %PASSWORD%

if %ERRORLEVEL% equ 0 (
    echo.
    echo ✅ MOT DE PASSE CORRECT!
    echo.
    echo 📋 Copiez ce mot de passe dans GitHub Secrets:
    echo PASSWORD = %PASSWORD%
    echo.
    echo 📋 Et copiez le contenu de keystore-b64.txt dans:
    echo KEYSTORE_B64 = (contenu du fichier keystore-b64.txt)
) else (
    echo ❌ Mot de passe incorrect, essayez encore
)

echo.
pause
