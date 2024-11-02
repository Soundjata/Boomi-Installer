#!/bin/bash

# Source les fichiers de configuration et fonctions communes
source ./bin/exports.sh
source ./bin/common.sh

# Fonction pour afficher le menu principal
show_main_menu() {
    clear
    echo "=== Menu d'installation Boomi ==="
    echo "1. Configuration"
    echo "2. Télécharger les installateurs"
    echo "3. Installer Atom/Molecule"
    echo "4. Désinstaller Atom/Molecule"
    echo "5. Gérer le service Boomi"
    echo "6. Gérer les utilisateurs"
    echo "7. Afficher la configuration"
    echo "8. Quitter"
    echo "================================"
    echo -n "Choisissez une option (1-8): "
}

# Sous-menu de configuration
show_config_menu() {
    clear
    echo "=== Configuration ==="
    echo "1. Définir le type (ATOM/MOLECULE)"
    echo "2. Définir le nom"
    echo "3. Définir le répertoire d'installation"
    echo "4. Configurer le compte Boomi"
    echo "5. Configurer le token"
    echo "6. Retour au menu principal"
    echo "======================"
    echo -n "Choisissez une option (1-6): "
}

# Sous-menu de gestion du service
show_service_menu() {
    clear
    echo "=== Gestion du Service ==="
    echo "1. Démarrer le service"
    echo "2. Arrêter le service"
    echo "3. Redémarrer le service"
    echo "4. Afficher le statut"
    echo "5. Activer le démarrage automatique"
    echo "6. Désactiver le démarrage automatique"
    echo "7. Retour au menu principal"
    echo "========================="
    echo -n "Choisissez une option (1-7): "
}

# Sous-menu de gestion des utilisateurs
show_user_menu() {
    clear
    echo "=== Gestion des Utilisateurs ==="
    echo "1. Créer l'utilisateur de service"
    echo "2. Créer le groupe"
    echo "3. Supprimer l'utilisateur"
    echo "4. Supprimer le groupe"
    echo "5. Retour au menu principal"
    echo "============================="
    echo -n "Choisissez une option (1-5): "
}

# Fonction pour configurer le type d'installation
configure_type() {
    clear
    echo "Type actuel: $atomType"
    echo -n "Entrez le nouveau type (ATOM/MOLECULE): "
    read new_type
    if [[ "$new_type" == "ATOM" || "$new_type" == "MOLECULE" ]]; then
        sed -i "s/export atomType=.*/export atomType=\"$new_type\"/" ./bin/exports.sh
        echo "Type mis à jour."
    else
        echo "Type invalide. Utilisez ATOM ou MOLECULE."
    fi
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction pour installer Atom/Molecule
install_boomi() {
    if [[ "$atomType" == "ATOM" ]]; then
        ./bin/installAtom.sh
    else
        ./bin/installMolecule.sh
    fi
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction principale
main() {
    while true; do
        show_main_menu
        read choice

        case $choice in
            1)  # Menu Configuration
                while true; do
                    show_config_menu
                    read config_choice
                    case $config_choice in
                        1) configure_type ;;
                        2) echo "Implémentation de la configuration du nom..." ;;
                        3) echo "Implémentation de la configuration du répertoire..." ;;
                        4) echo "Implémentation de la configuration du compte..." ;;
                        5) ./bin/installerToken.sh ;;
                        6) break ;;
                        *) echo "Option invalide" ;;
                    esac
                done
                ;;
                
            2)  # Téléchargement des installateurs
                echo "Téléchargement des installateurs..."
                # Implémenter la logique de téléchargement
                ;;
                
            3)  # Installation
                install_boomi
                ;;
                
            4)  # Désinstallation
                echo "Désinstallation de Boomi..."
                # Implémenter la logique de désinstallation
                ;;
                
            5)  # Menu Service
                while true; do
                    show_service_menu
                    read service_choice
                    case $service_choice in
                        1) systemctl start boomi ;;
                        2) systemctl stop boomi ;;
                        3) systemctl restart boomi ;;
                        4) systemctl status boomi ;;
                        5) systemctl enable boomi ;;
                        6) systemctl disable boomi ;;
                        7) break ;;
                        *) echo "Option invalide" ;;
                    esac
                    read -p "Appuyez sur Entrée pour continuer..."
                done
                ;;
                
            6)  # Menu Utilisateurs
                while true; do
                    show_user_menu
                    read user_choice
                    case $user_choice in
                        1) ./bin/createUserService.sh ;;
                        2) ./bin/createUserGroup.sh ;;
                        3) ./bin/deleteUserService.sh ;;
                        4) echo "Suppression du groupe..." ;;
                        5) break ;;
                        *) echo "Option invalide" ;;
                    esac
                    read -p "Appuyez sur Entrée pour continuer..."
                done
                ;;
                
            7)  # Afficher la configuration
                clear
                echo "=== Configuration actuelle ==="
                echo "Type: $atomType"
                echo "Nom: $atomName"
                echo "Répertoire: $INSTALL_DIR"
                echo "Utilisateur: $service_user"
                echo "Groupe: $service_group"
                echo "Compte: $accountName"
                echo "ID Compte: $accountId"
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
                
            8)  # Quitter
                echo "Au revoir!"
                exit 0
                ;;
                
            *)  echo "Option invalide"
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
        esac
    done
}

# Démarrage du script
main
