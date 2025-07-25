@echo off
echo ====================================
echo    TEST DE LA PIPELINE
echo ====================================
echo.

echo Que veux-tu tester ?
echo [1] Nightly build (push sur master)
echo [2] Stable release (creation d'un tag)
echo [3] Voir l'etat de la pipeline
echo [4] Quitter
echo.

set /p CHOICE="Choix (1-4): "

if "%CHOICE%"=="1" goto TEST_NIGHTLY
if "%CHOICE%"=="2" goto TEST_STABLE
if "%CHOICE%"=="3" goto CHECK_PIPELINE
if "%CHOICE%"=="4" goto END

echo ❌ Choix invalide
pause
exit /b 1

:TEST_NIGHTLY
echo.
echo 🌙 Test du build nightly...
echo.
echo Ajout et commit des changements...
git add .
git status
echo.
set /p COMMIT_MSG="Message de commit (optionnel): "

if "%COMMIT_MSG%"=="" (
    git commit -m "Test nightly build - %date% %time%"
) else (
    git commit -m "%COMMIT_MSG%"
)

echo.
echo Push vers master...
git push origin master

echo.
echo ✅ Push effectue!
echo 🚀 Le nightly build va se lancer automatiquement
goto CHECK_PIPELINE

:TEST_STABLE
echo.
echo 🚀 Test du build stable...
echo Cela va creer un nouveau tag et declencher une release.
echo.
set /p CONFIRM="Confirmer ? (y/N): "
if /i not "%CONFIRM%"=="y" (
    echo Annule.
    pause
    goto END
)

call create_tag.bat
goto END

:CHECK_PIPELINE
echo.
echo 📊 Etat de la pipeline:
echo.
echo 🔗 GitHub Actions: https://github.com/Etoile-Bleu/spotifix-source/actions
echo 🔗 Releases: https://github.com/Etoile-Bleu/spotifix-source/releases
echo.
echo ⏳ Les builds prennent environ 5-10 minutes
echo 📱 Verifie GitHub Actions pour voir le progres
echo.
pause
goto END

:END
