#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments

ARGUMENTS=(atomName tokenId INSTALL_DIR)
OPT_ARGUMENTS=(proxyHost proxyPort proxyUser proxyPassword WORK_DIR JRE_HOME JAVA_HOME TMP_DIR)

if [ -z "${INSTALL_DIR}" ]
then
      INSTALL_DIR=/var/boomi
fi


inputs "$@"

if [ "$?" -gt "0" ]
then
       return 255;
fi

if [ ! -f ./gateway_install64.sh ]; then
  echoee "gateway_install64.sh introuvable. Téléchargez-le d'abord depuis platform.gb.boomi.com."
  return 255
fi

if ! command -v java >/dev/null 2>&1; then
  echoee "Java introuvable. Installez JRE 11+ avant de continuer."
  return 255
fi
_java_ver=$(java -version 2>&1 | grep -oE '"[0-9]+(\.[0-9]+)+"' | tr -d '"' | head -1)
_java_major=$(echo "${_java_ver}" | cut -d. -f1)
[ "${_java_major}" = "1" ] && _java_major=$(echo "${_java_ver}" | cut -d. -f2)
if [ "${_java_major:-0}" -lt 11 ] 2>/dev/null; then
  echoee "Java ${_java_major} détecté. Boomi requiert Java 11+."
  return 255
fi
echoi "Java ${_java_major} détecté — OK."

installDir=${INSTALL_DIR}
mkdir -p $installDir
ATOM_HOME=$installDir/Gateway_$atomName

optionParams=""
if [ ! -z "${WORK_DIR}" ]
then
     optionParams="${optionParams} -VworkPath=${WORK_DIR}"
fi

if [ ! -z "${JRE_HOME}" ]
then
     optionParams="${optionParams} -VjrePath=${JRE_HOME}"
fi

if [ ! -z "${JAVA_HOME}" ]
then
     optionParams="${optionParams} -VjavaPath=${JAVA_HOME}"
fi

if [ ! -z "${TMP_DIR}" ]
then
     optionParams="${optionParams} -VtmpPath=${TMP_DIR}"
fi

proxyParams=""
if [ ! -z "${proxyHost}" ]
then
	proxyParams="${proxyParams} -VproxyHost=${proxyHost}"
fi

if [ ! -z "${proxyPort}" ]
then
	proxyParams="${proxyParams} -VproxyPort=${proxyPort}"
fi

if [ ! -z "${proxyUser}" ]
then
	proxyParams="${proxyParams} -VproxyUser=${proxyUser}"
fi

if [ ! -z "${proxyPassword}" ]
then
	proxyParams="${proxyParams} -VproxyPassword=${proxyPassword}"
fi


./gateway_install64.sh -q -console  \
-VinstallToken=$tokenId \
-VatomName=$atomName \
-dir $installDir \
${proxyParams} ${optionParams}


# update container properties
input="conf/gateway_container.properties"
while IFS= read -r line; do echo "$line" >> ${ATOM_HOME}/conf/container.properties; done  < "$input"
