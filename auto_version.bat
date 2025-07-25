@echo off
echo ====================================
echo    VERSIONING AUTOMATIQUE
echo ====================================
echo.

echo Version actuelle:
for /f "tokens=*" %%i in ('git describe --tags --abbrev=0 2^>nul') do set CURRENT_TAG=%%i

if "%CURRENT_TAG%"=="" (
    set CURRENT_TAG=v0.0.0
    echo Aucun tag trouve, version par defaut: %CURRENT_TAG%
) else (
    echo %CURRENT_TAG%
)

echo.
echo Quel type de mise a jour ?
echo [1] Patch (v1.0.0 → v1.0.1) - Bugfixes
echo [2] Minor (v1.0.0 → v1.1.0) - Nouvelles fonctionnalites
echo [3] Major (v1.0.0 → v2.0.0) - Breaking changes
echo [4] Version personnalisee
echo [5] Annuler
echo.

set /p BUMP_TYPE="Choix (1-5): "

if "%BUMP_TYPE%"=="1" goto PATCH
if "%BUMP_TYPE%"=="2" goto MINOR
if "%BUMP_TYPE%"=="3" goto MAJOR
if "%BUMP_TYPE%"=="4" goto CUSTOM
if "%BUMP_TYPE%"=="5" goto END

echo ❌ Choix invalide
pause
exit /b 1

:PATCH
echo.
echo 🔧 Bump PATCH version...
for /f "tokens=1,2,3 delims=." %%a in ("%CURRENT_TAG:v=%") do (
    set /a NEW_PATCH=%%c+1
    set NEW_VERSION=v%%a.%%b.!NEW_PATCH!
)
goto CREATE_TAG

:MINOR
echo.
echo ✨ Bump MINOR version...
for /f "tokens=1,2,3 delims=." %%a in ("%CURRENT_TAG:v=%") do (
    set /a NEW_MINOR=%%b+1
    set NEW_VERSION=v%%a.!NEW_MINOR!.0
)
goto CREATE_TAG

:MAJOR
echo.
echo 💥 Bump MAJOR version...
for /f "tokens=1,2,3 delims=." %%a in ("%CURRENT_TAG:v=%") do (
    set /a NEW_MAJOR=%%a+1
    set NEW_VERSION=v!NEW_MAJOR!.0.0
)
goto CREATE_TAG

:CUSTOM
echo.
set /p NEW_VERSION="Entrez la nouvelle version (ex: v1.2.3): "
if "%NEW_VERSION%"=="" (
    echo ❌ Version vide, annulation.
    pause
    goto END
)
goto CREATE_TAG

:CREATE_TAG
setlocal enabledelayedexpansion
echo.
echo %CURRENT_TAG% → !NEW_VERSION!
echo.
set /p CONFIRM="Confirmer cette version ? (y/N): "
if /i not "!CONFIRM!"=="y" (
    echo Annule.
    pause
    goto END
)

set /p CHANGELOG="Entrez les changements (optionnel): "

echo.
echo Creation du tag !NEW_VERSION!...

if "!CHANGELOG!"=="" (
    git tag !NEW_VERSION!
) else (
    git tag -a !NEW_VERSION! -m "!CHANGELOG!"
)

echo Push vers GitHub...
git push origin !NEW_VERSION!

echo.
echo ✅ Version !NEW_VERSION! creee et poussee!
echo 🚀 Le workflow stable va se lancer automatiquement
echo.
pause

:END
