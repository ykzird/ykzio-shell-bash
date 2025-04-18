#!/usr/bin/env bash

set -euo pipefail

# =============================================================================
# MAIN SCRIPT ENTRY
# =============================================================================
# Script Name: ykzio-shell.sh
# Description: Management tool using gum for interactivity (modular version).
# Author: Ykzio
# Version: 3.0.0
# =============================================================================

# Resolve script root directory
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

source .env
# Load environment variables
LOG_DIR="${SCRIPT_DIR}/${LOG_DIR}"
CONFIG_DIR="${SCRIPT_DIR}/${CONFIG_DIR}"

# Load modules
source "${SCRIPT_DIR}/modules/logging.sh"
source "${SCRIPT_DIR}/modules/config.sh"
source "${SCRIPT_DIR}/modules/packages.sh"
source "${SCRIPT_DIR}/modules/menu.sh"
source "${SCRIPT_DIR}/modules/utils.sh"

# Initialize
trap 'cleanup' EXIT
parse_cli_args "$@"
check_sudo
init_logging

main_loop() {
    while true; do
        trace "Entering main_loop"
        show_header

        if [ ! -f "$CONFIG_FILE" ]; then
            trace "Config file not found, showing init menu"
            show_init_menu
            gum style --foreground 202 "Checking for config directory presence"
            check_and_create_dir "$CONFIG_DIR"
            check_and_create_config_file
        else
            local menu_choice
            trace "Displaying main menu"
            menu_choice=$(show_menu)
            process_menu "$menu_choice"
            trace "Processed menu choice: $menu_choice"
        fi

        trace "Exiting main_loop"
    done
}

main_loop