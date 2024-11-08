#!/bin/bash

source ./bin/common.sh
source ./bin/exports.sh


while : ; do

clear

tput cup 2 	3; echo -ne  "\033[46;30m              BOOMI INSTALLER               \e[0m"

tput cup 5  3; echo_cyan "a. Editer la configuration"

tput cup 7  3; 	case $atomType in
				"ATOM") 	if [ -f ./atom_install64.sh ]; then echo_green "b. L'installer atom_install64.sh est téléchargé."; else echo_red "b. Télécharger l'installer atom_install64.sh"; fi;;
				"MOLECULE") if [ -f ./molecule_install64.sh ]; then echo_green "b. L'installer molecule_install64.sh est déjà téléchargé."; else echo_red "b. Télécharger l'installer molecule_install64.sh"; fi;;
				"GATEWAY")	if [ -f ./gateway_install64.sh ]; then echo_green "b. L'installer gateway_install64.sh est déjà téléchargé."; else echo_red "b. Télécharger l'installer gateway_install64.sh"; fi;;
				esac

tput cup 8  3; case $atomType in
				"ATOM") 	if [ -f "${INSTALL_DIR}/Atom_${atomName}/bin/atom" ]; then echo_green "c. l'Atom $atomName est installé"; else echo_red "c. Lancer l'instalation de l'Atom $atomName"; fi;;
				"MOLECULE") if [ -f "${INSTALL_DIR}/Molecule_${atomName}/bin/atom" ]; then echo_green "c. la molecule $atomName est installé"; else echo_red "c. Lancer l'instalation de la molecule $atomName"; fi;;
				"GATEWAY")  if [ -f "${INSTALL_DIR}/Gateway_${atomName}/bin/atom" ]; then echo_green "c. la gateway $atomName est installé"; else echo_red "c. Lancer l'instalation de la gateway $atomName"; fi;;
				esac

tput cup 10  3; if getent group "$service_group" >/dev/null 2>&1; then echo_green "d. Le groupe user '$service_group' existe."; else echo_red "d. Créer le groupe user '$service_group'."; fi
tput cup 11  3; if id -u "$service_user" >/dev/null 2>&1; then echo_green "e. Le user de service '$service_user' existe."; else echo_red "e. Créer le user de service '$service_user'."; fi
tput cup 12  3; if systemctl is-enabled "boomi-${atomName}.service" >/dev/null 2>&1; then echo_green "f. Le service Boomi '$atomName' est activé."; else echo_red "f. Créer le service Boomi '$atomName'."; fi

case $atomType in
	"ATOM")		tput cup 13  3; echo_green "-------------------ATOM-------------------";;
	"MOLECULE")	tput cup 13  3; if [ -f "${INSTALL_DIR}/Molecule_${atomName}/bin/restart-systemd.sh" ]; then echo_green "g. Le script de redémarrage 'restart-systemd.sh' existe."; else echo_red "g. Créer le script de redémarrage 'restart-systemd.sh'."; fi;;
	"GATEWAY")	tput cup 13  3; if [ -f "${INSTALL_DIR}/Gateway_${atomName}/bin/restart-systemd.sh" ]; then echo_green "g. Le script de redémarrage 'restart-systemd.sh' existe."; else echo_red "g. Créer le script de redémarrage 'restart-systemd.sh'."; fi;;
esac


tput cup 15  3; echo_cyan "u. Supprimer le service Boomi '$atomName'" 				
tput cup 17  3; echo_cyan "w. Désinstaller l'Atom $atomName"
tput cup 18  3; echo_cyan "x. Quitter"



read -n 1 y

case "$y" in

  a)
	tput reset
	clear
	nano ./bin/exports.sh
	source ./menu.sh
	;;

  b)
	tput reset
	clear
	case $atomType in
	"ATOM") if [ -f ./atom_install64.sh ]; then echo_green "L'installer atom_install64.sh est téléchargé."; else wget https://platform.boomi.com/atom/atom_install64.sh; chmod +x ./atom_install64.sh; fi;;
	"MOLECULE") if [ -f ./molecule_install64.sh ]; then echo_green "L'installer molecule_install64.sh est téléchargé."; else wget https://platform.boomi.com/atom/molecule_install64.sh; chmod +x ./molecule_install64.sh; fi;;
	"GATEWAY") if [ -f ./gateway_install64.sh ]; then echo_green "L'installer gateway_install64.sh est téléchargé."; else wget https://platform.boomi.com/atom/gateway_install64.sh; chmod +x ./gateway_install64.sh; fi;;
	esac
	read -p "Appuyez sur [ENTREE] pour continuer..."
	;;

  c)
  	tput reset
	clear
	case $atomType in
	"ATOM") 	ATOM_HOME=${INSTALL_DIR}/Atom_${atomName}
				installer_script="./bin/installAtom.sh"
				extra_args=""
				source bin/installerToken.sh atomType=${atomType};;
	"MOLECULE") ATOM_HOME=${INSTALL_DIR}/Molecule_${atomName}
				installer_script="./bin/installMolecule.sh"
				extra_args="WORK_DIR=\"${WORK_DIR}\" TMP_DIR=\"${TMP_DIR}\""
				source bin/installerToken.sh atomType=${atomType};;
	"GATEWAY") ATOM_HOME=${INSTALL_DIR}/Gateway_${atomName}
				installer_script="./bin/installGateway.sh"
				extra_args="WORK_DIR=\"${WORK_DIR}\" TMP_DIR=\"${TMP_DIR}\""
				source bin/installerToken.sh atomType=${atomType};;
	esac
	ATOM_HOME="${INSTALL_DIR}/${atomType}_${atomName}"
	echo ${installer_script}
	echo ${extra_args}
    ${installer_script} atomName="${atomName}" tokenId="${tokenId}" INSTALL_DIR="${INSTALL_DIR}" JRE_HOME="${JRE_HOME}" JAVA_HOME="${JAVA_HOME}" proxyHost="${proxyHost}" proxyPort="${proxyPort}" proxyUser="${proxyUser}" proxyPassword="${proxyPassword}" ${extra_args}
	source ./menu.sh
  	read -p "Appuyez sur [ENTREE] pour continuer..."
  	;;

  d)
  	tput reset
	clear
	echo_yellow "Cette version ne prend pas en charge la création de groupe (voir admin systéme)"
	#source ./bin/createUserGroup.sh
	read -p "Appuyez sur [ENTREE] pour continuer..."
	;;

  e)
  	tput reset
	clear
	echo_yellow "Cette version ne prend pas en charge la création de user (voir admin systéme)"
	#source ./bin/createUserService.sh
	read -p "Appuyez sur [ENTREE] pour continuer..."
	;;

  g)
    tput reset
    clear
	case $atomType in
		"MOLECULE") source ./bin/createRestarMoleculetSystemd.sh;;
		"GATEWAY")  source ./bin/createRestarGatewaySystemd.sh;;
	esac
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  f)
    tput reset
    clear
	case $atomType in
		"ATOM") 	source ./bin/createBoomiAtomService.sh;;
		"MOLECULE") source ./bin/createBoomiMoleculeService.sh;;
		"GATEWAY") source ./bin/createBoomiGatewayService.sh;;
	esac
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  u)
    tput reset
    clear
    sudo systemctl stop "boomi-${atomName}.service"
    sudo systemctl disable "boomi-${atomName}.service"
    sudo rm /etc/systemd/system/"boomi-${atomName}.service"
    sudo systemctl daemon-reload
    echo "Service Boomi '$atomName' removed."
	if sudo rm -f /etc/sudoers.d/boomi; then
  		echo_green "Sudoers file '/etc/sudoers.d/boomi' deleted successfully."
	else
  		echo_yellow "Warning: Failed to delete sudoers file '/etc/sudoers.d/boomi'."
	fi
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  w)
	tput reset
	clear
    # Check for both libraries in a single command
    if ! dpkg -s libcanberra-gtk-module libcanberra-gtk3-module &> /dev/null; then
      echo "Installing libcanberra libraries..."
      apt-get install libcanberra-gtk-module libcanberra-gtk3-module
    else
      echo "libcanberra libraries are already installed."
    fi
	case $atomType in
		"ATOM") 	ATOM_HOME=${INSTALL_DIR}/Atom_${atomName};;
		"MOLECULE") ATOM_HOME=${INSTALL_DIR}/Molecule_${atomName};;
		"GATEWAY")  ATOM_HOME=${INSTALL_DIR}/Gateway_${atomName};;
	esac
    /${ATOM_HOME}/uninstall -q -console
	rm *_install64.sh
	read -p "Appuyez sur [ENTREE] pour continuer..."
	;;

  x)
	tput reset
	clear
	exit 1
	;;
	
esac
done
