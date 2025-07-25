@echo off
echo ====================================
echo    KEYSTORE VIA ANDROID STUDIO
echo ====================================
echo.

echo On va utiliser Android Studio pour creer le keystore.
echo.
echo 📱 ETAPES DANS ANDROID STUDIO:
echo.
echo 1. Ouvre Android Studio
echo 2. Build → Generate Signed Bundle / APK
echo 3. Choisis APK → Next
echo 4. Clic sur "Create new..." pour le Key store path
echo 5. Choisis l'emplacement: E:\Spotifix\spotify-keystore.jks
echo 6. Remplis:
echo    - Password: bozo
echo    - Confirm: bozo
echo    - Key alias: spotify
echo    - Key password: bozo
echo    - Confirm: bozo
echo    - Validity: 25 (years)
echo    - Certificate info: (remplis ce que tu veux)
echo 7. Clic OK → Next → Finish
echo.
echo Une fois cree, reviens ici et appuie sur ENTREE...
pause

echo.
echo Conversion du keystore en base64...
if exist "spotify-keystore.jks" (
    powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('spotify-keystore.jks')) | Out-File -Encoding ASCII keystore-b64.txt"
    echo ✅ Conversion reussie!
    echo.
    echo 🔑 INFORMATIONS:
    echo - Keystore: spotify-keystore.jks
    echo - Password: bozo
    echo - Alias: spotify
    echo - Base64: keystore-b64.txt
    echo.
    echo 📋 LANCE MAINTENANT:
    echo .\setup_secrets.bat
) else (
    echo ❌ Fichier spotify-keystore.jks non trouve!
    echo Assure-toi de l'avoir sauvegarde dans E:\Spotifix\
)

echo.
pause
