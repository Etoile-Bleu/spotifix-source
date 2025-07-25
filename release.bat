@echo off
setlocal enabledelayedexpansion

echo ====================================
echo    GESTION AUTOMATIQUE DES VERSIONS
echo ====================================
echo.

:: Récupérer le dernier tag
for /f "tokens=*" %%i in ('git describe --tags --abbrev=0 2^>nul') do set LAST_TAG=%%i

if "%LAST_TAG%"=="" (
    set LAST_TAG=v0.0.0
    echo Aucun tag trouve, demarrage a v0.0.0
) else (
    echo Dernier tag: %LAST_TAG%
)

:: Extraire les numéros de version
set VERSION=%LAST_TAG:~1%
for /f "tokens=1,2,3 delims=." %%a in ("%VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
    set PATCH=%%c
)

echo.
echo Version actuelle: %MAJOR%.%MINOR%.%PATCH%
echo.
echo Quel type de mise a jour ?
echo 1. PATCH (bug fix) : %MAJOR%.%MINOR%.!NEW_PATCH!
echo 2. MINOR (nouvelle fonctionnalite) : %MAJOR%.!NEW_MINOR!.0
echo 3. MAJOR (breaking change) : !NEW_MAJOR!.0.0
echo 4. Version personnalisee
echo.

set /p CHOICE="Votre choix (1-4): "

if "%CHOICE%"=="1" (
    set /a NEW_PATCH=%PATCH%+1
    set NEW_VERSION=%MAJOR%.%MINOR%.!NEW_PATCH!
) else if "%CHOICE%"=="2" (
    set /a NEW_MINOR=%MINOR%+1
    set NEW_VERSION=%MAJOR%.!NEW_MINOR!.0
) else if "%CHOICE%"=="3" (
    set /a NEW_MAJOR=%MAJOR%+1
    set NEW_VERSION=!NEW_MAJOR!.0.0
) else if "%CHOICE%"=="4" (
    set /p NEW_VERSION="Entrez la version (format: 1.0.0): "
) else (
    echo Choix invalide!
    pause
    exit /b 1
)

set /p RELEASE_NOTES="Notes de version (optionnel): "

echo.
echo ====================================
echo Nouvelle version: v!NEW_VERSION!
echo Notes: %RELEASE_NOTES%
echo ====================================
echo.
set /p CONFIRM="Confirmer ? (y/N): "

if /i not "%CONFIRM%"=="y" (
    echo Annule.
    pause
    exit /b 0
)

echo.
echo Creation du tag v!NEW_VERSION!...

if "%RELEASE_NOTES%"=="" (
    git tag v!NEW_VERSION!
) else (
    git tag -a v!NEW_VERSION! -m "%RELEASE_NOTES%"
)

echo Push du tag...
git push origin v!NEW_VERSION!

echo.
echo ✅ Release v!NEW_VERSION! creee!
echo.
echo La pipeline stable va compiler et distribuer automatiquement.
echo Suit le progres: https://github.com/Etoile-Bleu/spotify-release/actions
echo.
pause
