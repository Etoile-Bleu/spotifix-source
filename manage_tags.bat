@echo off
echo ====================================
echo    GESTION DES TAGS
echo ====================================
echo.

echo Que veux-tu faire ?
echo [1] Lister les tags existants
echo [2] Supprimer un tag (local + remote)
echo [3] Voir les details d'un tag
echo [4] Comparer deux tags
echo [5] Quitter
echo.

set /p CHOICE="Choix (1-5): "

if "%CHOICE%"=="1" goto LIST_TAGS
if "%CHOICE%"=="2" goto DELETE_TAG
if "%CHOICE%"=="3" goto TAG_DETAILS
if "%CHOICE%"=="4" goto COMPARE_TAGS
if "%CHOICE%"=="5" goto END

echo ❌ Choix invalide
pause
exit /b 1

:LIST_TAGS
echo.
echo 📋 Tags existants (par date):
git tag --sort=-version:refname
echo.
pause
goto END

:DELETE_TAG
echo.
echo ⚠️  ATTENTION: Suppression d'un tag
echo.
git tag -l
echo.
set /p TAG_TO_DELETE="Entrez le tag a supprimer: "
if "%TAG_TO_DELETE%"=="" (
    echo ❌ Tag vide, annulation.
    pause
    goto END
)

echo.
echo Suppression locale...
git tag -d %TAG_TO_DELETE%

echo Suppression sur GitHub...
git push origin --delete %TAG_TO_DELETE%

echo ✅ Tag %TAG_TO_DELETE% supprime!
pause
goto END

:TAG_DETAILS
echo.
git tag -l
echo.
set /p TAG_NAME="Entrez le tag a examiner: "
if "%TAG_NAME%"=="" (
    echo ❌ Tag vide, annulation.
    pause
    goto END
)

echo.
echo 📝 Details du tag %TAG_NAME%:
git show %TAG_NAME% --stat
echo.
pause
goto END

:COMPARE_TAGS
echo.
git tag -l
echo.
set /p TAG1="Premier tag: "
set /p TAG2="Deuxieme tag: "

if "%TAG1%"=="" if "%TAG2%"=="" (
    echo ❌ Tags vides, annulation.
    pause
    goto END
)

echo.
echo 🔍 Differences entre %TAG1% et %TAG2%:
git diff %TAG1%..%TAG2% --stat
echo.
pause
goto END

:END
