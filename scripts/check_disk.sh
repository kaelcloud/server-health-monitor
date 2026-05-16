#!/bin/bash
# ========================================
# check_disk.sh - Disk Usage Monitor
# ========================================

source "$HOME/server-health-monitor/config.conf"

check_disk() {
    # Check semua mounted partitions
    STATUS=0

    while IFS= read -r line; do
        USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
        MOUNT=$(echo "$line" | awk '{print $6}')

        if [ "$USAGE" -ge "$DISK_THRESHOLD" ]; then
            echo "❌ Disk $MOUNT   : ${USAGE}% — WARNING! (threshold: ${DISK_THRESHOLD}%)"
            STATUS=1
        else
            echo "✅ Disk $MOUNT   : ${USAGE}%"
        fi
    done < <(df -h | grep '^/dev/' | awk '{print $1, $2, $3, $4, $5, $6}')

    return $STATUS
}

check_disk
