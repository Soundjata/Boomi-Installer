# Scripts d'installation Boomi

Ce répertoire contient des scripts shell utilisés pour installer et gérer les atomes et molécules Boomi sur les systèmes Linux.Ce répertoire contient des scripts shell utilisés pour installer et gérer les atomes et molécules Boomi sur les systèmes Linux.

## Scripts

- **`menu.sh`:** The main interactive menu script for the Boomi Installer. It provides options to configure the installation, download installers, install/uninstall Atoms/Molecules, manage the Boomi service, and more.

- **`bin/common.sh`:** Contains common functions and variables used by other scripts.

- **`bin/createBoomiService.sh`:** Creates a systemd service for the Boomi Atom/Molecule, enabling it to start automatically on boot and be managed with `systemctl`.

- **`bin/createUserGroup.sh`:** Creates the service group (`boomigroup`) and user (`boomiuser`) required for running the Boomi service.

- **`bin/createUserService.sh`:** Creates the Boomi service user.

- **`bin/deleteUserService.sh`:** Deletes the Boomi service user and group.

- **`bin/exports.sh`:** Stores configuration variables for the installer, such as the installation directory, Atom/Molecule name, service user details, etc.

- **`bin/installAtom.sh`:** Automates the installation of a Boomi Atom using the official installer script (`atom_install64.sh`).

- **`bin/installMolecule.sh`:** Automates the installation of a Boomi Molecule using the official installer script (`molecule_install64.sh`).

- **`bin/installerToken.sh`:** Handles the retrieval and storage of the Boomi installation token.

## Usage

1. **Configuration:** Edit `bin/exports.sh` to set the desired installation directory, Atom/Molecule name, and other configuration options.
2. **Run the installer:** Execute `./menu.sh` to start the interactive installation process.

## Configuration: `bin/exports.sh`

The `bin/exports.sh` file is crucial for configuring the Boomi Installer. It contains important variables that control various aspects of the installation process. 

**Key Variables:**

- **`atomType`:** Specifies whether you are installing an "ATOM" or "MOLECULE".
- **`atomName`:** The name of your Boomi Atom or Molecule.
- **`INSTALL_DIR`:** The directory where the Boomi Atom/Molecule will be installed.
- **`service_user`:** The username of the service user that will run the Boomi service.
- **`service_group`:** The group name for the service user.
- **`accountName`:** The name of your Boomi account.
- **`accountId`:** Your Boomi account ID.
- **`authToken`:** Your Boomi authentication token. **Important:** Keep this token secure!
- **`VERBOSE`:** Set to "true" to enable verbose output for debugging.
- **`SLEEP_TIMER`:** A delay (in seconds) between API calls to avoid rate limiting.

**Before running the installer:**

1. **Open `bin/exports.sh` in a text editor.**
2. **Carefully review and modify the variables according to your environment and requirements.**
3. **Save the changes.**

**Example:**

```bash
export atomType="ATOM"
export atomName="MyProductionAtom"
export INSTALL_DIR="/opt/boomi"

export service_user="boomiuser"
export service_group="boomigroup"

export accountName="MyCompany"
export accountId="mycompany-ABCD12"
export authToken="BOOMI_TOKEN..." 

export VERBOSE="false"
export SLEEP_TIMER=0.2
```

## Notes

- These scripts are provided as-is and may require modifications to suit your specific environment and requirements.
- Ensure that you have the necessary permissions to execute the scripts and make changes to the system.
- It's recommended to review the scripts and understand their functionality before running them.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.
