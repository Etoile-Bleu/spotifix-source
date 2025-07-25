@echo off
echo ====================================
echo    TEST DE LA PIPELINE
echo ====================================
echo.

echo [1] Push d'un commit pour tester nightly...
git add .
git commit -m "Test nightly build"
git push origin master

echo.
echo [2] Pour tester une release stable:
echo git tag v1.0.0
echo git push origin v1.0.0

echo.
echo ✅ Pipeline lancee!
echo Verifie l'onglet Actions sur GitHub: https://github.com/Etoile-Bleu/spotify-release/actions
echo.
pause
