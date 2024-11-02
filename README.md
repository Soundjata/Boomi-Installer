# Scripts d'installation Boomi

Ce répertoire contient des scripts shell utilisés pour installer et gérer les atomes et molécules Boomi sur les systèmes Linux.

## Scripts
- **`menu.sh`:** Script de menu interactif principal pour l'installateur Boomi. Il offre des options pour configurer l'installation, télécharger les installateurs, installer/désinstaller les Atomes/Molécules, gérer le service Boomi, et plus encore.
- **`bin/common.sh`:** Contient des fonctions et variables communes utilisées par d'autres scripts.
- **`bin/createBoomiService.sh`:** Crée un service systemd pour l'Atome/Molécule Boomi, permettant son démarrage automatique au démarrage et sa gestion avec `systemctl`.
- **`bin/createUserGroup.sh`:** Crée le groupe de service (`boomigroup`) et l'utilisateur (`boomiuser`) nécessaires pour exécuter le service Boomi.
- **`bin/createUserService.sh`:** Crée l'utilisateur du service Boomi.
- **`bin/deleteUserService.sh`:** Supprime l'utilisateur et le groupe du service Boomi.
- **`bin/exports.sh`:** Stocke les variables de configuration pour l'installateur, comme le répertoire d'installation, le nom de l'Atome/Molécule, les détails de l'utilisateur du service, etc.
- **`bin/installAtom.sh`:** Automatise l'installation d'un Atome Boomi en utilisant le script d'installation officiel (`atom_install64.sh`).
- **`bin/installMolecule.sh`:** Automatise l'installation d'une Molécule Boomi en utilisant le script d'installation officiel (`molecule_install64.sh`).
- **`bin/installerToken.sh`:** Gère la récupération et le stockage du jeton d'installation Boomi.

## Utilisation
Pour simplifier l'installation, vous pouvez utiliser la commande suivante qui téléchargera et exécutera le script d'installation principal :

```bash
bash <(wget -qO- https://raw.githubusercontent.com/Soundjata/Boomi-Installer/refs/heads/main/script/install.sh)
'''
1. **Configuration:** Modifiez `bin/exports.sh` pour définir le répertoire d'installation souhaité, le nom de l'Atome/Molécule et autres options de configuration.
2. **Lancer l'installateur:** Exécutez `./menu.sh` pour démarrer le processus d'installation interactif.

## Configuration: `bin/exports.sh`
Le fichier `bin/exports.sh` est crucial pour configurer l'installateur Boomi. Il contient des variables importantes qui contrôlent divers aspects du processus d'installation.

**Variables clés:**
- **`atomType`:** Spécifie si vous installez un "ATOM" ou une "MOLECULE".
- **`atomName`:** Le nom de votre Atome ou Molécule Boomi.
- **`INSTALL_DIR`:** Le répertoire où l'Atome/Molécule Boomi sera installé.
- **`service_user`:** Le nom d'utilisateur du service qui exécutera le service Boomi.
- **`service_group`:** Le nom du groupe pour l'utilisateur du service.
- **`accountName`:** Le nom de votre compte Boomi.
- **`accountId`:** Votre ID de compte Boomi.
- **`authToken`:** Votre jeton d'authentification Boomi. **Important:** Gardez ce jeton en sécurité!
- **`VERBOSE`:** Mettre à "true" pour activer la sortie détaillée pour le débogage.
- **`SLEEP_TIMER`:** Un délai (en secondes) entre les appels API pour éviter les limitations de taux.

**Avant de lancer l'installateur:**
1. **Ouvrez `bin/exports.sh` dans un éditeur de texte.**
2. **Examinez attentivement et modifiez les variables selon votre environnement et vos besoins.**
3. **Sauvegardez les modifications.**

**Exemple:**
```bash
export atomType="ATOM"
export atomName="MonAtomeProduction"
export INSTALL_DIR="/opt/boomi"
export service_user="boomiuser"
export service_group="boomigroup"
export accountName="MaSociete"
export accountId="masociete-ABCD12"
export authToken="BOOMI_TOKEN..." 
export VERBOSE="false"
export SLEEP_TIMER=0.2
```

## Notes
- Ces scripts sont fournis tels quels et peuvent nécessiter des modifications pour s'adapter à votre environnement et vos besoins spécifiques.
- Assurez-vous d'avoir les permissions nécessaires pour exécuter les scripts et apporter des modifications au système.
- Il est recommandé d'examiner les scripts et de comprendre leur fonctionnement avant de les exécuter.

## Contribution
Les contributions sont les bienvenues ! Si vous trouvez des problèmes ou avez des suggestions d'améliorations, n'hésitez pas à ouvrir une issue ou à soumettre une pull request.
