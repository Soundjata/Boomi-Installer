# Boomi Installer Scripts

This directory contains shell scripts used for installing and managing Boomi Atoms and Molecules on Linux systems.

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

## Notes

- These scripts are provided as-is and may require modifications to suit your specific environment and requirements.
- Ensure that you have the necessary permissions to execute the scripts and make changes to the system.
- It's recommended to review the scripts and understand their functionality before running them.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.
