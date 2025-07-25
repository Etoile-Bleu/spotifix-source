@echo off
echo ====================================
echo    CONFIGURATION DES SECRETS GITHUB
echo ====================================
echo.

echo 🔗 Ouvre cette URL dans ton navigateur:
echo https://github.com/Etoile-Bleu/spotify-release/settings/secrets/actions
echo.

if exist "keystore-b64.txt" (
    echo 📋 Contenu pour KEYSTORE_B64:
    echo ----------------------------------------
    type keystore-b64.txt
    echo ----------------------------------------
    echo.
) else (
    echo ❌ Fichier keystore-b64.txt non trouve!
    echo Lance d'abord generate_keystore_simple.bat
    pause
    exit /b 1
)

echo 🔑 Secrets a ajouter:
echo.
echo Name: KEYSTORE_B64
echo Value: [Copie le contenu ci-dessus]
echo.
echo Name: PASSWORD  
echo Value: bozo
echo.
echo ⚠️  IMPORTANT: Copie exactement le contenu (sans espaces en plus)
echo.

echo 🚀 Une fois les secrets configures, tu peux tester:
echo .\test_pipeline.bat
echo.
pause
