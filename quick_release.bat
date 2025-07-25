@echo off
echo ====================================
echo    RELEASE RAPIDE (AUTO-INCREMENT)
echo ====================================
echo.

echo Derniere version:
for /f %%i in ('git tag -l "v*" ^| sort -V ^| tail -1') do set LAST_TAG=%%i
echo %LAST_TAG%

echo.
echo 🚀 Auto-increment PATCH: %LAST_TAG% -> 
for /f "tokens=1,2,3 delims=." %%a in ("%LAST_TAG:v=%") do (
    set /a PATCH=%%c+1
    set NEW_VERSION=%%a.%%b.%PATCH%
)
echo v%NEW_VERSION%

echo.
set /p CONFIRM="Confirmer la release v%NEW_VERSION% ? (y/N): "
if /i not "%CONFIRM%"=="y" (
    echo Annule.
    pause
    exit /b 1
)

echo.
echo Creation et push du tag v%NEW_VERSION%...
git tag v%NEW_VERSION%
git push origin v%NEW_VERSION%

echo.
echo ✅ Release v%NEW_VERSION% lancee!
echo 🚀 Pipeline en cours...
echo 🔗 https://github.com/Etoile-Bleu/spotifix-source/actions
echo.
pause
