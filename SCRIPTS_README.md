# Scripts Spotifix

Ce dossier contient les scripts utiles pour le développement de Spotifix.

## 🔧 Scripts Principaux

### **🚀 Pipeline & Tests**
- `test_pipeline.bat` - Tester les builds nightly/stable
- `push_debug.bat` - Compiler et installer l'APK debug

### **🏷️ Gestion des Versions**
- `create_tag.bat` - Créer un tag pour release stable
- `auto_version.bat` - Versioning automatique (patch/minor/major)
- `manage_tags.bat` - Gérer les tags existants

### **🔑 Configuration**
- `keystore_final.bat` - Générer le keystore de signature
- `setup_secrets.bat` - Configurer les secrets GitHub
- `check_gitignore.bat` - Vérifier que les fichiers sensibles sont ignorés

## 📋 Utilisation

### Premier setup :
1. `keystore_final.bat` - Créer le keystore
2. `setup_secrets.bat` - Configurer GitHub
3. `test_pipeline.bat` - Tester la pipeline

### Développement quotidien :
- `push_debug.bat` - Build & install debug
- `create_tag.bat` - Publier une release

### Gestion des versions :
- `auto_version.bat` - Incrémentation automatique
- `manage_tags.bat` - Gérer les tags

## ⚠️ Fichiers Sensibles

Les fichiers suivants sont automatiquement ignorés par Git :
- `*.jks` (keystores)
- `keystore-b64.txt` (secrets)
- `*.apk` (binaires)
