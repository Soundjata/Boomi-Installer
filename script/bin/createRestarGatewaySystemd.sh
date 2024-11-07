#!/bin/bash

# Source the exports file to get variable definitions
#source ./bin/exports.sh

sudo_content="
${service_user} ALL=NOPASSWD: /bin/systemctl start boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl stop boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl restart boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl status boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p ActiveState boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p SubState boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p ExecMainPID boomi-*.service
"

echo_yellow "Ajout des permissions sudo pour le user Boomi..."
echo "$sudo_content" | sudo tee -a /etc/sudoers.d/boomi > /dev/null
echo_green "Permissions sudo ajoutées avec succès."


# Construct the script file path
ATOM_HOME="${INSTALL_DIR}/Gateway_${atomName}"
script_file="${INSTALL_DIR}/Gateway_${atomName}/bin/restart-systemd.sh"
service_name="boomi-${atomName}"

# Construct the script content
script_content='#!/bin/sh
# ENV variables
# LOCALHOST_ID - set if script is invoked by a cluster node.
# service_name - set based on systemd service definition file. e.g. "'${service_name}'" for "'${service_name}'.service"
restart_log="restart${LOCALHOST_ID}.log"
service_name="'${service_name}'"

service_start() {
  log_info "Starting Atom via systemd"
  sudo /bin/systemctl start $service_name
  if [ $returnCode -eq 0 ];then
    log_info " > Successfully started Atom service ($returnCode)"
  else
    log_warn " > Atom service not started ($returnCode).. sleeping 5sec.."
    sleep 5
  fi
}

service_stop() {
  log_info "Stopping Atom via systemd"
  sudo /bin/systemctl stop $service_name
  returnCode=$?
  if [ $returnCode -eq 0 ];then
    log_info " > Successfully stopped Atom service ($returnCode)"
  else
    log_warn " > Atom service not stopped ($returnCode).. sleeping 5sec.."
    sleep 5
  fi
}

service_status() {
  local status=1
  log_info "Checking systemd status"
  ActiveState=$(sudo /bin/systemctl show -p ActiveState $service_name)
  log_info " > $ActiveState"
  if [ $ActiveState = "ActiveState=active" ];then
    SubState=$(sudo /bin/systemctl show -p SubState $service_name)
    log_info " > $SubState"
    if [ $SubState = "SubState=running" ];then
      ExecMainPID=$(sudo /bin/systemctl show -p ExecMainPID $service_name)
      log_info " > $ExecMainPID"
      if [ $ExecMainPID = "ExecMainPID=0" ];then
        log_warn " > Issue with PID detection identified. Please check the state of the Atom and systemd manually"
      fi
      status=0
    fi
  fi
  echo $status
}

log_info() {
  log "[INFO]" "$1"
}

log_err() {
  log "[ERROR]" "$1"
}

log_warn() {
  log "[WARNING]" "$1"
}

log() {
  datestring=`date`
  echo -e "$datestring $1: $2" >> "${restart_log}" 2>&1
}

echo "=====================================================================" >> "${restart_log}" 2>&1
log_info "Initiating shutdown sequence.."
#Attempt shutdown via systemd
service_stop
#Check status of atom and if not stopped, try to stop it manually
for i in 1 2 3 4 5; do
  log_info "Checking Atom Status (Attempt $i)"createRestartSystemd
  log_info " > $returnMessage - Code: $returnCode"
  if [ $returnCode -ne 0 ];then
    log_info " > Atom stopped successfully"
    atom_status="stopped"
    break
  else
    atom_status="running"
    log_info " > Atom still running.. sleeping 5sec.."
    sleep 5
  fi
  if [ $atom_status != "stopped" ];then
  log_info "Stopping Atom via atom command"
  returnMessage=$(./atom stop)
  returnCode=$?
  log_info " > $returnMessage - Code: $returnCode"
  fi
done
if [ $atom_status != "stopped" ];then
  log_err "Failure to stop Atom, please check manually"
  exit 1
fi

log_info "Initiating startup sequence.."
#Attempt start via systemd
service_start

#Check systemd service
for i in 1 2 3 4 5; do
  service_status=$(service_status)
  if [ $service_status != 0 ];then
    log_err "Failed to start systemd service.. sleeping 5sec.."
    sleep 5
  else
    break
  fi
done

#Check atom. If not started attempt to start manually and then trigger systemd start again
for i in 1 2 3 4 5; do
  log_info "Checking Atom Status (Attempt $i)"
  returnMessage=$(./atom status)
  returnCode=$?
  log_info " > $returnMessage - Code: $returnCode"
  if [ $returnCode -eq 0 ];then
    log_info " > Atom started successfully"
    atom_status="running"
    break
  else
    atom_status="stopped"
    log_info " > Atom not started yet.. sleeping 20sec.."
    sleep 20
  fi
done
if [ $atom_status != "running" ];then
  log_info "Starting Atom via atom command"
  returnMessage=$(./atom start)
  returnCode=$?
  log_info "  > $returnMessage - Code: $returnCode"
fi
if [ $service_status -ne 0 && $atom_status != "running" ];then
  log_err "Warning, something went wrong! Please check the state of the Atom and systemd manually as they may be out of sync"
else
  log_info "Restart request completed successfully!"
fi'

# Write the content to the script file
echo "$script_content" > "$script_file"

# Change ownership of the installation directory
chown -R "$service_user":"$service_group" "$script_file"

# Make the script executable
chmod +x "$script_file"

# update container properties
#input="conf/molecule_container.properties"
##while IFS= read -r line; do echo "$line" >> ${ATOM_HOME}/conf/container.properties; done  < "$input"

echo "Restart script created at: $script_file"
