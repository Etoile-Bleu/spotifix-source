@echo off
echo ====================================
echo    VERIFICATION GITIGNORE
echo ====================================
echo.

echo Verification des fichiers sensibles...
echo.

if exist "*.jks" (
    echo ⚠️  ATTENTION: Fichiers .jks detectes!
    dir *.jks
    echo.
)

if exist "keystore-b64.txt" (
    echo ⚠️  ATTENTION: keystore-b64.txt detecte!
    echo Ce fichier contient des donnees sensibles.
    echo.
)

if exist "*.apk" (
    echo ℹ️  Fichiers APK detectes (ok si local):
    dir *.apk
    echo.
)

echo Verification du statut Git...
git status --porcelain

echo.
echo ✅ Verification terminee!
echo.
echo 📋 RAPPEL: Ne jamais commiter:
echo - *.jks (keystores)
echo - keystore-b64.txt (secrets)
echo - *.apk (binaires)
echo.
echo 🚀 Si tout est bon, tu peux maintenant tester:
echo .\test_pipeline.bat
echo.
pause
