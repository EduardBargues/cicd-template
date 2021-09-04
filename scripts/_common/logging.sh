log_action() {
    UPPER_ACTION=$(echo "$1" | tr a-z A-Z)
    echo "$UPPER_ACTION ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

export -f log_action
export -f log_key_value_pair