# modules/config.sh

source .env
CONFIG_FILE=$(echo "${CONFIG_FILE}" | tr -d '[:space:]')
CONFIG_DIR=$(echo "${CONFIG_DIR}" | tr -d '[:space:]')

check_and_create_config_file() {
    if [ ! -f "$CONFIG_FILE" ] || [ ! -s "$CONFIG_FILE" ]; then
        cat <<EOF > "$CONFIG_FILE"
{
  "meta": {
    "init_date": "$(date '+%Y-%m-%d')",
    "created_by": "$(whoami)"
  },
  "updates": {
    "last_update": "none",
    "last_upgrade": "none"
  }
}
EOF
    else
        log $LOG_LEVEL_DEBUG "[check_and_create_config_file] Config file already exists: $CONFIG_FILE"
    fi
}

run_update_cmd() {
    local new_timestamp current_last_update
    new_timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    if ! current_last_update=$(jq -r '.updates.last_update' "$CONFIG_FILE" 2>/dev/null); then
        log $LOG_LEVEL_ERROR "[run_update_cmd] Failed to parse $CONFIG_FILE. Ensure it is a valid JSON file."
        return 1
    fi

    if [[ "$current_last_update" != "$new_timestamp" ]]; then
        if jq --arg new_timestamp "$new_timestamp" '.updates.last_update = $new_timestamp' "$CONFIG_FILE" > "$TEMP_FILE"; then
            mv "$TEMP_FILE" "$CONFIG_FILE"
            log $LOG_LEVEL_INFO "[run_update_cmd] Config file updated successfully."
        else
            log $LOG_LEVEL_ERROR "[run_update_cmd] Error updating config file."
            [[ -f "$TEMP_FILE" ]] && rm "$TEMP_FILE"
            return 1
        fi
    fi

    if command -v gum >/dev/null 2>&1; then
        gum spin --spinner dot --title "Running apt-get update" -- sudo apt-get update -y || true
    else
        echo "Running apt-get update..."
        sudo apt-get update -y || true
    fi

    log $LOG_LEVEL_INFO "[run_update_cmd] System update completed."
}
