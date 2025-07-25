# 🏷️ Créer un Tag via GitHub Web

## Option 1: Page Releases
1. Va sur ton repo: https://github.com/Etoile-Bleu/spotify-release
2. Clique sur "Releases" (à droite)
3. Clique "Create a new release"
4. Dans "Tag version": tape `v1.0.0` (ou ta version)
5. Titre: `Spotifix v1.0.0`
6. Description: Notes de version
7. Clique "Publish release"

## Option 2: Via l'onglet Tags
1. Va dans ton repo
2. Clique sur "tags" (à côté de branches)
3. Clique "Create a new tag"
4. Tag: `v1.0.0`
5. Target: `master`
6. Clique "Create tag"

## ⚠️ Important
- Format: `v1.0.0` (avec le 'v' devant)
- Suit la norme SemVer: MAJOR.MINOR.PATCH
- Ex: v1.0.0, v1.0.1, v1.1.0, v2.0.0

## 🤖 Automatisation
Une fois le tag créé, GitHub Actions va:
1. Détecter le nouveau tag
2. Lancer le workflow `stable.yml`
3. Compiler l'APK stable
4. Créer une GitHub Release
5. Notifier Discord + Telegram
