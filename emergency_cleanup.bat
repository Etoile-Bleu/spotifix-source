@echo off
echo ====================================
echo    SUPPRESSION FICHIERS SENSIBLES
echo ====================================
echo.

echo ⚠️  SUPPRESSION IMMEDIATE DES FICHIERS SENSIBLES!
echo.

echo Suppression des fichiers du repo...
git rm --cached keystore-b64.txt
git rm --cached spotify-keystore.jks

echo.
echo Suppression des fichiers locaux sensibles...
if exist "keystore-b64.txt" del "keystore-b64.txt"
if exist "spotify-keystore.jks" del "spotify-keystore.jks"

echo.
echo Commit de suppression...
git add .gitignore
git commit -m "🚨 URGENT: Remove leaked secrets and keystore files"

echo.
echo Push de la suppression...
git push origin master

echo.
echo ✅ FICHIERS SENSIBLES SUPPRIMES!
echo.
echo ⚠️  IMPORTANT: Tes secrets ont ete exposes publiquement!
echo Tu dois CHANGER:
echo 1. Regenerer un nouveau keystore
echo 2. Mettre a jour les secrets GitHub
echo 3. Supprimer l'ancien keystore des secrets GitHub
echo.
echo 🔧 Lance ensuite: .\generate_keystore_final.bat
echo.
pause
