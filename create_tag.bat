@echo off
echo ====================================
echo    CREATION D'UN TAG POUR RELEASE
echo ====================================
echo.

echo Tags existants:
git tag -l | sort -V | tail -5
echo.

echo Que veux-tu faire ?
echo [1] Auto-incrementer (patch: 1.0.0 -> 1.0.1)
echo [2] Auto-incrementer (minor: 1.0.0 -> 1.1.0) 
echo [3] Auto-incrementer (major: 1.0.0 -> 2.0.0)
echo [4] Version manuelle
echo.

set /p CHOICE="Choix (1-4): "

if "%CHOICE%"=="1" goto AUTO_PATCH
if "%CHOICE%"=="2" goto AUTO_MINOR
if "%CHOICE%"=="3" goto AUTO_MAJOR
if "%CHOICE%"=="4" goto MANUAL_VERSION

echo ❌ Choix invalide
pause
exit /b 1

:AUTO_PATCH
echo.
echo 🚀 Auto-increment PATCH (1.0.0 -> 1.0.1)
for /f %%i in ('git tag -l "v*" ^| sort -V ^| tail -1') do set LAST_TAG=%%i
if "%LAST_TAG%"=="" (
    set NEW_VERSION=1.0.0
) else (
    call :increment_patch %LAST_TAG:v=%
)
goto CREATE_TAG

:AUTO_MINOR
echo.
echo 🚀 Auto-increment MINOR (1.0.0 -> 1.1.0)
for /f %%i in ('git tag -l "v*" ^| sort -V ^| tail -1') do set LAST_TAG=%%i
if "%LAST_TAG%"=="" (
    set NEW_VERSION=1.0.0
) else (
    call :increment_minor %LAST_TAG:v=%
)
goto CREATE_TAG

:AUTO_MAJOR
echo.
echo 🚀 Auto-increment MAJOR (1.0.0 -> 2.0.0)
for /f %%i in ('git tag -l "v*" ^| sort -V ^| tail -1') do set LAST_TAG=%%i
if "%LAST_TAG%"=="" (
    set NEW_VERSION=1.0.0
) else (
    call :increment_major %LAST_TAG:v=%
)
goto CREATE_TAG

:MANUAL_VERSION
echo.
set /p NEW_VERSION="Entrez le numero de version (ex: 1.0.0): "
goto CREATE_TAG

:increment_patch
for /f "tokens=1,2,3 delims=." %%a in ("%1") do (
    set /a PATCH=%%c+1
    set NEW_VERSION=%%a.%%b.%PATCH%
)
exit /b

:increment_minor
for /f "tokens=1,2,3 delims=." %%a in ("%1") do (
    set /a MINOR=%%b+1
    set NEW_VERSION=%%a.%MINOR%.0
)
exit /b

:increment_major
for /f "tokens=1,2,3 delims=." %%a in ("%1") do (
    set /a MAJOR=%%a+1
    set NEW_VERSION=%MAJOR%.0.0
)
exit /b

:CREATE_TAG
echo.
echo 📦 Nouvelle version: v%NEW_VERSION%
set /p MESSAGE="Message pour la release (optionnel): "

echo.
echo Creation du tag v%NEW_VERSION%...

if "%MESSAGE%"=="" (
    git tag v%NEW_VERSION%
) else (
    git tag -a v%NEW_VERSION% -m "%MESSAGE%"
)

echo.
echo Push du tag vers GitHub...
git push origin v%NEW_VERSION%

echo.
echo ✅ Tag v%NEW_VERSION% cree et pousse!
echo.
echo La pipeline stable va se declencher automatiquement.
echo Verifie ici: https://github.com/Etoile-Bleu/spotifix-source/actions
echo.
pause
