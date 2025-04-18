# modules/utils.sh

parse_cli_args() {
    for arg in "$@"; do
        case $arg in
            --debug)
                LOG_LEVEL=${LOG_LEVEL_DEBUG}
                shift
                ;;
            --trace)
                LOG_LEVEL=${LOG_LEVEL_TRACE}
                shift
                ;;
        esac
    done
}

check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        gum confirm "Script needs sudo privileges. Grant them?" || exit 1
        sudo -v
    fi
}

check_and_create_dir() {
  local dir_name="$1"

  if [[ -z "$dir_name" ]]; then
    echo "Error: No directory name provided to check_and_create_dir." >&2
    return 1
  fi

  if [[ -d "$dir_name" ]]; then
    echo "Directory already exists: $dir_name"
    return 0
  fi

  mkdir -p "$dir_name"
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create directory: $dir_name" >&2
    return 1
  fi

  echo "Directory created: $dir_name"
  return 0
}


wait_for_apt_lock() {
    source .env
    local timeout=${TIMEOUT}
    local waited=0
    local wait_message="Waiting for dpkg/apt lock to be released..."
    while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
          fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
          fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
        gum style --foreground 214 "$wait_message"
        sleep 2
        waited=$((waited + 2))
        if [ $waited -ge $timeout ]; then
            gum style --foreground 196 "Timeout: APT lock was not released within ${timeout}s. Exiting."
            exit 1
        fi
    done
}

show_header() {
    BLUE="#003eff"
    PURPLE="#c100ff"

    clear
    gum style --foreground="$BLUE" --border-foreground="$PURPLE" --border double --align center --width 50 --margin "1 2" --padding "2 4" "${SCRIPT_NAME} - v3.0.0"

    {
        echo ""
        printf "Logged in as:        %s\n" "$(whoami)"
        log $LOG_LEVEL_INFO "[utils] Logged in as: $(whoami)"
        printf "Date and Time:       %s\n" "$(date '+%A %d/%m/%y - %T')"

        if [[ -s "$CONFIG_FILE" ]]; then
            jq -r '.updates.last_update' "$CONFIG_FILE" | \
                xargs -I{} printf "Last Update:         %s\n" "{}"
        else
            echo "Last Update:         not available"
        fi
    }
}
