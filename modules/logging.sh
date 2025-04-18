# modules/logging.sh

LOG_FILE=""
DEBUG_LOG_FILE=""
LOG_LEVEL=${LOG_LEVEL_INFO:-1}

readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3
readonly LOG_LEVEL_TRACE=-1
source .env
DEBUG_LOG_MAX_SIZE=${DEBUG_LOG_MAX_SIZE}

init_logging() {
    mkdir -p "$LOG_DIR"
    LOG_FILE="${LOG_DIR}/$(date '+%Y%m%d-%H%M%S').log"
    DEBUG_LOG_FILE="${LOG_DIR}/debug.log"

    # Validate LOG_LEVEL
    if ! [[ $LOG_LEVEL =~ ^-?[0-3]$ ]]; then
        LOG_LEVEL=$LOG_LEVEL_INFO
        echo "Invalid LOG_LEVEL. Defaulting to INFO level." >> "$LOG_FILE"
    fi

    touch "$LOG_FILE"

    if [[ -f "$DEBUG_LOG_FILE" && $(stat -c%s "$DEBUG_LOG_FILE") -ge $DEBUG_LOG_MAX_SIZE ]]; then
        mv "$DEBUG_LOG_FILE" "$DEBUG_LOG_FILE.$(date '+%Y%m%d-%H%M%S')"
    fi
    touch "$DEBUG_LOG_FILE"
}

log() {
    local level=$1
    local message=$2
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    local level_str=""
    case $level in
        $LOG_LEVEL_TRACE) level_str="TRACE" ;;
        $LOG_LEVEL_DEBUG) level_str="DEBUG" ;;
        $LOG_LEVEL_INFO)  level_str="INFO" ;;
        $LOG_LEVEL_WARN)  level_str="WARN" ;;
        $LOG_LEVEL_ERROR) level_str="ERROR" ;;
    esac

    if [ $level -ge $LOG_LEVEL ]; then
        echo "[$timestamp] [$SCRIPT_NAME] [$level_str] $message" >> "$LOG_FILE"
        [[ $LOG_LEVEL -le $LOG_LEVEL_DEBUG ]] && echo "[$timestamp] [$SCRIPT_NAME] [$level_str] $message" >> "$DEBUG_LOG_FILE"
        [[ $LOG_LEVEL -le $LOG_LEVEL_TRACE ]] && echo "[$timestamp] [$SCRIPT_NAME] [$level_str] $message"
    fi

    # Log errors explicitly
    if [[ $level -eq $LOG_LEVEL_ERROR ]]; then
        echo "[$timestamp] [$SCRIPT_NAME] [ERROR] $message" >> "$LOG_FILE"
    fi
}

trace() {
    local message=$1
    log $LOG_LEVEL_TRACE "[TRACE] $message"
}

cleanup() {
    local exit_code=$?
    log $LOG_LEVEL_INFO "Script ended with exit code: $exit_code"
    exit $exit_code
}
