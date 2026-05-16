#!/bin/bash
# ========================================
# check_memory.sh - Memory Usage Monitor
# ========================================

source "$HOME/server-health-monitor/config.conf"

check_memory() {
    # Ambil memory info
    TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    USED=$(free -m | awk '/Mem:/ {print $3}')
    MEMORY_USAGE=$(awk "BEGIN {printf \"%d\", ($USED/$TOTAL)*100}")

    if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
        echo "❌ Memory      : ${MEMORY_USAGE}% (${USED}MB / ${TOTAL}MB) — WARNING! (threshold: ${MEMORY_THRESHOLD}%)"
        return 1
    else
        echo "✅ Memory      : ${MEMORY_USAGE}% (${USED}MB / ${TOTAL}MB)"
        return 0
    fi
}

check_memory
