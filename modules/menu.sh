# modules/menu.sh

show_init_menu() {
    gum style --foreground 202 "First-time setup detected. Checking prerequisites..."
    gum style --foreground 202 "Checking for config directory presence..."
    check_and_create_dir "$CONFIG_DIR"
    gum style --foreground 202 "Checking and creating configuration file..."
    check_and_create_config_file
    gum style --foreground 202 "Installing required packages..."
    manage_required_packages
    gum style --foreground 46 "All required packages are installed."
    sleep 1
}

show_menu() {
    gum choose "Check for updates" "Perform package upgrade" "Option 3" "Exit"
}

process_menu() {
    local choice="$1"

    case "$choice" in
        "Check for updates")
            log $LOG_LEVEL_INFO "[show_menu] Checking for updates..."
            run_update_cmd
            [ $? -eq 0 ] && gum style --foreground 46 "System update completed successfully." || gum style --foreground 196 "System update failed."
            sleep 1
            ;;
        "Perform package upgrade")
            log $LOG_LEVEL_INFO "[show_menu] Performing package upgrade..."
            if [[ $LOG_LEVEL -eq $LOG_LEVEL_DEBUG ]]; then
                sudo apt-get upgrade -y || true
            else
                gum spin --spinner dot --title "Upgrading packages" -- sudo apt-get upgrade -y || true
            fi
            gum style --foreground 46 "Package upgrade complete."
            sleep 1
            ;;
        "Option 3")
            log $LOG_LEVEL_INFO "[show_menu] Option 3 selected"
            gum style --foreground 51 "Option 3 action here."
            ;;
        "Exit")
            log $LOG_LEVEL_INFO "[show_menu] Exiting script"
            exit 0
            ;;
    esac
}
