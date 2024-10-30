#!/bin/bash

source ./bin/common.sh
source ./bin/exports.sh

DOMAIN_TO_DNS=$( getent hosts $DOMAIN | awk '{ print $1 }' )
PUBLIC_IP=$( wget -qO- ipinfo.io/ip )

while : ; do

clear

tput cup 2 	3; echo -ne  "\033[46;30m              BOOMI INSTALLER               \e[0m"
tput cup 3 	3; echo -ne  "\033[46;30m                $PUBLIC_IP                  \e[0m"

tput cup 5 3; echo_cyan "a. Editer la configuration"

tput cup 7  3; if [ -f ./atom_install64.sh ]; then echo_green "b. L'installer atom_install64.sh est téléchargé."; else echo_red "b. Télécharger l'installer atom_install64.sh"; fi

tput cup 8  3; if [ -f "${INSTALL_DIR}/Atom_${atomName}/bin/atom" ]; then echo_green "c. l'Atom $atomName est installé"; else echo_red "c. Lancer l'instalation de l'Atom $atomName"; fi

tput cup 10 3; echo_cyan "w. Désinstaller l'Atom $atomName"
tput cup 11 3; echo_cyan "x. Quitter"



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
    if [ -f ./atom_install64.sh ]; then echo_green "L'installer atom_install64.sh est déjà téléchargé."; else wget https://platform.boomi.com/atom/atom_install64.sh; fi
    chmod +x ./atom_install64.sh
	read -p "Appuyez sur [ENTREE] pour continuer..."
	;;

  c)
  	tput reset
  	clear
  	ATOM_HOME=${INSTALL_DIR}/Atom_${atomName}
	source bin/installerToken.sh atomType=${atomType}
    ./bin/installAtom.sh atomName="${atomName}" tokenId="${tokenId}" INSTALL_DIR="${INSTALL_DIR}" JRE_HOME="${JRE_HOME}" JAVA_HOME="${JAVA_HOME}" proxyHost="${proxyHost}" proxyPort="${proxyPort}" proxyUser="${proxyUser}" proxyPassword="${proxyPassword}"
  	read -p "Appuyez sur [ENTREE] pour continuer..."
  	;;

  w)
	tput reset
    ATOM_HOME=${INSTALL_DIR}/Atom_${atomName}
    sudo apt-get install libcanberra-gtk-module libcanberra-gtk3-module
    sudo ./${ATOM_HOME}/uninstall -q -console
	read -p "Appuyez sur [ENTREE] pour continuer..."
	;;

  x)
	tput reset
	clear
	exit 1
	;;
	
esac
done
