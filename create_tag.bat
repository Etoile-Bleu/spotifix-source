@echo off
echo ====================================
echo    CREATION D'UN TAG POUR RELEASE
echo ====================================
echo.

echo Tags existants:
git tag -l
echo.

set /p VERSION="Entrez le numero de version (ex: 1.0.0): "
set /p MESSAGE="Entrez un message pour la release (optionnel): "

echo.
echo Creation du tag v%VERSION%...

if "%MESSAGE%"=="" (
    git tag v%VERSION%
) else (
    git tag -a v%VERSION% -m "%MESSAGE%"
)

echo.
echo Push du tag vers GitHub...
git push origin v%VERSION%

echo.
echo ✅ Tag v%VERSION% cree et pousse!
echo.
echo La pipeline stable va se declencher automatiquement.
echo Verifie ici: https://github.com/Etoile-Bleu/spotify-release/actions
echo.
pause
