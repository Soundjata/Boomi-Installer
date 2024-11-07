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

installDir=${INSTALL_DIR}
ATOM_HOME=$installDir/Gateway_$atomName

optionParams=""
if [ -z "${WORK_DIR}" ]
then
     optionParams="${optionParams} -VworkPath='${WORK_DIR}'"
fi

if [ -z "${JRE_HOME}" ]
then
     optionParams="${optionParams} -VjrePath='${JRE_HOME}'" 
fi

if [ -z "${JAVA_HOME}" ]
then
     optionParams="${optionParams} -VjavaPath='${JAVA_HOME}'"
fi

if [ -z "${TMP_DIR}" ]
then
     optionParams="${optionParams} -VtmpPath='${TMP_DIR}'"
fi

proxyParams=""
if [ ! -z "${proxyHost}" ]
then
	proxyParams="${proxyParams} -VproxyHost='${proxyHost}'"
fi

if [ ! -z "${proxyPort}" ]
then
	proxyParams="${proxyParams} -VproxyPort='${proxyPort}'"
fi

if [ ! -z "${proxyUser}" ]
then
	proxyParams="${proxyParams} -VproxyUser='${proxyUser}'"
fi

if [ ! -z "${proxyPassword}" ]
then
	proxyParams="${proxyParams} -VproxyPassword='${proxyPassword}'"
fi


./gateway_install64.sh -q -console  \
-VinstallToken=$tokenId \
-VatomName=$atomName \
-dir $installDir 


# update container properties
input="conf/gateway_container.properties"
while IFS= read -r line; do echo "$line" >> ${ATOM_HOME}/conf/container.properties; done  < "$input"

${ATOM_HOME}/bin/atom restart