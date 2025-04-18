# modules/packages.sh

source .env
readonly packages=(${PACKAGES})

manage_required_packages() {
    log $LOG_LEVEL_DEBUG "[manage_required_packages] Debugging package management."
    wait_for_apt_lock
    if [[ $LOG_LEVEL -eq $LOG_LEVEL_DEBUG ]]; then
        sudo apt-get update -qq
    else
        gum spin --spinner dot --title "Updating package lists" -- sudo apt-get update -qq || true
    fi

    local missing_packages=()
    for pkg in "${packages[@]}"; do
        if ! dpkg -l | grep -qw "$pkg"; then
            [[ "$pkg" == "awk" ]] && pkg="gawk"
            missing_packages+=("$pkg")
        else
            echo "$pkg is already installed."
        fi
    done

    for pkg in "${missing_packages[@]}"; do
        if [[ $LOG_LEVEL -eq $LOG_LEVEL_DEBUG ]]; then
            wait_for_apt_lock
            sudo apt-get install -y "$pkg"
        else
            gum spin --spinner dot --title "Installing $pkg" -- bash -c "wait_for_apt_lock && sudo apt-get install -y $pkg > /dev/null 2>&1 || true"
        fi
    done
}
