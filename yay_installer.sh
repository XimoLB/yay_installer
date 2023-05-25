#!/usr/bin/env bash

# Yay Installer for SteamOS by Ximo
# Version: 1.0.0

# Disclaimer:
# This work is licensed under the Creative Commons Atributions 4.0 Internacional License. To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.
# You are free to modify, distribute, and use this script for your own purposes, including commercial use, as long as proper attribution is given to the original author.

# The author retains the copyright and shall not be held liable for any issues or damages arising from the use of this script.
# This script is provided as-is, without any warranty.
# Use it at your own risk.

# This script installs yay on SteamOS, allowing you to easily manage AUR packages.

# Requirements:
#   - sudo: Required for executing commands with root privileges.
#   - zenity: Optional, for displaying graphical dialogs. Falls back to text output if not available.
#   - pacman: Package manager for SteamOS.
#   - ping: Required for checking network connectivity.
#   - curl: Required for downloading resources.

# Note: This script should be run on a SteamOS system.

# Description:
# This script automates the installation of Yay, a tool for managing AUR (Arch User Repository) packages on SteamOS. Yay provides an easy-to-use interface for searching, installing, and updating packages from the AUR.

# Usage:
# 1. Open a terminal on your SteamOS system.
# 2. Navigate to the directory where this script is located.
# 3. Run the script with optional language parameter: ./yay_installer.sh [language]
#    - The script should detect the language of the system, if no language is specified or avaible, it will default to English.
#    Example: ./yay_installer.sh en
# 4. Follow the prompts and provide any necessary input when prompted.
# 5. Once the installation is complete, you can use Yay to manage AUR packages.

# Important Note:
# - Ensure that you have an active internet connection before running this script.
# - This script may require sudo/root privileges to execute certain commands.
# - Make sure to review and verify the commands in this script before running it.

# Ensure that the script will exit if any commands fail and treat unset variables as an error
set -eu
# Enable 'pipefail' to cause a pipeline to fail if any command fails (even if it's not the last command)
set -o pipefail

# Available languages
declare -a available_languages=("en" "es")

# Set the language based on the system language or default to 'en'
if [ $# -gt 0 ] && [[ " ${available_languages[*]} " =~ " $1 " ]]; then
    language="$1"
else
    system_language=$(grep -oP "(?<=LANG=)[^\._]+" /etc/locale.conf 2>/dev/null || echo "")
    if [[ " ${available_languages[*]} " =~ " $system_language " ]]; then
        language="$system_language"
    else
        language="en"
    fi
fi

# Messages
declare -A messages
messages=(
    ["network_error_en"]="Could not establish a network connection. Please, check your network connection."
    ["file_protection_error_en"]="Failed to disable file system protection."
    ["installation_error_en"]="Could not install \$package."
    ["success_en"]="Yay installation was successful!"
    ["yay_error_en"]="Yay operation test failed."
    ["cloning_yay_en"]="Cloning the yay repository from AUR..."
    ["compiling_yay_en"]="Compiling and installing yay..."
    ["syncing_database_en"]="Syncing the package database..."
    ["command_needed_en"]="%s is necessary but is not installed. Please, install "
    ["yay_test_successful_en"]="Yay operation test successful."
    ["failed_yay_clone_en"]="Failed to clone the yay repository."
    ["failed_compile_install_en"]="Failed to compile and install yay."
    ["failed_db_sync_en"]="Failed to sync the package database."
    ["error_exec_cmd_en"]="Error executing command:"
    ["error_create_temp_en"]="Cannot create temporary directory."
    ["network_error_es"]="No se pudo establecer una conexión de red. Por favor, verifica tu conexión de red."
    ["file_protection_error_es"]="No se pudo desactivar la protección del sistema de archivos."
    ["installation_error_es"]="No se pudo instalar \$package."
    ["yay_error_es"]="Error en la prueba de funcionamiento de yay."
    ["success_es"]="¡La instalación de yay se ha completado con éxito!"
    ["cloning_yay_es"]="Clonando el repositorio yay desde AUR..."
    ["compiling_yay_es"]="Compilando e instalando yay..."
    ["syncing_database_es"]="Sincronizando la base de datos de paquetes..."
    ["command_needed_es"]="%s es necesario pero no está instalado. Por favor, instala "
    ["yay_test_successful_es"]="Prueba de funcionamiento de yay exitosa."
    ["failed_yay_clone_es"]="Falló la clonación del repositorio yay."
    ["failed_compile_install_es"]="Falló la compilación e instalación de yay."
    ["failed_db_sync_es"]="Falló la sincronización de la base de datos de paquetes."
    ["error_exec_cmd_es"]="Error ejecutando comando:"
    ["error_create_temp_es"]="No se puede crear el directorio temporal."
)

# Temporary directory for cloning and compiling yay
temp_dir=$(mktemp -d)

# Yay repository path
yay_repo="$temp_dir/yay"

# URL for code download page
download_url="https://aur.archlinux.org/yay.git"

# Set trap for cleanup
trap 'rm -rf "$temp_dir"' EXIT

# Function to display an error message and exit
show_error() {
    local message_key="$1"
    shift
    local args=("$@")
    if [[ -v "messages[$message_key]" ]]; then
        local message
        printf -v message "${messages[$message_key]}" "${args[@]}"
        if command -v zenity &>/dev/null; then
            zenity --error --text "$message" 2>/dev/null
        else
            printf "Error: %s\n" "$message" >&2
        fi
    else
        printf "Error: Undefined error message key: %s\n" "$message_key" >&2
    fi
    exit 1
}

# Function to display an informational message
show_message() {
    local message_key="$1"
    if [[ -v "messages[$message_key]" ]]; then
        local message="${messages[$message_key]}"
        if command -v zenity &>/dev/null; then
            zenity --info --text "$message" 2>/dev/null
        else
            printf "%s\n" "$message"
        fi
    else
        printf "Error: Undefined message key: %s\n" "$message_key" >&2
    fi
}

# Verify and execute a command, displaying an error message in case of failure
verify_execution() {
    local cmd=$*
    if ! eval "$@"; then
        local command_error_message="error_exec_cmd_$language $cmd"
        show_error "$command_error_message"
    fi
}

# Deactivate the file system protection
deactivate_file_system_protection() {
    if command -v steamos-readonly &>/dev/null; then
        if ! verify_execution "sudo steamos-readonly disable"; then
            show_error "file_protection_error_$language"
        fi
    fi
}

# Verify network connectivity
verify_network_connectivity() {
    if ! curl --silent --head "$download_url" >/dev/null; then
        show_error "network_error_$language"
    fi
}

# Verify yay operation
verify_yay_operation() {
    if command -v yay &>/dev/null && yay -V &>/dev/null; then
        show_message "yay_test_successful_$language"
    else
        show_error "yay_error_$language"
    fi
}

# Clone yay repository from AUR
clone_yay_repository() {
    show_message "cloning_yay_$language"
    if ! verify_execution "git clone -q $download_url $yay_repo"; then
        show_error "failed_yay_clone_$language"
    fi
}

# Compile and install yay
compile_install_yay() {
    pushd "$yay_repo"
    show_message "compiling_yay_$language"
    if ! verify_execution "makepkg -si --noconfirm"; then
        show_error "failed_compile_install_$language"
    fi
    popd
    # clean up unnecessary packages
    local orphaned_packages
    orphaned_packages=$(pacman -Qdtq)
    if [ -n "$orphaned_packages" ]; then
        verify_execution sudo pacman -Rns --noconfirm "$orphaned_packages"
    fi
}

# Sync the package database
sync_package_db() {
    show_message "syncing_database_$language"
    if ! verify_execution "sudo pacman -Sy --noconfirm"; then
        show_error "failed_db_sync_$language"
    fi
}

# Check the availability of necessary commands and dependencies
check_necessary_commands_and_dependencies() {
    local commands=("sudo" "pacman" "ping" "curl" "git")
    local dependencies=("base-devel" "go" "libarchive")

    for command in "${commands[@]}"; do
        if ! command -v "$command" &>/dev/null; then
            show_error "command_needed_$language" "$command" "$command"
        fi
    done

    for dependency in "${dependencies[@]}"; do
        if ! pacman -Qi "$dependency" >/dev/null 2>&1; then
            verify_execution "sudo pacman -S --noconfirm --needed $dependency"
        fi
    done
}

# Main function
main() {
    # Check the availability of necessary commands and dependencies
    check_necessary_commands_and_dependencies

    # Deactivate the file system protection
    deactivate_file_system_protection

    # Verify network connectivity
    verify_network_connectivity

    # Sync the package database
    sync_package_db

    # Clone yay repository from AUR
    clone_yay_repository

    # Compile and install yay
    compile_install_yay

    # Verify yay operation
    verify_yay_operation

    show_message "success_$language"
}

# Run the main function
main $@
